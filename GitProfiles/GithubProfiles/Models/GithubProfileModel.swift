//
//  GithubProfileModel.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

protocol CellProtocol {
    var nibIdentifier: String {get}
    var height: CGFloat {get}
}

struct GithubProfileCellModel: CellProtocol {
    var nibIdentifier: String {return "ProfileCell"}
    var height: CGFloat {return 100}
    let image: UIImage?
    let username: String
    let needNote: Bool
    let animate: Bool
    let colorInverted: Bool
}

struct ErrorForNotHaveDataCellModel: CellProtocol {
    var nibIdentifier: String {return "ErrorNotHaveData"}
    var height: CGFloat {return 300}
    var title: String {return "Not Have Data"}
}

protocol GithubProfileCellConfigurable: UITableViewCell {
    func configure(with model: CellProtocol)
}

struct WholeProfileModel {
    let id: Int
    let username: String
    let image: UIImage?
    let note: String?
    let follwer: String
    let following: String
    let name: String
    let company: String
    let blog: String
}

extension WholeProfileModel{
    func makeModel(colorInverted: Bool) -> GithubProfileCellModel{
        
        GithubProfileCellModel(image: self.image,
                               username: self.username,
                               needNote: self.note != "" ,
                               animate: false,
                               colorInverted: colorInverted)
    }
    
    func makeFollowerFollowingModel(img: UIImage? ) -> UserDetailsCellModel{
        UserDetailsCellModel(image: img, follower: self.follwer , following: self.following)
    }
    
    func makeBio() -> BioCellModel{
        BioCellModel(bios: [BioKeyValue.init(key: "name", value: self.name) ,
                            BioKeyValue.init(key: "compay", value: self.company) ,
                            BioKeyValue.init(key: "blog", value: self.blog) ])
    }
}
