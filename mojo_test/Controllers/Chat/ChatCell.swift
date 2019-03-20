//
//  chatCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

protocol ChatCellDelegate {
    func didTapCell(conversation : Conversation)
}

class ChatCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: ChatCellDelegate?
    
    var chats = [Conversation]()
//    var sortedChats = [Conversation]()
    func fetchChatListsFromServer() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
       let ref = Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid)
        
        ref.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    
                    let dictionaries = diff.document.data() 
                    guard let dictionary = dictionaries["conversations"] as? [String : Any] else { return }
                    
                    dictionary.forEach({ (key, value) in
                
                        guard let conv = value as? [String: Any] else {return}

                    let conversation = Conversation(conv: conv)
                        
                    if (conversation.accepted) {
                        self.chats.append(conversation)
                    }
//                      var ready = self.chats.sorted(by: { (conv1, conv2) -> Bool in
//                            conv1.lastMessageDate > conv2.lastMessageDate
//                        })
//                        print(ready)
                    self.collectionView.reloadData()
                    })
                    self.titleLabel.text = "CHATS(\(self.chats.count))"
                }
            }
        }
    }

    let cellId = "cellId"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        setupLayout()
        
        fetchChatListsFromServer()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
        cell.conversation = chats[indexPath.item]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let conversation = self.chats[indexPath.row]
        
        delegate?.didTapCell(conversation: conversation)
    }
    
    let titleLabel = UILabel(text: "CHATS", font: .boldSystemFont(ofSize: 14))
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    
    fileprivate func setupLayout() {
        addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0))
        
        addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

class ChatCell:UICollectionViewCell {
    
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
                
                self.nameLabel.text = self.user?.name
                
                guard let senderImageUrl = self.user?.imageUrl1 else {return}
                if let senderImageUrl = URL(string: senderImageUrl) {
                    self.chatProfileImage.sd_setImage(with: senderImageUrl)
                }
            }
            
                fetchLastMessageFromConversation()
            
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
//                    if mostRecentMessage?.seen == true {
//                        self.unreadImage.isHidden = true
//                    } else {
//                        self.unreadImage.isHidden = false
//                    }
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
//            contentLabel.numberOfLines = 0
            
            addSubview(timeLabel)
            timeLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 32))
            timeLabel.textColor = .lightGray
            
            addSubview(arrowImage)
            arrowImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16))
            
            addSubview(unreadImage)
            unreadImage.anchor(top: nil, leading: nil, bottom: nil, trailing: chatProfileImage.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4))
            unreadImage.centerYAnchor.constraint(equalToSystemSpacingBelow: chatProfileImage.centerYAnchor, multiplier: 1).isActive = true
            unreadImage.isHidden = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
