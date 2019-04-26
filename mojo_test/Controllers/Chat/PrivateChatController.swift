//
//  PrivateChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

protocol PrivateChatControllerDelegate {
    func didDeleteConversation(conversation: Conversation)
}

class PrivateChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, ChatInputAccessaryViewDelegate {
    
    var delegate: PrivateChatControllerDelegate?
    
    let cellId = "cellId"
    let requestCellId = "requestCellId"
    let headerId = "headerId"
    var conversitionId: String?
    var chatProfileUID: String?
//    var requestorUID: String?
    var conversation : Conversation? {
        didSet {
            self.conversitionId = conversation?.id
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            
            if currentUser == conversation?.sender {
                chatProfileUID = conversation?.receiver
//                requestorUID = Auth.auth().currentUser?.uid
            } else {
                chatProfileUID = conversation?.sender
//                requestorUID = chatProfileUID
            }
            self.checkIfChatBlocked()
        }
    }
    
    var user: User?
    fileprivate func fetchChatPartner() {
        Firestore.firestore().collection("users").document(chatProfileUID ?? "").getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            guard let userName = self.user?.name else { return }
            self.navigationItem.title = userName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchChatPartner()
        
        fetchMessages()

        collectionView.backgroundColor = .white
        
        setupNavigation()
        
        setupCollectionView()
        
        setupNotificationObservers()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // Jump to new message
    var isLoading: Bool = false

    internal override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isLoading {
            let indexToScrollTo = IndexPath(item: messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexToScrollTo, at: .bottom, animated: false)
            isLoading = true
        }
    }
    
    fileprivate func checkIfChatBlocked() {
        if self.conversation?.rejected == true {
            self.containerView.isHidden = true
            self.blockedLabel.isHidden = false
        } else {
            self.containerView.isHidden = false
            self.blockedLabel.isHidden = true
        }
        view.addSubview(blockedLabel)
        blockedLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 36, bottom: 16, right: 36))
        blockedLabel.numberOfLines = 0
        blockedLabel.textColor = .lightGray
        blockedLabel.textAlignment = .center
    
    }
    let blockedLabel = UILabel(text: "Not able to send message. The conversation is blocked", font: .systemFont(ofSize: 14))
    
    fileprivate func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "details").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleChatDetails))

    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(RequestMessageCell.self, forCellWithReuseIdentifier: requestCellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 40, right: 8)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        collectionView.register(PrivateChatDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc private func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:1, initialSpringVelocity:1, options: .curveEaseOut, animations:{
                self.view.transform = .identity
        })
        }
    
    @objc fileprivate func handleKeyboardShow(notification:Notification) {
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
            { return }
        let keyboardFrame = value.cgRectValue

        self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    
    
    @objc func handleViewProfile() {
        let userDetailController = UserDetailController()
        userDetailController.user = self.user
        userDetailController.chatRequestButton.isHidden = true
        present(userDetailController, animated: true)
    }
    
    var messages = [Message]()

    fileprivate func fetchMessages() {

        guard let converstionId = self.conversitionId else { return }

        let ref = Firestore.firestore().collection("conversations").document(converstionId).collection("messages")
            .order(by: "date", descending: false)

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
                    self.isLoading = false
                    self.collectionView.reloadData()
                    self.markMessageAsSeen(message: message)
                    }
                }
