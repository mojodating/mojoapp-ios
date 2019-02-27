//
//  MessageCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UICollectionViewCell {
    
    var user: User?
    var message: Message? {
        didSet{
            chatLogLabel.text = message?.text
            
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            var chatProfileUID: String?
            
            if currentUser == message?.sender {
                chatProfileUID = message?.receiver
            } else {
                chatProfileUID = message?.sender
            }
            
            Firestore.firestore().collection("users").document(chatProfileUID!).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                //          fetch our user here
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                guard let senderImageUrl = self.user?.imageUrl1 else {return}
                self.profileImageView.loadImageUsingCacheWithUrlString(urlString: senderImageUrl)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(spaceView)
        spaceView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 8, height: 8))
        
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
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        profileImageView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
       
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    
    let bubbleView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()

    
    let profileImageView = UIImageView(cornerRadius: 16)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
