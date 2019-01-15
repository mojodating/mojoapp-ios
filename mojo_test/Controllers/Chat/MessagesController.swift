//
//  MessagesController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/16/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // setup chat request horizontal collectionView
    
    let chatRequestCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .yellow
        return cv
    }()
    
    let chatRequestCellId = "chatRequestCellId"
    
    let cellId = "cellId"
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUserFromFirestore()
        
        observeMessages()
        
        setupChatRequestCollectionViewLayout()
    }
    
    fileprivate func setupChatRequestCollectionViewLayout() {
        view.addSubview(chatRequestCollectionView)
        chatRequestCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: 200))
        chatRequestCollectionView.delegate = self
        chatRequestCollectionView.dataSource = self
        
        chatRequestCollectionView.register(ChatRequestCell.self, forCellWithReuseIdentifier: chatRequestCellId)
    }
    
    
    
    func observeMessages() {
        
        //load message row here
        
    }
    
    fileprivate func fetchUserFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
        
        snapshot?.documents.forEach({ (documentSnapshot) in
            
            let userDictionary = documentSnapshot.data()
            let user = User(dictionary: userDictionary)
            self.users.append(user)
            
            self.tableView.reloadData()

        })
    }
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.text = "Placeholder text content"
        
        if let imageUrl1 = user.imageUrl1 {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl1)
    
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let controller = FriendChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        self.hidesBottomBarWhenPushed = true
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    // Chat request
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = chatRequestCollectionView.dequeueReusableCell(withReuseIdentifier: "chatRequestCellId", for: indexPath) as! ChatRequestCell
        
        cell.backgroundColor = .blue
        
        return cell
    }
}
