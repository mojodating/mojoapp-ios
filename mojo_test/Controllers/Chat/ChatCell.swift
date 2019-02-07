//
//  chatCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

protocol ChatCellDelegate {
    func didTapCell(conversation : Conversation)
}

class ChatCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: ChatCellDelegate?
    
    var chats = [Conversation]()
    
    fileprivate func fetchChatListsFromServer() {
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
//
                    let conversation = Conversation(conv: conv)
                    if (conversation.accepted) {
                        
                        self.chats.append(conversation)
                    }
                        
                    self.collectionView.reloadData()
                    })
                    self.titleLabel.text = "Chats(\(self.chats.count))"
                }
            }
        }
    }


    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chats()"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()

    let cellId = "cellId"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        setupLayout()
        
        fetchChatListsFromServer()

    }

    fileprivate func setupLayout() {
        addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))

        addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return CGSize(width: frame.width, height: 86)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let conversation = self.chats[indexPath.row]
        delegate?.didTapCell(conversation: conversation)
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
                self.chatProfileImage.loadImageUsingCacheWithUrlString(urlString: senderImageUrl)
            }
            
                fetchLastMessageFromConversation()
            
        }
    }
    
    var lastMessageDate = Date()
    
    var messageLog = [Message]()
    fileprivate func fetchLastMessageFromConversation() {
        guard let conversationId = conversation?.id else { return }
        Firestore.firestore().collection("conversations").document(conversationId).collection("messages")
        .getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
        //                        print("\(document.documentID) => \(document.data())")
                    let msg = document.data()
                    let message = Message(msg: msg)
                    self.messageLog.append(message)
//                    self.messageLog.sort(by: { (message1, message2) -> Bool in
//                        return message1.date > message2.date
//                    })
                    let mostRecentMessage = self.messageLog.last
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm tt"
                    let dateString = dateFormatter.string(from: (mostRecentMessage?.date)!)
                    self.timeLabel.text = dateString
                    self.contentLabel.text = mostRecentMessage?.text
//                    self.conversation?.mostRecentMessageDate = (mostRecentMessage?.date)!
                    self.lastMessageDate = (mostRecentMessage?.date)!
                }
            }
        }
    }
        
        let chatProfileImage: UIImageView = {
            let image = UIImageView(image: #imageLiteral(resourceName: "jaime"))
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 28
            image.clipsToBounds = true
            return image
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "Jaime Lannister"
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            return label
        }()
        
        let contentLabel: UILabel = {
            let label = UILabel()
            label.text = "Jared's been back from that island for a whole day and he didn't get any toilet…"
            label.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.numberOfLines = 0
            return label
        }()
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = "Yesterday"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .lightGray
            return label
        }()
        
        let arrowImage: UIImageView = {
            let image = UIImageView(image: #imageLiteral(resourceName: "rightArrow"))
            image.clipsToBounds = true
            image.contentMode = .scaleAspectFill
            return image
        }()


        
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
            
            addSubview(timeLabel)
            timeLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 32))
            
            addSubview(arrowImage)
            arrowImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16))
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
