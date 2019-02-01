//
//  GiftCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/1/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class GiftCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        
        addSubview(priceLabel)
        priceLabel.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        priceLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        
        addSubview(giftImageView)
        giftImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: priceLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        
    }
    
    let giftImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "drink"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "10 Jo"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
