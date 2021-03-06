//
//  GitProfilesPresenter.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

protocol GitProfilesPresenter {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRows(numberOfRowsInSection section: Int) -> Int
    func getNibName(indexPath: IndexPath) -> String
    func configureCell(cell: GithubProfileCellConfigurable , indexPath: IndexPath)
    func getHeightForRow(indexPath: IndexPath) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
    func searchedWithText(text: String)
    func searchCanceled()
}

protocol GitProfilesView : AnyObject{
    func registerNibs(cells: [String])
    func reloadData()
    func showSuccesOrError(bannerType:BannerType , title: String , description: String )
}
//presenter must have view as weak , because not happend retain cycle. profile models and allModels are for search and everything if i want model
// but cellModel are for every cell. I prefer not to have 3 types of cell , because in second controller i used this protocol . it is better that one cell can some manipulations.

class GitProfilesPresenterImpl: GitProfilesPresenter  {
    
    private var router: GitProfilesRouter?
    private weak var view: GitProfilesView?
    private var profileModels = [GithubProfileCellModel]() {
        didSet {
            cellModels = profileModels
        }
    }
    private var allProfileModels = [GithubProfileCellModel]()
    private var cellModels = [CellProtocol]()
    private var gitUsers = [GitProfiles]()
    private var imageDispatchGroup = DispatchGroup()
    private var profileIconDictionary = [String: UIImage]()
    private var profilesWholeInfos = [WholeProfileModel]()
    private var store = GitProfileStore()
    
    init(view: GitProfilesView ,
         router: GitProfilesRouter) {
        self.view = view
        self.router = router
        store.delegate = self
    }
    // I know it is possible to give table cellModels (because cellModels has nib identifiers , but I prefer to look cell nibs in here.
    func viewDidLoad() {
        animationModels()
        fetchUsers()
        view?.registerNibs(cells: ["ProfileCell" , "ErrorNotHaveData"])
        view?.reloadData()
    }
    
    //it is for animating cell while it is loading.
    func animationModels() {
        self.profileModels = [GithubProfileCellModel(image: nil, username:  "", needNote: false, animate: true, colorInverted: false) , GithubProfileCellModel(image: nil, username:  "", needNote: false, animate: true, colorInverted: false) , GithubProfileCellModel(image: nil, username:  "", needNote: false, animate: true, colorInverted: false) , GithubProfileCellModel(image: nil, username:  "", needNote: false, animate: true, colorInverted: false)]
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }
    //I prefered to save all icons in dictionary and than get when it need.
    func getImageFromDictionaryIfCan(imgKey: String) -> UIImage {
        if self.profileIconDictionary.keys.contains(imgKey) {
            return self.profileIconDictionary[imgKey] ?? UIImage()
        }
        return UIImage()
    }
    
    func fetchUserSuccess(gitUsers: [GitProfiles]) {
        self.gitUsers = gitUsers
        gitUsers.forEach({self.loadImgAndSaveInDict(str: $0.avatar_url ?? "", userName: $0.login ?? "")})
        
        self.imageDispatchGroup.notify(queue: .global()) {
            self.profileModels = gitUsers.map({$0.makeProfileModel(img: self.getImageFromDictionaryIfCan(imgKey: $0.login ?? "")) })
            self.allProfileModels = self.profileModels
            gitUsers.enumerated().forEach({self.fetchUserDescr(urlString: $0.element.url ?? "", profile: $0.element , isLast: $0.offset == gitUsers.count - 1)})
        }
    }
    
    func fetchUsersFailed(failType: ErrorType) {
        switch failType {
        case .internetConnection:
            DispatchQueue.main.async {
                self.store.getProfiles()
            }
            checkIntConnectionEveryMinute()
        case .notHaveData:
            print("Data not wrapped or not have")
            DispatchQueue.main.async {
                self.store.getProfiles()
            }
        }
    }
    //it is main call , where I fetch all users. than save in core data . if internet is bad than try to fetch core data users. if it is empty than here is main error.
    func fetchUsers() {
        let net = Service.init()
        DispatchQueue.global(qos: .userInitiated).async{
            guard let url = URL(string: "https://api.github.com/users?since=0%E2%80%8B") else { return }
            net.get(url) { (users : Status) in
                switch users{
                case let .success(gitUsers):
                    guard let gitUsers = gitUsers as? [GitProfiles]  else {return}
                    self.fetchUserSuccess(gitUsers: gitUsers)
                case let  .fail(err):
                    self.fetchUsersFailed(failType: err)
                }
            }
        }
    }
    
