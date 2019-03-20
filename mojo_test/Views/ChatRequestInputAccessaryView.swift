//
//  File.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/10/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

protocol ChatRequestInputAccessaryViewDelegate {
    func didSendRequest(for requestText: String)
}

class ChatRequestInputAccessaryView: UIView {
    
    var delegate: ChatRequestInputAccessaryViewDelegate?
    
    let cellId = "cellId"
    
    func clearTextField() {
        textView.text = nil
        textView.showPlaceHolderLabel()
        
    }
    
    fileprivate let textView: ChatRequestInputTextView = {
        let tv = ChatRequestInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    fileprivate let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14 , weight: .semibold)
        button.addTarget(self, action: #selector(handleSendRequest), for: .touchUpInside)
        return button
    }()
    
    fileprivate let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        autoresizingMask = .flexibleHeight
        
        addSubview(separatorView)
        separatorView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: frame.width, height: 1))
        separatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        addSubview(sendButton)
        sendButton.anchor(top: separatorView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 50, height: 50))
        
        addSubview(textView)
        if #available(iOS 11.0, *) {
            textView.anchor(top: separatorView.bottomAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        } else {
            
        }
        
    }
    
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handleSendRequest() {
        
        guard let requestText = textView.text else {return}
        
        delegate?.didSendRequest(for: requestText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
