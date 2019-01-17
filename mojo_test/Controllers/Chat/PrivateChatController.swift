//
//  PrivateChatController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class PrivateChatController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .yellow
        
        navigationItem.title = "Username"
        
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        containerView.backgroundColor = .white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 , weight: .semibold)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 50, height: 0))
        
        let textField = UITextField()
        textField.placeholder = "Message..."
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 30, right: 12), size: .init(width: 0, height: 50))
        
        return containerView
    }()
    
    @objc func handleSend() {
        print("send messages..")
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
