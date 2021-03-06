//
//  ErrorSuccessBanner.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/5/21.
//

import UIKit

class ErrorSuccessBanner: UIView {
    
    private var titleLbl: UILabel = {
        let lbl = UILabel.init()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var descrLbl: UILabel = {
        let lbl = UILabel.init()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    func styleUI() {
        self.layer.cornerRadius = 20
        self.addSubview(titleLbl)
        self.addSubview(descrLbl)
        titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        descrLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        descrLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        descrLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
    }
    
    public init(frame: CGRect , bannerType:BannerType , title: String , description: String ) {
        super.init(frame: frame)
        styleUI()
        self.backgroundColor = bannerType.getColor()
        descrLbl.text = description
        titleLbl.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum BannerType {
    case success
    case error
}

extension BannerType {
    func getColor() -> UIColor {
        switch self {
        case .success:
            return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        default:
            return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
}
