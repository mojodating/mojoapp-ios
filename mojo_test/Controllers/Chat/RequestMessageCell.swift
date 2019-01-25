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
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
        addSubview(bubbleView)
        bubbleView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 250, height: self.frame.height))
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        
        addSubview(chatLogLabel)
        chatLogLabel.anchor(top: self.topAnchor, leading: bubbleView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 250, height: self.frame.height))
        
        addSubview(drinkImageView)
        drinkImageView.anchor(top: bubbleView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 48, bottom: 0, right: 0), size: .init(width: 72, height: 72))
        
        addSubview(actionButton)
        actionButton.anchor(top: nil, leading: drinkImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        actionButton.centerYAnchor.constraint(equalTo: drinkImageView.centerYAnchor).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: drinkImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 48, bottom: 0, right: 48))
        
        
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
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
    
    let drinkImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "drink"))
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reject chat request", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Reply to accept. Reject to turn down the gift and chat request. Request will expire in 48 hrs. "
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
