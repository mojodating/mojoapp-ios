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
        
        addSubview(buttonStackView)
        buttonStackView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 36, left: 8, bottom: 0, right: 8))
        
        addSubview(LineView)
        LineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 16, right: 2), size: .init(width: frame.width, height: 1))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your review"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    static func createButton(image: UIImage, text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal),  for:.normal)
        button.setTitle(text, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        button.imageView?.width(32)
        button.imageView?.height(32)
        return button
    }
    
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        
        let likeButton = createButton(image: #imageLiteral(resourceName: "image 3"), text: " 10")
        let loveButton = createButton(image: #imageLiteral(resourceName: "image2"), text: " 10")
        let dopeButton = createButton(image: #imageLiteral(resourceName: "image 5"), text: " 10")
        let mehButton = createButton(image: #imageLiteral(resourceName: "image 4"), text: " 10")
        let fakeIdButton = createButton(image: #imageLiteral(resourceName: "image 6"), text: " 10")
        let madButton = createButton(image: #imageLiteral(resourceName: "image"), text: " 10")
        
        [likeButton,loveButton, dopeButton, mehButton, fakeIdButton, madButton].forEach{(button) in
            sv.addArrangedSubview(button)
        }
        
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let LineView : UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.9365159648, green: 0.9365159648, blue: 0.9365159648, alpha: 1)
        return lv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
