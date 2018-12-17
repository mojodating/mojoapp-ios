//
//  FriendChatLogController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/15/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class FriendChatLogController: UICollectionViewController {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter messages..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        setupInputComponents()
        
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.03)
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 18
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8), size: .init(width: 80, height: 34))
        
        containerView.addSubview(inputTextField)
        inputTextField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 8))
        
    }
    
    @objc fileprivate func handleSend() {
        
        // save text to firestore
//        let ref = Storage.storage().reference(withPath: "/messages")
//        let toId = user!.uid!
//        let timestamp = NSDate().timeIntervalSince1970
//        let fromId = Auth.auth().currentUser?.uid ?? ""
//        let value = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
//        }
        
        
        print(inputTextField.text)
    }
}
