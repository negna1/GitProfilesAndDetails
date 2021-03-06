//
//  ProfileCell.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

class ProfileCell: UITableViewCell , GithubProfileCellConfigurable {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet var animators: [AnimatorView]!
    @IBOutlet weak var noteIcon: UIImageView!
    
    override func awakeFromNib() {
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        img.layer.cornerRadius = 20
        noteIcon.isHidden = true
    }
    
    //There are two options , animate or not.
    
    func animate(){
        animators.forEach { (v) in
            v.animateOpacity(
                beginTime: CACurrentMediaTime() + 0.5,
                toValue: 0.2,
                reversed: true)
        }
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //also This cell can be 3 type. has note , has inverted and be normal :) 
    func loadModel(with model: GithubProfileCellModel) {
        view.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        animators.forEach { (v) in
            v.isHidden = true
        }
        self.img.image = model.image
        self.username.text = model.username
        self.detail.text = "details"
        noteIcon.isHidden = !model.needNote
        makeColorInvertIfNeeded(needColorInvert: model.colorInverted)
    }
    
    func makeColorInvertIfNeeded(needColorInvert: Bool) {
        if needColorInvert {
            let beginImage = CIImage(image: img.image!)
            if let filter = CIFilter(name: "CIColorInvert") {
                filter.setValue(beginImage, forKey: kCIInputImageKey)
                let newImage = UIImage(ciImage: filter.outputImage!)
                img.image = newImage
            }
        }
    }
    
    func configure(with model: CellProtocol) {
        if let model = model as? GithubProfileCellModel {
            model.animate ? animate() : loadModel(with: model)
        }
    }
    
}
