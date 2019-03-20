//
//  SignupMainController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/21/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class SignupMainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setupLayout()
        
    }
    
    func setupLayout() {
        view.addSubview(TitleLabel)
        TitleLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil)
        TitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        TitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(warningLabel)
        warningLabel.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil)
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(LoginButton)
        LoginButton.anchor(top: nil, leading: nil, bottom: warningLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 48, right: 0))
        LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(SignupButton)
        SignupButton.anchor(top: nil, leading: nil, bottom: LoginButton.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: view.frame.width * 3 / 4 , height: 50))
        SignupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    let TitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mojo"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    let SignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up with Email", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 24
        button.backgroundColor = #colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleSignup() {
        let emailController = SignupEmailController()
        navigationController?.pushViewController(emailController, animated: true)
    }
    
    let LoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        let loginController = NewLoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "By signing up for mojo, you agree to our Terms & privacy Policy"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    

}
