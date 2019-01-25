//
//  chatInputAccessoryView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/25/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

protocol ChatInputAccessaryViewDelegate {
    func didSend(for message: String)
}

class ChatInputAccessaryView: UIView {
    
    var delegate: ChatInputAccessaryViewDelegate?
    
    func clearTextField() {
        textField.text = nil
    }
    
    fileprivate let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Message..."
//        tf.delegate = self
        return tf
    }()
    
    fileprivate let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14 , weight: .semibold)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 50, height: 0))
        
        addSubview(textField)
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        
    }
    
    @objc func handleSend() {
        
        guard let messageText = textField.text else {return}
        
        delegate?.didSend(for: messageText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
