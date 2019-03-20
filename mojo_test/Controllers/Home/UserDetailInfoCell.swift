//
//  UserDetailInfoCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/11/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class UserDetailInfoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(userInfoLabel)
        userInfoLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        userInfoLabel.numberOfLines = 0
    }
    
    let userInfoLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
