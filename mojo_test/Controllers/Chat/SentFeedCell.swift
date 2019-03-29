//
//  SentFeedCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/17/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SentFeedCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    var chatSent = [Conversation]()
        
    fileprivate func fetchChatListsFromServer() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid).addSnapshotListener { querySnapshot, error in
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
                            if (conversation.accepted == false && conversation.sender == uid) {
                                self.chatSent.append(conversation)
                            }
                        self.collectionView.reloadData()
                        })
                    }
                }
            if self.chatSent.count == 0 {
                self.emptyLabel.isHidden = false
            }
        }
    }
        
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
    return cv
    }()
    let emptyLabel = UILabel(text: "Send your first chat request!", font: .systemFont(ofSize: 14))
        
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        fetchChatListsFromServer()
            
        backgroundColor = .brown
            
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(SentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: "emptyCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(emptyLabel)
        emptyLabel.fillSuperview(padding: .init(top: 0, left: 36, bottom: 0, right: 36))
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.textColor = .lightGray
        emptyLabel.isHidden = true
    }
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatSent.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SentCell
                
        cell.conversation = chatSent[indexPath.item]
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: frame.height - 48)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
//            let conversation = self.chatSent[indexPath.row]            
//            delegate?.didTapCell(conversation: conversation)
            
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class SentCell:UICollectionViewCell {
    var user: User?
    var conversation : Conversation? {
        didSet {
            guard let sendUID = conversation?.receiver else { return }
            Firestore.firestore().collection("users").document(sendUID).getDocument { (snapshot, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                    
                self.nameLabel.text = self.user?.name
                    
                guard let senderImageUrl = self.user?.imageUrl1 else {return}
                if let senderImageUrl = URL(string: senderImageUrl) {
                    self.profileImageView.sd_setImage(with: senderImageUrl)
                }
            }
        }
    }
        
    let profileImageView = UIImageView(cornerRadius: 35)
    let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 13))
        
    override init(frame: CGRect) {
        super.init(frame:frame)
            
        backgroundColor = .white
            
        setupCell()
    }
        
    fileprivate func setupCell() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: frame.width, height: frame.width))
            
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 4, bottom: 0, right: 4))
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.textAlignment = .center
     
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
