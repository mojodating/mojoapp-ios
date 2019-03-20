//
//  NewLoginController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/21/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class NewLoginController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 36, left: 36, bottom: 0, right: 0))
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 40))
        
        view.addSubview(lineView)
        lineView.anchor(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 4, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 1))
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: lineView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 40))
        
        view.addSubview(lineIIView)
        lineIIView.anchor(top: passwordTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 4, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 1))
        
        view.addSubview(forgetPsLabel)
        forgetPsLabel.anchor(top: lineIIView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 36, bottom: 0, right: 36))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    let lineView: UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.8874994674, green: 0.8874994674, blue: 0.8874994674, alpha: 1)
        return lv
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        return tf
    }()
    
    let lineIIView: UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.8874994674, green: 0.8874994674, blue: 0.8874994674, alpha: 1)
        return lv
    }()
    
    let forgetPsLabel: UILabel = {
        let label = UILabel()
        label.text = "Forget Password?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = #colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)
        return label
    }()
    
    
}
