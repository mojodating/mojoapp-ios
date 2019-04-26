//
//  RequestMessageCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/25/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class RequestMessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 0))
        descriptionLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center
        
        addSubview(bubbleView)
        
        addSubview(spaceView)
        spaceView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 8, height: 8))
        
        addSubview(profileImageView)
        profileImageView.anchor(top: descriptionLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 36, left: 8, bottom: 0, right: 0), size: .init(width: 48, height: 48))
        profileImageView.backgroundColor = .white
        

        bubbleView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 36).isActive = true

        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: self.frame.height)
        bubbleHeightAnchor?.isActive = true

        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        
        addSubview(chatLogLabel)
        chatLogLabel.anchor(top: bubbleView.topAnchor, leading: bubbleView.leadingAnchor, bottom: bubbleView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0), size: .init(width: 250, height: self.frame.height))
        chatLogLabel.numberOfLines = 0
        chatLogLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(giftImageView)
        giftImageView.anchor(top: bubbleView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 48, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        addSubview(giftInfoLabel)
        giftInfoLabel.anchor(top: nil, leading: giftImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        giftInfoLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: giftImageView.centerYAnchor, multiplier: 1).isActive = true
        giftInfoLabel.numberOfLines = 0
        
        addSubview(rejectButton)
        rejectButton.anchor(top: giftImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 48, bottom: 0, right: 0))
        rejectButton.isHidden = true
        
        
        
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let spaceView = UIView()
    let chatLogLabel = UILabel(text: "", font: .systemFont(ofSize: 16))
    let profileImageView = UIImageView(cornerRadius: 24)
    let giftImageView = UIImageView(cornerRadius: 16)
    let descriptionLabel = UILabel(text: "", font: .systemFont(ofSize: 13))
    let giftInfoLabel = UILabel()
    let chatRequestLabel = UILabel(text: "CHAT REQUEST", font: .systemFont(ofSize: 13, weight: .bold))
    let rejectButton = UIButton(title: "Reject Request", cornerRadius: 0, font: .systemFont(ofSize: 14))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
