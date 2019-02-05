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
    let SectionHeader = "SectionHeader"
    let requestCellId = "requestCellId"
    
    var user: User?
    var conversation : Conversation? {
        didSet {
            
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            var chatProfileUID: String?
            
            if currentUser == conversation?.sender {
                chatProfileUID = conversation?.receiver
            } else {
                chatProfileUID = conversation?.sender
            }
            
            Firestore.firestore().collection("users").document(chatProfileUID!).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                //          fetch our user here
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                self.navigationItem.title = self.user?.name
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = #colorLiteral(red: 0.9218030841, green: 0.9218030841, blue: 0.9218030841, alpha: 1)
        
        navigationItem.title = "Username"
        
        setupLayout()
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(RequestMessageCell.self, forCellWithReuseIdentifier: requestCellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        fetchMessages()
        
        

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

        if let giftImageUrl = self.conversation?.drinkImage {
            cell.giftImageView.loadImageUsingCacheWithUrlString(urlString: giftImageUrl)
        }
        
        if message.sender == Auth.auth().currentUser?.uid {
            // purple bubble
            cell.bubbleView.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1)
            cell.chatLogLabel.textColor = .black
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm tt"
            let dateString = dateFormatter.string(from: (message.date))
            
            let attributedString = NSMutableAttributedString(string: "You sent this chat request at \(dateString).", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            cell.descriptionLabel.attributedText = attributedString
        
            
        } else {
            //grey bubble
            cell.bubbleView.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1)
            cell.chatLogLabel.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
            
            let attributedString = NSMutableAttributedString(string: "By reply you accept the request and the gift. Ignore to reject.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            cell.descriptionLabel.attributedText = attributedString
        }
        
        guard let giftName = self.conversation?.drinkName else {return}
        guard let giftPrice = self.conversation?.drinkPrice else { return }
        let attributedString = NSMutableAttributedString(string: "\(giftName) \n\(giftPrice) Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        cell.giftInfoLabel.attributedText = attributedString
        
    }
    
    fileprivate func setupCell(cell:MessageCell, message: Message ) {
        
        if let profileImageUrl = self.user?.imageUrl1 {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.sender == Auth.auth().currentUser?.uid {
            // purple bubble
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            cell.chatLogLabel.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //grey bubble
            
            cell.bubbleView.backgroundColor = .white
            cell.chatLogLabel.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 150
        
        height = estimateFrameForText(text: messages[indexPath.item].text).height + 20
        
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: height + 220)
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
    


}
