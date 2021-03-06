//
//  UserDetailsController.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit


class UserDetailsController: UIViewController , UserDetailsView{
    var userPresenter: UserDetailsPresenter!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        userPresenter.viewDidLoad()
    }
    
    func registerNibs(cells: [String]) {
        cells.forEach({  self.tableView.register(UINib.init(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)})
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    static func xibInstance(userUrl: WholeProfileModel , store: GitProfileStore) -> UserDetailsController {
        let vc = UserDetailsController.init()
        let configurator = UserDetailsConfiguratorImpl()
        configurator.configure(vc: vc, userInfo: userUrl , store: store)
        return vc
    }

    func titleNameToNavigation(title: String) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.topItem?.title = title
        }
    }
    
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
        }
    }
    // if happend deinit it means retain cycle is not here 
    deinit {
        print("deinit")
    }
}

extension UserDetailsController: UITableViewDelegate {
    
}

extension UserDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.numberOfRows(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: userPresenter.getNibName(indexPath: indexPath)) as? GithubProfileCellConfigurable else {return UITableViewCell()}
        userPresenter.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        userPresenter.getHeightForRow(indexPath: indexPath)
    }
    
}
