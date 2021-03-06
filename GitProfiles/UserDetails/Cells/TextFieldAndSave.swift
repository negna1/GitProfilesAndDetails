//
//  TextFieldAndSave.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/5/21.
//

import UIKit
protocol TextFieldAndSaveDelegate {
    func didTapSave(note: String)
}

class TextFieldAndSave: UITableViewCell , GithubProfileCellConfigurable{
    @IBOutlet weak var textF: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    var delegate: TextFieldAndSaveDelegate?
    
    func setUpTextField() {
        textF.layer.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        textF.layer.borderWidth = 1
    }
    
    func setUpButton() {
        saveBtn.backgroundColor = UIColor(red: 171/255, green: 178/255, blue: 186/255, alpha: 1.0)
        // Shadow Color and Radius
        saveBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        saveBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        saveBtn.layer.shadowOpacity = 1.0
        saveBtn.layer.shadowRadius = 0.0
        saveBtn.layer.masksToBounds = false
        saveBtn.layer.cornerRadius = 4.0
    }
    
    func configure(with model: CellProtocol) {
        setUpTextField()
        setUpButton()
        if let model = model as? TextFieldAndButtonCellModel {
            textF.text = model.note
            self.delegate = model.delegate
        }
    }
    
    @IBAction func didTapSave() {
        delegate?.didTapSave(note: textF.text)
    }
}
