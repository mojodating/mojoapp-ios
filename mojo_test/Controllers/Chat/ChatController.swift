//
//  ChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/12/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import CoreData

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var messages: [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.item] {
            cell.message = message
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
    

}


class MessageCell: BaseCell {
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(for: Date())
            }
            
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Name"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Friend's message or something else..."
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05pm"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func  setupViews() {
        
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        profileImageView.image = #imageLiteral(resourceName: "peter")
        hasReadImageView.image = #imageLiteral(resourceName: "peter")
        
        //setupLayout
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 16, left: 16, bottom: 16, right: 16), size: .init(width: 68, height: 68))
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }

    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        containerView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView )
        
        nameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        messageLabel.anchor(top: nameLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: hasReadImageView.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        timeLabel.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        hasReadImageView.anchor(top: timeLabel.bottomAnchor, leading: messageLabel.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 8, right: 8), size: .init(width: 20, height: 20))
        
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}



