//
//  BioTableCell.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

class BioTableCell: UITableViewCell , GithubProfileCellConfigurable  {
    @IBOutlet  var keyValueDict: [ReusableTwoTextCell]!
    @IBOutlet weak var view: UIView!
    func configure(with model: CellProtocol) {
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if let model = model as? BioCellModel {
            keyValueDict.enumerated().forEach({$0.element.configure(key: model.bios[$0.offset].key,
                                                                    value:  model.bios[$0.offset].value)})
        }
    }
}
