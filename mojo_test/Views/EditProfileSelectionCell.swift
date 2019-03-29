//
//  EditProfileSelectionCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/3/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class EditProfileSelectionCell: UITableViewCell {
    
    let button = UIButton(title: "Choose...   ", cornerRadius: 0, font: .systemFont(ofSize: 18, weight: .regular))

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(button)
        button.fillSuperview(padding: .init(top: 4, left: 24, bottom: 4, right: 0))
        
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.frame.width - 24).isActive = true
        button.contentHorizontalAlignment = .left
        
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.9319355397, green: 0.9319355397, blue: 0.9319355397, alpha: 1)
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
