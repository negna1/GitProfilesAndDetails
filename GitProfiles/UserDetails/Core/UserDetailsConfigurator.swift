//
//  UserDetailsConfigurator.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import Foundation

protocol UserDetailsConfigurator {
    func configure(vc: UserDetailsController , userInfo: WholeProfileModel , store: GitProfileStore)
}

class UserDetailsConfiguratorImpl: UserDetailsConfigurator {
    func configure(vc: UserDetailsController , userInfo: WholeProfileModel , store: GitProfileStore) {
        let router = UserDetailsRouterImpl(controller: vc)
        let presenter = UserDetailsPresenterImpl(view: vc, router: router, userInfo: userInfo , store: store)
        vc.userPresenter = presenter
    }
}
