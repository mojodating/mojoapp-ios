//
//  ChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RequestsFeedCellDelegate {
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let chatRequestCellId = "chatRequestCellId"

    let chatCellId = "chatCellId"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Chat"
        
        setupLayout()
        
    }

    
    fileprivate func setupLayout() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(ChatRequestCell.self, forCellWithReuseIdentifier: chatRequestCellId)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: chatCellId)

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatRequestCellId, for: indexPath) as! ChatRequestCell
        
        cell.delegate = self

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: view.frame.height - 224)
        }
        return CGSize(width: view.frame.width, height: 224)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        }
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        }
    
    func didTapCell(conversation: Conversation) {
        print("show message chat")
        let chatLogController = PrivateChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.conversation = conversation
        navigationController?.pushViewController(chatLogController, animated: true)
    }


    
    }