    //because too many threads are trying to get here i prefer to use lock. swift lock is good , because one thread can go in here (it is like mutex)
    func loadImgAndSaveInDict(str: String , userName: String ){
        let lock = NSLock()
        imageDispatchGroup.enter()
        let url = URL(string: str)!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                self.profileIconDictionary[userName] = UIImage(data: data)
                self.imageDispatchGroup.leave()
            }
        }
        lock.unlock()
    }
    //I added this popup because it will be better if i saw what error is this.
    func loadErrorPopup() {
        DispatchQueue.main.async {
            self.view?.showSuccesOrError(bannerType: .error, title: "Error Happend", description: "We dont Have Data")
            self.cellModels = [ErrorForNotHaveDataCellModel()]
            self.reloadData()
        }
    }
    
    func successUserDetails(userDetails: UserDescription , profile: GitProfiles , isLast: Bool) {
        let pr = WholeProfileModel(id: profile.id ?? -1,
                                   username: profile.login ?? "UNKNOWN",
                                   image: self.getImageFromDictionaryIfCan(imgKey: profile.login ?? ""),
                                   note: "" ,
                                   follwer: userDetails.followers?.description ?? "",
                                   following: userDetails.following?.description ?? "",
                                   name: userDetails.name ?? "",
                                   company: userDetails.company ?? "",
                                   blog: userDetails.blog ?? "")
            let img = self.getImageFromDictionaryIfCan(imgKey: profile.login ?? "")
            if !self.store.profiles.contains(where: {$0.id == profile.id}) {
                DispatchQueue.main.async {
                    self.store.saveImage(data: (img.pngData()!)  , profile: pr , isLast: isLast)
                }
            }
        
    }
    
    func fetchUserDescr(urlString: String , profile: GitProfiles , isLast: Bool) {
        let net = Service.init()
        DispatchQueue.global(qos: .userInitiated).async{
            guard let url = URL(string: urlString) else { return }
            
            net.getUserDescription(url) { (userDescr : Status) in
                switch userDescr{
                case let .success(userDescr):
                    guard let userDetails = userDescr as? UserDescription else {return}
                    self.successUserDetails(userDetails: userDetails, profile: profile , isLast: isLast)
                case  .fail(_):
                    DispatchQueue.main.async {
                        self.store.getProfiles()
                    }
                }
            }
        }
    }
    
    // if this device not have internet i check connections in every 20 second , if internet is available everything will be loaded
    func checkIntConnectionEveryMinute() {
        if !Reachability.isConnectedToNetwork() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                self.checkIntConnectionEveryMinute()
            }
        }else{
            self.viewDidLoad()
        }
    }
}

//MARK store delegate methods
extension GitProfilesPresenterImpl: StoreDelegate {
    func didCatchAllData() {
        self.profileModels = self.store.profiles.enumerated().map({$0.element.makeModel(colorInverted: ($0.offset + 1) % 4 == 0)})
        self.allProfileModels = self.profileModels
        if allProfileModels.isEmpty && gitUsers.isEmpty {
            loadErrorPopup()
        }
        self.reloadData()
    }
    
    func didSaved() {
        DispatchQueue.main.async {
            self.store.getProfiles()
        }
    }
}
//Now i preffer that table view methods be here. because controller must not have model.
extension GitProfilesPresenterImpl {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func getNibName(indexPath: IndexPath) -> String {
        return cellModels[indexPath.row].nibIdentifier
    }
    
    func configureCell(cell: GithubProfileCellConfigurable , indexPath: IndexPath) {
        cell.configure(with: cellModels[indexPath.row])
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        cellModels[indexPath.row].height
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let model = self.profileModels[indexPath.row]
        if let u = store.profiles.filter({$0.username == model.username}).first{
            router?.didTapUser(userUrl: u, store: store )
        }
    }
}

extension GitProfilesPresenterImpl{
    func searchedWithText(text: String) {
        profileModels = text.isEmpty ? self.allProfileModels : allProfileModels.filter({$0.username.contains(text.lowercased())})
        view?.reloadData()
    }
    func searchCanceled() {
        profileModels = self.allProfileModels
        view?.reloadData()
    }
}
