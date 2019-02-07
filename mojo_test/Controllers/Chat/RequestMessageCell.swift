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
        
        addSubview(spaceView)
        spaceView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 8, height: 8))
        
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
        addSubview(bubbleView)
        
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: self.frame.height)
        bubbleHeightAnchor?.isActive = true
        
        bubbleViewRightAnchor = bubbleView.trailingAnchor.constraint(equalTo: spaceView.leadingAnchor)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leadingAnchor.constraint(equalToSystemSpacingAfter: profileImageView.trailingAnchor, multiplier: 1.2)
        
        
        addSubview(chatLogLabel)
        chatLogLabel.anchor(top: bubbleView.topAnchor, leading: bubbleView.leadingAnchor, bottom: bubbleView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0), size: .init(width: 250, height: self.frame.height))
        
        addSubview(chatRequestLabel)
        chatRequestLabel.anchor(top: bubbleView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        chatRequestLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        
        
        addSubview(giftImageView)
        giftImageView.anchor(top: chatRequestLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 48, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        addSubview(giftInfoLabel)
        giftInfoLabel.anchor(top: nil, leading: giftImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        giftInfoLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: giftImageView.centerYAnchor, multiplier: 1).isActive = true
        
//        addSubview(actionButton)
//        actionButton.anchor(top: giftInfoLabel.bottomAnchor, leading: giftImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 16, bottom: 0, right: 0))
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: giftImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 48, bottom: 0, right: 48))
        
        
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    
    let spaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    let chatLogLabel: UILabel = {
        let label = UILabel()
        label.text = "sample text"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jaime"))
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
    let giftImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "drink"))
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
//    let actionButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Reject chat request", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
//        return button
//    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let giftInfoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let chatRequestLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat request"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
