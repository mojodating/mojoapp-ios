//
//  chatRequestCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

protocol ChatRequestCellDelegate {
    func didTapCell()
}

class ChatRequestCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var chatRequests = [Conversation]()
    
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
                    
                    guard let conv = value as? [String: Any] else {return}
                    
                    let conversation = Conversation(conv: conv)

               if (conversation.accepted == false && conversation.sender != uid) {
                    self.chatRequests.append(conversation)
               }

            self.collectionView.reloadData()
        })
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RequestCell
        
        cell.conversation = chatRequests[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: frame.height - 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(123)
        
        
        
        delegate?.didTapCell()
        
        
    }
    
    var delegate: ChatRequestCellDelegate?
    
    let showRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chat Request(15)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.3322708161, blue: 0.6531050149, alpha: 1)
        button.layer.cornerRadius = 16
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
 
    let showSentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chat Sent(10)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 16
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
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
    
    
    func setupLayout() {
        
        addSubview(showRequestButton)
        showRequestButton.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 138, height: 32))
        
        addSubview(showSentButton)
        showSentButton.anchor(top: self.topAnchor, leading: showRequestButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 8, bottom: 0, right: 0), size: .init(width: 138, height: 32))
        
        addSubview(collectionView)
        collectionView.anchor(top: showRequestButton.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(RequestCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // setup each individual cell in chat request
    
    
    private class RequestCell:UICollectionViewCell {
        
        var user: User?
        var conversation : Conversation? {
            didSet {
                
                guard let goodImageUrl = conversation?.drinkImage else { return }
                goodsImage.loadImageUsingCacheWithUrlString(urlString: goodImageUrl)
                
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
                    self.userProfileImage.loadImageUsingCacheWithUrlString(urlString: senderImageUrl)
 
                }
            }
        }
        
        let userProfileImage: UIImageView = {
            let image = UIImageView(image: #imageLiteral(resourceName: "cersi"))
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 35
            image.clipsToBounds = true
            return image
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "Cersi Lannister"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            return label
        }()
        
        let goodsImage: UIImageView = {
            let image = UIImageView(image: #imageLiteral(resourceName: "Like"))
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            return image
        }()
        
        override init(frame: CGRect) {
            super.init(frame:frame)
            
            backgroundColor = .white
            
            setupCell()
        }
        
        fileprivate func setupCell() {
            addSubview(userProfileImage)
            userProfileImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: frame.width, height: frame.width))
            
            addSubview(nameLabel)
            nameLabel.anchor(top: userProfileImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 4, bottom: 0, right: 4))
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            addSubview(goodsImage)
            goodsImage.anchor(top: nameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 35, height: 35))
            goodsImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
