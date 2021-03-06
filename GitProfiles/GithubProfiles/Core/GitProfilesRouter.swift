//
//  GitProfilesRouter.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import Foundation

protocol GitProfilesRouter: AnyObject {
    func didTapUser(userUrl: WholeProfileModel , store: GitProfileStore)
}

class GitProfilesRouterImpl: GitProfilesRouter {
    private weak var controller: GitProfilesController?
    
    init(controller: GitProfilesController) {
        self.controller = controller
    }
    
    func didTapUser(userUrl: WholeProfileModel , store: GitProfileStore) {
        let vc = UserDetailsController.init(nibName: "UserDetailsController", bundle: nil)
        let configurator = UserDetailsConfiguratorImpl()
        configurator.configure(vc: vc, userInfo: userUrl, store: store)
        self.controller?.navigationItem.backButtonTitle = ""
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
