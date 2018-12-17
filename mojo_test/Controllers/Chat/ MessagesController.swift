//
//  MessagesController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/16/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUserFromFirestore()
        
        observeMessages()
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
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y, width: textLabel!.frame.width
            , height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 4, width: detailTextLabel!.frame.width
            , height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "thumbnail-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 8), size: .init(width: 48, height: 48))
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
