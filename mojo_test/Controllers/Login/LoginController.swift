//
//  LoginController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/9/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
     func didFinishLoggingIn()
}

class LoginController: UIViewController {
    
    var delegate: LoginControllerDelegate?

    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.heightAnchor.constraint(equalToConstant: 32)
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let titleLabel = UILabel(text: "Mojo", font: .systemFont(ofSize: 24, weight: .black))
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = #colorLiteral(red: 0.7864880562, green: 0.9731746316, blue: 0.9783737063, alpha: 1)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { (err) in
//            self.loginHUD.dismiss()
            self.loginHUD.textLabel.text = "Email or password is wrong"
            self.loginHUD.show(in: self.view)
            self.loginHUD.dismiss(afterDelay: 3)
            if let err = err {
                print("failed to log in:", err)
                return
            }
            
            print("Logged in sucessfully")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }

            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoggingIn()
            })
        }
    }
     
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to signup", for: .normal)
//        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .white
        setupLayout()
        setupBindables()
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.7864880562, green: 0.9731746316, blue: 0.9783737063, alpha: 1) : #colorLiteral(red: 0.7864880562, green: 0.9731746316, blue: 0.9783737063, alpha: 1)
            self.loginButton.setTitleColor(isFormValid ? .black : .white, for: .normal)
        }
        loginViewModel.isLoggingIn.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Logging in"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 0))
        titleLabel.textAlignment = .center
        
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
    }
}
