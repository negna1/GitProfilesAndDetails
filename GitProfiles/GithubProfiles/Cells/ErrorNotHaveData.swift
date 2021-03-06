//
//  ErrorNotHaveData.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/5/21.
//

import UIKit

class ErrorNotHaveData: UITableViewCell , GithubProfileCellConfigurable{
    @IBOutlet weak var label: UILabel!
    
    func configure(with model: CellProtocol) {
        if let model = model as? ErrorForNotHaveDataCellModel {
            label.text = model.title
        }
    }
}
