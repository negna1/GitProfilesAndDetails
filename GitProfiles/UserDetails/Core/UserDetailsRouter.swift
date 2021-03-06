//
//  UserDetailsRouter.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import Foundation

protocol UserDetailsRouter: AnyObject {
    
}

class UserDetailsRouterImpl: UserDetailsRouter {
    private weak var controller: UserDetailsController?
    
    init(controller: UserDetailsController) {
        self.controller = controller
    }
}
