//
//  ImageAndFollowersCell.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

class ImageAndFollowersCell: UITableViewCell , GithubProfileCellConfigurable {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!
    
    func configure(with model: CellProtocol) {
        if let model = model as? UserDetailsCellModel {
            profile.image = model.image
            follower.text = "follower: " + model.follower
            following.text = "following: " + model.following
        }
    }
    
}
