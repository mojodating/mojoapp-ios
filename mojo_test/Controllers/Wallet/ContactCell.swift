//
//  ContactCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ContactCell: UITableViewCell {
    
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
                
                self.titleLabel.text = self.user?.name ?? ""
                
                guard let senderImageUrl = self.user?.imageUrl1 else {return}
                if let profileUrl = URL(string: senderImageUrl) {
                    self.profileImageView.sd_setImage(with: profileUrl)
                }
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 48, height: 48))
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(lineView)
        lineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 8), size: .init(width: frame.width, height: 1))
        lineView.backgroundColor = #colorLiteral(red: 0.9178571767, green: 0.9178571767, blue: 0.9178571767, alpha: 1)
    }
    
    let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .medium))
    let profileImageView = UIImageView(cornerRadius: 24)
    let lineView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

