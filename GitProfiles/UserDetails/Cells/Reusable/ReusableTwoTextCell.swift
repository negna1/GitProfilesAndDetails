//
//  ReusableTwoTextCell.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit
//I wanted reusable , because not have many stack views :/
class ReusableTwoTextCell: UIView {
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ReusableTwoTextCell", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configure(key: String , value: String) {
        self.key.text = key
        self.value.text = value
    }
}
