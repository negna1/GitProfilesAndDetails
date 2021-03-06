//
//  GitProfilesConfigurator.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import Foundation

//I prefer to use CONTROLLER > Presenter > Configurator > Router . because it is very easy to find something. Also controller must not have its model its only job is to update view. Presenter has every work , like servers and tell core data to save. router is for navigation

protocol GitProfilesConfigurator {
    func configure(vc: GitProfilesController)
}

class GitProfilesConfiguratorImpl: GitProfilesConfigurator {
    func configure(vc: GitProfilesController) {
        let router = GitProfilesRouterImpl(controller: vc)
        let presenter = GitProfilesPresenterImpl(view: vc, router: router)
        vc.gitPresenter = presenter
    }
}
