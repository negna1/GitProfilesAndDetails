//
//  GitProfilesController.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

class GitProfilesController: UIViewController , GitProfilesView{
    var gitPresenter: GitProfilesPresenter!
    @IBOutlet weak var tableView: UITableView!
    lazy var searchBar = UISearchBar(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        configureVc()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        gitPresenter.viewDidLoad()
        
    }
    
    func registerNibs(cells: [String]) {
        cells.forEach({  self.tableView.register(UINib.init(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)})
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }

    func configureVc() {
        let configurator = GitProfilesConfiguratorImpl()
        configurator.configure(vc: self)
    }
    
    static func xibInstance() -> GitProfilesController {
        let vc = GitProfilesController.init(nibName: "GitProfilesController", bundle: nil)
        let configurator = GitProfilesConfiguratorImpl()
        configurator.configure(vc: vc)
        return vc
    }
    
    //this is banner for error.
    
    func showSuccesOrError(bannerType:BannerType , title: String , description: String ) {
        let middleX: CGFloat = 10
        let height = self.navigationController?.navigationBar.frame.height ?? 20
        let width = UIScreen.main.bounds.width - 20
        let errorB = ErrorSuccessBanner.init(frame: CGRect.init(x: middleX, y: height + 70,
                                                                width: width, height: 60) ,
                                             bannerType: bannerType ,
                                             title: title ,
                                             description: description )
        self.view.addSubview(errorB)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            errorB.removeFromSuperview()
            self.reloadData()
        }
        
    }

}
//I dont need section so not override it func.
extension GitProfilesController: UITableViewDelegate {
    
}

extension GitProfilesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitPresenter.numberOfRows(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gitPresenter.getNibName(indexPath: indexPath)) as? GithubProfileCellConfigurable else {return UITableViewCell()}
        gitPresenter.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        gitPresenter.getHeightForRow(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gitPresenter.didSelectRow(at: indexPath)
    }
    
}

extension GitProfilesController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gitPresenter.searchedWithText(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        gitPresenter.searchCanceled()
    }
}
