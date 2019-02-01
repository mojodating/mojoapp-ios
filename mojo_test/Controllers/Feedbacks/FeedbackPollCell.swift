//
//  FeedbackPollCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/29/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class FeedbackPollCell: UICollectionViewCell {
    
    var user: User?
    var message: Message?
    var conversation : Conversation? {
        didSet {
            
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            var chatProfileUID: String?
            
            if currentUser == conversation?.sender {
                chatProfileUID = conversation?.receiver
            } else {
                chatProfileUID = conversation?.sender
            }
            
            
            Firestore.firestore().collection("users").document(chatProfileUID!).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                //          fetch our user here
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                self.titleLabel.text = "How‘s your conversation with " + (self.user?.name)!
                
                guard let senderImageUrl = self.user?.imageUrl1 else {return}
                self.profileImageView.loadImageUsingCacheWithUrlString(urlString: senderImageUrl)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 48, height: 48))
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: profileImageView.leadingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
//        addSubview(dateLabel)
//        dateLabel.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 0))
        
        addSubview(lineView)
        lineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 8), size: .init(width: frame.width, height: 1))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How‘s your conversation with UserName"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Started at 10/30/2018 19:20"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "cersi"))
        iv.layer.cornerRadius = 24
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let lineView: UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.9178571767, green: 0.9178571767, blue: 0.9178571767, alpha: 1)
        return lv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
