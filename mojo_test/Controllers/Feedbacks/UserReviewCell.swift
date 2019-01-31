//
//  UserReviewCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/29/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class UserReviewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 8, bottom: 0, right: 0))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your review"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.contentMode = .scaleAspectFill
        return label
    }()

    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
