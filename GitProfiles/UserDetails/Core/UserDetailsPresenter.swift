//
//  UserDetailsPresenter.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

protocol UserDetailsPresenter {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRows(numberOfRowsInSection section: Int) -> Int
    func getNibName(indexPath: IndexPath) -> String
    func configureCell(cell: GithubProfileCellConfigurable , indexPath: IndexPath)
    func getHeightForRow(indexPath: IndexPath) -> CGFloat
}

protocol UserDetailsView : AnyObject{
    func registerNibs(cells: [String])
    func reloadData()
    func titleNameToNavigation(title: String)
    func showSuccesOrError(bannerType:BannerType , title: String , description: String )
}

class UserDetailsPresenterImpl: UserDetailsPresenter {
    
    private var router: UserDetailsRouter?
    private weak var view: UserDetailsView?
    private var detailModels = [CellProtocol]()
    private var userInfo: WholeProfileModel
    private var store: GitProfileStore
    
    init(view: UserDetailsView ,
         router: UserDetailsRouter ,
         userInfo: WholeProfileModel ,
         store: GitProfileStore) {
        self.view = view
        self.router = router
        self.userInfo = userInfo
        self.store = store
    }
    
    func viewDidLoad() {
        view?.registerNibs(cells: ["BioTableCell" , "ImageAndFollowersCell" , "TextFieldAndSave"])
        fillWithModels()
        self.view?.titleNameToNavigation(title: userInfo.name)
        self.view?.reloadData()
    }
    
    func fillWithModels() {
        self.detailModels.append(userInfo.makeFollowerFollowingModel(img: self.userInfo.image))
        self.detailModels.append(userInfo.makeBio())
        self.detailModels.append(TextFieldAndButtonCellModel(note: userInfo.note ?? "", delegate: self))
    }
}

extension UserDetailsPresenterImpl {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(numberOfRowsInSection section: Int) -> Int {
        return detailModels.count
    }
    
    func getNibName(indexPath: IndexPath) -> String {
        return detailModels[indexPath.row].nibIdentifier
    }
    
    func configureCell(cell: GithubProfileCellConfigurable , indexPath: IndexPath) {
        cell.configure(with: detailModels[indexPath.row])
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        detailModels[indexPath.row].height
    }
}

extension UserDetailsPresenterImpl: TextFieldAndSaveDelegate {
    func didTapSave(note: String) {
        self.view?.showSuccesOrError(bannerType: .success,
                                     title: "Your note saved successfully",
                                     description: "note which you write saved locally.")
        self.store.saveNote(note: note, for: self.userInfo.id)
    }
}
