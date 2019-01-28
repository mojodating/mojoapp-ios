//
//  chatInputAccessoryView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/25/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

protocol ChatInputAccessaryViewDelegate {
    func didSend(for messageText: String)
}

class ChatInputAccessaryView: UIView {
    
    var delegate: ChatInputAccessaryViewDelegate?
    
    func clearTextField() {
        textView.text = nil
        textView.showPlaceHolderLabel()
    
    }
    
    fileprivate let textView: ChatInputTextView = {
        let tv = ChatInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
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
        
        autoresizingMask = .flexibleHeight
    
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 50, height: 50))
        
        addSubview(textView)
        if #available(iOS 11.0, *) {
        textView.anchor(top: topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        } else {
            
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handleSend() {
        
        guard let messageText = textView.text else {return}
        
        delegate?.didSend(for: messageText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
