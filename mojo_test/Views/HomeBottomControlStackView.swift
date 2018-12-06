//
//  HomeBottomControlStackView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/1/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class HomeBottomControlStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let ratingButton = createButton(image:#imageLiteral(resourceName: "rating-1"))
    let profileThumbnail = createButton(image: #imageLiteral(resourceName: "thumbnail-1"))
    let chatButton = createButton(image: #imageLiteral(resourceName: "chatbutton-1"))
    let refreshButton = createButton(image: #imageLiteral(resourceName: "review-1"))
    
    override init (frame: CGRect) {
        super.init(frame:frame)
        axis = .vertical
        distribution = .equalSpacing
        alignment = .bottom
        heightAnchor.constraint(equalToConstant:
            403).isActive = true

        
        [ratingButton, profileThumbnail, chatButton, refreshButton].forEach{(button) in
            self.addArrangedSubview(button)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 0, bottom: 16, right: 8)
        
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
