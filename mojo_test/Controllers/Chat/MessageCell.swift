//
//  MessageCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    

    var message: Message? {
        didSet{
            chatLogLabel.text = message?.text
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(spaceView)
        spaceView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 8, height: 8))
        
        addSubview(bubbleView)
//        bubbleView.anchor(top: nil, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 250, height: self.frame.height))
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
//        chatLogLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        
//        let constrains = [chatLogLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16), chatLogLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), chatLogLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16), chatLogLabel.widthAnchor.constraint(equalToConstant: 250) ]
//        NSLayoutConstraint.activate(constrains)
//        chatLogLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0.14).isActive = true
//        chatLogLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: bubbleView.leadingAnchor, multiplier: 0.15).isActive = true
//        chatLogLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
//        chatLogLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        chatLogLabel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        
       
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
        label.textColor = .white
        return label
    }()
    
    let bubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jaime"))
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
