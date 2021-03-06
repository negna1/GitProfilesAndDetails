//
//  UserDetailsModel.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit


struct UserDetailsCellModel: CellProtocol {
    var nibIdentifier: String {return "ImageAndFollowersCell"}
    var height: CGFloat {return 150}
    let image: UIImage?
    let follower: String
    let following: String
}


struct BioCellModel: CellProtocol {
    var nibIdentifier: String {return "BioTableCell"}
    var height: CGFloat {return 100}
    let bios: [BioKeyValue]
}

struct TextFieldAndButtonCellModel: CellProtocol {
    var nibIdentifier: String {return "TextFieldAndSave"}
    var height: CGFloat {return 200}
    let note: String
    var delegate: TextFieldAndSaveDelegate?
}

struct BioKeyValue {
    let key: String
    let value: String
}

struct UserImgAndUrl {
    let image: UIImage?
    let userUrl: String
}
