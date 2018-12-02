//
//  HomeBottomControlStackView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/1/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
let ratingButton = UIButton(type: .system)
let profileThumbnail = UIButton(type: .system)
let chatButton = UIButton(type: .system)
let reviewButton = UIButton(type: .system)

class HomeBottomControlStackView: UIStackView {
    
    override init (frame: CGRect) {
        super.init(frame:frame)
        axis = .vertical
        distribution = .equalSpacing
        alignment = .bottom
        heightAnchor.constraint(equalToConstant:
            376).isActive = true
        
        ratingButton.setImage(#imageLiteral(resourceName: "rating-1").withRenderingMode(.alwaysOriginal), for: .normal)
        profileThumbnail.setImage(#imageLiteral(resourceName: "thumbnail-1").withRenderingMode(.alwaysOriginal), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "chatbutton-1").withRenderingMode(.alwaysOriginal), for: .normal)
        reviewButton.setImage(#imageLiteral(resourceName: "review-1").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [ratingButton, profileThumbnail, chatButton, reviewButton].forEach{(v) in
            addArrangedSubview(v)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 8, left: 8, bottom: 16, right: 8)
        
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
