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
        Firestore.firestore().collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            guard let dictionaries = data["conversations"] as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                //                    print("key\(key), Value\(value)")
                
                guard let conv = value as? [String: Any] else {return}
                
                let conversation = Conversation(conv: conv)
                
                if (conversation.accepted) {
                    self.chats.append(conversation)
                }
                
                self.collectionView.reloadData()
            })
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chats(2)"
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
    var conversation : Conversation? {
        didSet {
            
            guard let sendUID = conversation?.sender else { return }
            
            Firestore.firestore().collection("users").document(sendUID).getDocument { (snapshot, err) in
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
            label.textColor = .darkGray
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
