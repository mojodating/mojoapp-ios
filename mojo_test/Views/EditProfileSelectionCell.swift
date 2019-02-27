//
//  EditProfileSelectionCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/3/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class EditProfileSelectionCell: UITableViewCell {
    
    let selectionLabel : UILabel = {
        let label = UILabel()
        label.text = "Selection item"
        label.textColor = .darkGray
        return label
    }()
    
    let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "select").withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(selectionLabel)
        selectionLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        selectionLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: self.centerYAnchor, multiplier: 1).isActive = true
        
        addSubview(arrowButton)
        arrowButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 24), size: .init(width: 32, height: 32))
        
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
