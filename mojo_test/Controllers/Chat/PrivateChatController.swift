//
//  PrivateChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class PrivateChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var user: User?
    var conversation : Conversation? {
        didSet {
            
            guard let receiverID = conversation?.sender else { return }
            
            Firestore.firestore().collection("users").document(receiverID).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                //          fetch our user here
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                self.navigationItem.title = self.user?.name
                
//                guard let senderImageUrl = self.user?.imageUrl1 else {return}
//                self.userProfileImage.loadImageUsingCacheWithUrlString(urlString: senderImageUrl)
                
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        
        navigationItem.title = "Username"
        
        setupLayout()
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        fetchCurrentUserMessages()
    
    }
    
    var messages = [Message]()
    
    fileprivate func fetchCurrentUserMessages() {
        
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Firestore.firestore().collection("conversations").document(senderId).collection("messages")
        
        ref.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err)
                return
            } else {
                
                for document in querySnapshot!.documents {
                    
                    let msg = document.data()
                    msg.forEach({ (key, value) in
//                        print(msg)
                        
                        let message = Message(msg: msg)
                        
                        if message.receiver == self.conversation?.sender {
                            self.messages.append(message)
                        }
                    })
                    
                    self.collectionView.reloadData()

                }
                

            }
        
            }
        }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.item]
        
        cell.chatLogLabel.text = message.text
        
        
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if case let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)], context:  nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        containerView.backgroundColor = .white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14 , weight: .semibold)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 50, height: 0))
        
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 30, right: 12), size: .init(width: 0, height: 50))
        
        return containerView
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Message..."
        return tf
    }()
    
    @objc func handleSend() {
        print("sender:",self.conversation?.receiver ?? "" )
        print("receiver:", self.conversation?.sender ?? "")
        print("send messages:", textField.text ?? "")

        let senderId = self.conversation?.receiver ?? ""
        let receiverId = self.conversation?.sender ?? ""
        let message = ["text": textField.text ?? "",
                    "sender":senderId,
                    "date":Date().timeIntervalSince1970,
            "receiver":receiverId
        ] as [String : Any]

        Firestore.firestore().collection("conversations").document(senderId).collection("messages"
            ).addDocument(data: message) { (err) in
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
                
                self.textField.text = nil

                print("successfully inserted comment.")
                self.fetchCurrentUserMessages()
        }

    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
//            let cameraButton = UIButton(type: .system)
//                cameraButton.setImage(#imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), for: .normal)
//                cameraButton.imageView?.contentMode = .scaleAspectFill
//            containerView.addSubview(cameraButton)
//            cameraButton.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 0))
//
//
//            let photoButton = UIButton(type: .system)
//                photoButton.setImage(#imageLiteral(resourceName: "photo").withRenderingMode(.alwaysOriginal), for: .normal)
//                photoButton.imageView?.contentMode = .scaleAspectFill
//            containerView.addSubview(photoButton)
//            cameraButton.anchor(top: containerView.topAnchor, leading: cameraButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 32, height: 32))
            
            
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    fileprivate func setupLayout() {
        view.addSubview(cameraButton)
//        cameraButton.anchor(top: <#T##NSLayoutYAxisAnchor?#>, leading: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, trailing: <#T##NSLayoutXAxisAnchor?#>)
    }
    
    
        let cameraButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
        
        let photoButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "photo").withRenderingMode(.alwaysOriginal), for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
        
        
    
    


}
