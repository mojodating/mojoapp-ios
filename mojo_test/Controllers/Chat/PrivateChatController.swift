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

class PrivateChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, ChatInputAccessaryViewDelegate {
    
    let cellId = "cellId"
    let requestCellId = "requestCellId"
    let headerId = "headerId"
    
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
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            guard let userName = self.user?.name else { return }
//            self.nameTitleButton.setTitle("\(userName) ", for: .normal)
            self.navigationItem.title = userName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        
        setupNavigation()
        
        setupCollectionView()
        
        fetchChatPartner()
        
        fetchMessages()
        
//        markMessageAsSeen()
    }
    
    fileprivate func setupNavigation() {
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(RequestMessageCell.self, forCellWithReuseIdentifier: requestCellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 80, right: 8)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.register(PrivateChatDateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    @objc fileprivate func handleViewProfile() {
        let viewProfileController = ViewProfileController()
        viewProfileController.user = self.user
        present(viewProfileController, animated: true)
    }
    
    var messages = [Message]()

    fileprivate func fetchMessages() {

        guard let converstionId = self.conversation?.id else { return }

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
                    self.collectionView.reloadData()
                    }
                }
//            self.groupMessageByDate()
            }
        }
    
    fileprivate func markMessageAsSeen() {
        
        let messageId = self.messages.last?.id
        let conversationId = self.conversation?.id ?? ""
        Firestore.firestore().collection("conversations").document(conversationId).collection("messages"
            ).document(messageId ?? "")
            .updateData([
                "seen": true,
            ]) { (err) in
                if let err = err {
                    print("Failed to mark message", err)
                    return
            }
        }
    }
    
//    var groupedMessages = [[Message]]()
//
//    fileprivate func groupMessageByDate() {
//
//        let grouped = Dictionary(grouping: messages) { (message) -> Date in
//            return message.date
//        }
//
//        let sortedKeys = grouped.keys.sorted(by: <)
//        sortedKeys.forEach { (key) in
//            let values = grouped[key]
//            groupedMessages.append(values ?? [])
//            self.collectionView.reloadData()
//        }
//
//    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return groupedMessages.count
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PrivateChatDateHeaderView
//
//        if let firstMessageInSection = groupedMessages[indexPath.section].first {
//            headerView.dateLabel.text = Date.StringFromCustomDate(costumDate: firstMessageInSection.date)
//        }
//
//        return headerView
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return groupedMessages[section].count
        return messages.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 200, height: 40)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if indexPath.section == 0 && indexPath.row == 0{
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requestCellId, for: indexPath) as! RequestMessageCell
            
            let message = messages[indexPath.item]
//            let message = groupedMessages[indexPath.section][indexPath.row]
            
            setupRequestCell(cell: cell, message: message)
            
            cell.chatLogLabel.text = message.text
            
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
            cell.bubbleHeightAnchor?.constant = estimateFrameForText(text: message.text).height + 20
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.item]
//        let message = groupedMessages[indexPath.section][indexPath.row]
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
                if let requestProfileUrl = URL(string: requestorProfileUrl) {
                    cell.profileImageView.sd_setImage(with: requestProfileUrl)
                }
            }
        }
        

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
            cell.descriptionLabel.text = "By reply you accept the request and the gift. Or reject this user and gift."
        }
        
        // fetch gift Info
        guard let giftName = self.conversation?.drinkName else {return}
        guard let giftPrice = self.conversation?.drinkPrice else { return }
        let attributedString = NSMutableAttributedString(string: "\(giftName) \n\(giftPrice) Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        cell.giftInfoLabel.attributedText = attributedString
        
        if collectionView.numberOfSections > 1 {
            cell.rejectButton.isHidden = true
        } else {
            cell.rejectButton.isHidden = false
            cell.rejectButton.addTarget(self, action: #selector(handleRejectRequest), for: .touchUpInside)
        }
    }
    
    @objc fileprivate func handleRejectRequest() {
        
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
            
            guard let imageUrl = self.user?.imageUrl1 else {return}
            if let imageUrl = URL(string: imageUrl) {
                 cell.profileImageView.sd_setImage(with: imageUrl)
            }
        }        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 150
        
        height = estimateFrameForText(text: messages[indexPath.item].text).height + 36
        
        if indexPath.section == 0 && indexPath.row == 0 {
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
        
        
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        didSend(for: messageText)
//        return true
//    }
    


}
