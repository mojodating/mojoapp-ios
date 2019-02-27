//
//  PrivateChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class PrivateChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, ChatInputAccessaryViewDelegate {
    
    let cellId = "cellId"
    let requestCellId = "requestCellId"
    
    var chatProfileUID: String?
    var conversation : Conversation? {
        didSet {
            
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            
            if currentUser == conversation?.sender {
                chatProfileUID = conversation?.receiver
            } else {
                chatProfileUID = conversation?.sender
            }
            
        }
    }
    
    var user: User?
    fileprivate func fetchChatPartner() {
        Firestore.firestore().collection("users").document(chatProfileUID ?? "").getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            //          fetch our user here
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            guard let userName = self.user?.name else { return }
            self.nameTitleButton.setTitle("\(userName) ", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        
        setupNavigation()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View profile", style: .plain, target: self, action: #selector(handleViewProfile))
        
        setupLayout()
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(RequestMessageCell.self, forCellWithReuseIdentifier: requestCellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        fetchChatPartner()
        
        fetchMessages()
    }
    
    
    @objc fileprivate func handleViewProfile() {
        let viewProfileController = ViewProfileController()
        viewProfileController.user = self.user
        present(viewProfileController, animated: true)
    }
    
    var messages = [Message]()

    fileprivate func fetchMessages() {

        guard let converstionId = self.conversation?.id else { return }

        let ref = Firestore.firestore().collection("conversations").document(converstionId).collection("messages").order(by: "date", descending: false)

        ref.addSnapshotListener { querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    
                    let msg = diff.document.data()
                    let message = Message(msg: msg)
                    
                    self.messages.append(message)

                    self.collectionView.reloadData()
                    }
                }
            }
        }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requestCellId, for: indexPath) as! RequestMessageCell
            
            let message = messages[indexPath.item]
            
            setupRequestCell(cell: cell, message: message)
            
            cell.chatLogLabel.text = message.text
            
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
            cell.bubbleHeightAnchor?.constant = estimateFrameForText(text: message.text).height + 20
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.item]
        
        cell.chatLogLabel.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
        cell.bubbleHeightAnchor?.constant = estimateFrameForText(text: message.text).height + 20
        return cell
        
    }
    
    fileprivate func setupRequestCell(cell: RequestMessageCell, message: Message ) {
        // fetch requestor profile photo
        if let requestorUID = self.conversation?.sender {
            Firestore.firestore().collection("users").document(requestorUID).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                //          fetch our user here
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                guard let requestorProfileUrl = self.user?.imageUrl1 else {return}
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: requestorProfileUrl)
            }
        }
        

        if let giftImageUrl = self.conversation?.drinkImage {
            cell.giftImageView.loadImageUsingCacheWithUrlString(urlString: giftImageUrl)
        }
        cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9518757931, green: 0.9518757931, blue: 0.9518757931, alpha: 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm tt"
        let dateString = dateFormatter.string(from: (message.date))
        
        if message.sender == Auth.auth().currentUser?.uid {
            // purple bubble
            cell.descriptionLabel.text = "You sent this chat request at \(dateString)."
          
        } else {
            cell.descriptionLabel.text = "By reply you accept the request and the gift. Or reject."
        }
        
        // fetch gift Info
        guard let giftName = self.conversation?.drinkName else {return}
        guard let giftPrice = self.conversation?.drinkPrice else { return }
        let attributedString = NSMutableAttributedString(string: "\(giftName) \n\(giftPrice) Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        cell.giftInfoLabel.attributedText = attributedString
        
    }
    
    fileprivate func setupCell(cell:MessageCell, message: Message ) {
        
        if message.sender == Auth.auth().currentUser?.uid {
            // color bubble
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9518757931, green: 0.9518757931, blue: 0.9518757931, alpha: 1)
            cell.chatLogLabel.textColor = .black
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
                        
        } else {
            //white bubble
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9137254902, blue: 0.9254901961, alpha: 1)
            cell.chatLogLabel.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
        
        // fetch userProfile
        let senderUID = message.sender
        Firestore.firestore().collection("users").document(senderUID).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            //          fetch our user here
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            
            guard let senderImageUrl = self.user?.imageUrl1 else {return}
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: senderImageUrl)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 150
        
        height = estimateFrameForText(text: messages[indexPath.item].text).height + 20
        
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: height + 240)
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
        
        // Refresh the chat page
        collectionView.reloadData()
    }
    
    lazy var containerView: ChatInputAccessaryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let chatInputAccessaryView = ChatInputAccessaryView(frame: frame)
        chatInputAccessaryView.delegate = self
        return chatInputAccessaryView
    }()
    
    func didSend(for messageText: String) {
        
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        var receiverId: String?
        
        if senderId == conversation?.sender {
            receiverId = conversation?.receiver
        } else {
            receiverId = conversation?.sender
        }
    
        let message = ["text": messageText,
                       "sender":senderId,
                       "date":Date().timeIntervalSince1970,
                       "receiver":receiverId ?? ""
            ] as [String : Any]
        
        let conversationId = self.conversation?.id ?? ""
        
        if messageText != "" {
            Firestore.firestore().collection("conversations").document(conversationId).collection("messages"
                ).addDocument(data: message) { (err) in
                    if let err = err {
                        print("Failed to insert comment:", err)
                        return
                    }
                    
                    print("successfully inserted comment.")
                    self.containerView.clearTextField()
            }
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
            
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    fileprivate func setupLayout() {
        
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
        
        
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        didSend(for: messageText)
//        return true
//    }
    
    let nameTitleButton = UIButton(title: "", cornerRadius: 0, font: .systemFont(ofSize: 18, weight: .semibold))
    fileprivate func setupNavigation() {
        nameTitleButton.setTitleColor(.black, for: .normal)
        nameTitleButton.setImage(#imageLiteral(resourceName: "rightArrow").withRenderingMode(.alwaysOriginal), for: .normal)
        nameTitleButton.frame = CGRect(x: 0, y: -2, width: 130, height: 20)
        nameTitleButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        nameTitleButton.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        self.navigationItem.titleView = nameTitleButton
        
//        if #available(iOS 11.0, *) {
//            navigationItem.largeTitleDisplayMode = .never
//            navigationController?.navigationBar.prefersLargeTitles = false
//        }
        
    }
    


}
