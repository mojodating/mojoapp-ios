//
//  MessageCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .blue
        
        addSubview(bubbleView)
        bubbleView.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 4), size: .init(width: 250, height: self.frame.height))
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        
        addSubview(chatLogLabel)
        chatLogLabel.anchor(top: self.topAnchor, leading: bubbleView.leadingAnchor, bottom: nil, trailing: bubbleView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 250, height: self.frame.height))
        
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
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
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
