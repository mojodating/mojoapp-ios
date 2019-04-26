//
//  ChatCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/24/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatCell:UICollectionViewCell {
    
    let currentUser = Auth.auth().currentUser?.uid
    var user: User?
    var message: Message?
    var conversation : Conversation? {
        didSet {
            
            var chatProfileUID: String?
            
            if currentUser == conversation?.sender {
                chatProfileUID = conversation?.receiver
            } else {
                chatProfileUID = conversation?.sender
            }
            
            fetchLastMessageFromConversation()
            Firestore.firestore().collection("users").document(chatProfileUID!).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                //          fetch our user here
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                self.nameLabel.text = self.user?.name
                
                guard let senderImageUrl = self.user?.imageUrl1 else {return}
                if let senderImageUrl = URL(string: senderImageUrl) {
                    self.chatProfileImage.sd_setImage(with: senderImageUrl)
                }
            }
            
            if conversation?.seen == false {
                self.unreadImage.isHidden = false
                self.contentLabel.textColor = .black
            } else {
                self.unreadImage.isHidden = true
                self.contentLabel.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
            }
        }
    }
    
    var messageLog = [Message]()
    
    func fetchLastMessageFromConversation() {
        guard let conversationId = conversation?.id else { return }
        Firestore.firestore().collection("conversations").document(conversationId).collection("messages").order(by: "date", descending: false)
            .addSnapshotListener { querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        
                        let msg = diff.document.data()
                        let message = Message(msg: msg)
                        
                        self.messageLog.append(message)
                        let mostRecentMessage = self.messageLog.last
                        let dateString = Date.StringFromCustomDate(costumDate: (mostRecentMessage?.date)!)
                        self.timeLabel.text = dateString
                        self.contentLabel.text = mostRecentMessage?.text
                    }
                }
        }
    }
    
    let chatProfileImage = UIImageView(cornerRadius: 28)
    let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 18, weight: .semibold))
    let contentLabel = UILabel(text: "", font: .systemFont(ofSize: 14))
    let timeLabel = UILabel(text: "", font: .systemFont(ofSize: 14))
    let arrowImage = UIImageView(image: #imageLiteral(resourceName: "rightArrow"))
    let unreadImage = UIImageView(image: #imageLiteral(resourceName: "notification-dot"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupCell()
    }
    
    fileprivate func setupCell() {
        
        addSubview(chatProfileImage)
        chatProfileImage.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0), size: .init(width: 56, height: 56))
        chatProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, leading: chatProfileImage.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 8, bottom: 0, right: 0))
        
        addSubview(contentLabel)
        contentLabel.anchor(top: nameLabel.bottomAnchor, leading: chatProfileImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 8, bottom: 0, right: 32))
        contentLabel.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 32))
        timeLabel.textColor = .lightGray
        
        addSubview(arrowImage)
        arrowImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        
        addSubview(unreadImage)
        unreadImage.anchor(top: nil, leading: nil, bottom: nil, trailing: chatProfileImage.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4))
        unreadImage.centerYAnchor.constraint(equalToSystemSpacingBelow: chatProfileImage.centerYAnchor, multiplier: 1).isActive = true
//        unreadImage.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

