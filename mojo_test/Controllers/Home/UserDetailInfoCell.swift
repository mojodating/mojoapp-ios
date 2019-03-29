//
//  UserDetailInfoCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/11/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class UserDetailInfoCell: UICollectionViewCell {
    
    var user: User?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(userInfoLabel)
        userInfoLabel.numberOfLines = 0
        addSubview(header)
        addSubview(userAboutLabel)
        userAboutLabel.numberOfLines = 0
        
        let stackView = VerticalStackView(arrangedSubviews: [
            userInfoLabel,
            header,
            userAboutLabel,
            ], spacing: 16)
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    
    let userInfoLabel = UILabel()
    let header = UILabel(text: "About", font: .systemFont(ofSize: 16, weight: .semibold))
    let userAboutLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .regular))
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