//            self.groupMessageByDate()
            }
        }
    
    fileprivate func markMessageAsSeen(message: Message) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let conversationId = self.conversation?.id else { return }
        
        let timeSenderRef =  Firestore.firestore().collection("users").document(uid)
        timeSenderRef.updateData([
            "conversations.\(conversationId).seen": true,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
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
    
    var chatSender: User?
    
    fileprivate func setupRequestCell(cell: RequestMessageCell, message: Message ) {
        guard let requestorUID = self.conversation?.sender else { return }
        Firestore.firestore().collection("users").document(requestorUID).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }

                guard let dictionary = snapshot?.data() else { return }
                self.chatSender = User(dictionary: dictionary)
                
                guard let requestorProfileUrl = self.chatSender?.imageUrl1 else {return}
                if let requestProfileUrl = URL(string: requestorProfileUrl) {
                    cell.profileImageView.sd_setImage(with: requestProfileUrl)
                }
            }
        
        cell.profileImageView.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewRequesterProfile))
        singleTap.numberOfTapsRequired = 1
        cell.profileImageView.addGestureRecognizer(singleTap)
        

        guard let giftImageUrl = self.conversation?.drinkImage else { return }
        if let giftImageUrl = URL(string: giftImageUrl) {
            cell.giftImageView.sd_setImage(with: giftImageUrl)
        }
        cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9518757931, green: 0.9518757931, blue: 0.9518757931, alpha: 1)
        
        let dateString = Date.StringFromCustomDate(costumDate: message.date)
        
        if message.sender == Auth.auth().currentUser?.uid {
            // purple bubble
            cell.descriptionLabel.text = "You sent this chat request at \(dateString)."
          
        } else {
            if messages.count == 1 {
                cell.descriptionLabel.text = "Simply reply this conversation to accept this request and gift. To turn down both, select 'reject'."
            } else {
                cell.descriptionLabel.text = "Chat Request"
            }
        }
        
        // fetch gift Info
        guard let giftName = self.conversation?.drinkName else {return}
        guard let giftPrice = self.conversation?.drinkPrice else { return }
        let attributedString = NSMutableAttributedString(string: "\(giftName) \n\(giftPrice) Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        cell.giftInfoLabel.attributedText = attributedString
        
        if messages.count == 1 {
            cell.rejectButton.isHidden = false
            cell.rejectButton.addTarget(self, action: #selector(handleRejectRequest), for: .touchUpInside)
        } else {
            cell.rejectButton.isHidden = true
        }
    }
    
    @objc fileprivate func handleViewRequesterProfile() {
        let userDetailController = UserDetailController()
        userDetailController.user = self.chatSender
        userDetailController.chatRequestButton.isHidden = true
        present(userDetailController, animated: true)
    }
    
    @objc fileprivate func handleChatDetails() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "View profile", style: .default, handler: { (_) in
            self.handleViewProfile()
        }))
        alertController.addAction(UIAlertAction(title: "Block user", style: .destructive, handler: { (_) in
            self.performRejectRequest()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRejectRequest() {
        let alertController = UIAlertController(title: "Are you sure to reject this chat request and gift?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Reject request", style: .destructive, handler: { (_) in
            self.performRejectRequest()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    fileprivate func performRejectRequest() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let receiverUid = self.chatProfileUID else { return }
        guard let conversationId = self.conversitionId else { return }
        
        Firestore.firestore().collection("users").document(uid).updateData([
            "conversations.\(conversationId).rejected": true,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    
                    if self.conversation?.accepted == false {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.containerView.isHidden = true
                        self.blockedLabel.isHidden = false
                    }
                }
        }
        Firestore.firestore().collection("users").document(receiverUid).updateData([
            "conversations.\(conversationId).rejected": true,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
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
            cell.profileImageView.isUserInteractionEnabled = true
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewProfile))
            singleTap.numberOfTapsRequired = 1
            cell.profileImageView.addGestureRecognizer(singleTap)
        }
        
        // fetch userProfile
        Firestore.firestore().collection("users").document(chatProfileUID ?? "").getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            //          fetch our user here
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)

            guard let imageUrl = self.user?.imageUrl1 else {return}
            if let imageUrl = URL(string: imageUrl) {
                 cell.profileImageView.sd_setImage(with: imageUrl)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 500
        
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
        
        let conversationId = self.conversation?.id ?? ""
        
        let ref = Firestore.firestore().collection("conversations").document(conversationId).collection("messages")
        
        let message = ["text": messageText,
                       "sender":senderId,
                       "date":Date().timeIntervalSince1970,
                       "receiver":receiverId ?? "",
                       ] as [String : Any]
         if messageText != "" {
            ref.addDocument(data: message){ (err) in
                    if let err = err {
                        print("Failed to add message:", err)
                        return
                    }
                    
                print("successfully add message.")
                    self.containerView.clearTextField()
            }
        }
        
        let timeSenderRef =  Firestore.firestore().collection("users").document(senderId)
        let timeReceiveRef = Firestore.firestore().collection("users").document(receiverId ?? "")
            timeSenderRef.updateData([
            "conversations.\(conversationId).lastUpdated": Date().timeIntervalSince1970,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
        timeReceiveRef.updateData([
            "conversations.\(conversationId).lastUpdated": Date().timeIntervalSince1970,
            "conversations.\(conversationId).seen": false,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
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
