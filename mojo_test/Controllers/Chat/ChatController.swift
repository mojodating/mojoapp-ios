//
//  ChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatController: BaseListController, UICollectionViewDelegateFlowLayout, ChatRequestCellDelegate {
    
    let chatRequestCellId = "chatRequestCellId"
    let chatCellId = "chatCellId"
    let emptyLabel = UILabel(text: "Start your first chat", font: .systemFont(ofSize: 14))

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
//        fetchChatListsFromServer()
        setupNavBar()
        setupLayout()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(handleRefreshPage), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chats.removeAll()
        fetchChatListsFromServer()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.view.backgroundColor = .white
//        navigationController?.navigationBar.clipsToBounds = true
//        navigationController?.navigationBar.isTranslucent = false

    }
    
    @objc func handleRefreshPage(refreshControl: UIRefreshControl) {        
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.setupViewControllers()
        refreshControl.endRefreshing()
    }

    
    fileprivate func setupLayout() {
        
        collectionView.register(ChatRequestCell.self, forCellWithReuseIdentifier: chatRequestCellId)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: chatCellId)
        
        view.addSubview(emptyLabel)
        emptyLabel.fillSuperview()
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .lightGray
        emptyLabel.isHidden = true
    }

    var chats = [Conversation]()
    
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
                        self.chats = self.chats.sorted(by: { (conv1, conv2) -> Bool in
                            conv1.lastUpdated > conv2.lastUpdated
                        })
                        self.collectionView.reloadData()
                        
                    })
                    if (self.chats.count == 0) {
                        self.emptyLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return chats.count
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatCell
            cell.conversation = chats[indexPath.item]
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatRequestCellId, for: indexPath) as! ChatRequestCell
        
        cell.delegate = self

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: 80)
        }
        return CGSize(width: view.frame.width, height: 190)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let conversation = self.chats[indexPath.row]
        let chatLogController = PrivateChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.conversation = conversation
        navigationController?.pushViewController(chatLogController, animated: true)
        }
    
    func didTapCell(conversation: Conversation) {
        let chatLogController = PrivateChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.conversation = conversation
        navigationController?.pushViewController(chatLogController, animated: true)

    }
    
}



