//
//  GiftCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/1/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class UserGiftCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        nameLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        
        addSubview(giftImageView)
        giftImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nameLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        
    }
    
    let giftImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Drink"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
