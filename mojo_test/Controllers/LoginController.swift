
//
//  LoginController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/30/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
//import Firebase

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r:255, g:255, b:255)
        
        let inputsContainerView = UIView()
        inputsContainerView.backgroundColor = UIColor.white
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        
        var loginRegisterButton = UIButton()
        loginRegisterButton.backgroundColor = UIColor(r: 255, g: 96, b: 181)
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.setTitleColor(UIColor.white, for: .normal);
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginRegisterButton.layer.cornerRadius = 5
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
//        loginRegisterButton.addTarget(self, action: #selector (handleRegister), for: .touchUpInside)
        
        func handleRegister() {
            
        }
        
        let nameTextFeild = UITextField()
        nameTextFeild.placeholder = "Username"
        nameTextFeild.textColor = UIColor.lightGray
        nameTextFeild.font = UIFont.boldSystemFont(ofSize: 16)
        nameTextFeild.translatesAutoresizingMaskIntoConstraints = false
        
        let nameSeparatorView = UIView()
        nameSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        nameSeparatorView.translatesAutoresizingMaskIntoConstraints = false
 
        
        let emailTextFeild = UITextField()
        emailTextFeild.placeholder = "Email"
        emailTextFeild.textColor = UIColor.lightGray
        emailTextFeild.font = UIFont.boldSystemFont(ofSize: 16)
        emailTextFeild.translatesAutoresizingMaskIntoConstraints = false
        
        let emailSeparatorView = UIView()
        emailSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        emailSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let passwordTextFeild = UITextField()
        passwordTextFeild.placeholder = "Password"
        passwordTextFeild.isSecureTextEntry = true
        passwordTextFeild.textColor = UIColor.lightGray
        passwordTextFeild.font = UIFont.boldSystemFont(ofSize: 16)
        passwordTextFeild.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        
        
        //inputContainer
        //need x y, witdth , height, contrstraints
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextFeild)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextFeild)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextFeild)
        
        //need x y, witdth , height, contrstraints
        nameTextFeild.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        nameTextFeild.topAnchor.constraint(equalTo: inputsContainerView.topAnchor,constant:8).isActive = true
        nameTextFeild.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFeild.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x y, witdth , height, contrstraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextFeild.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //need x y, witdth , height, contrstraints
        emailTextFeild.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        emailTextFeild.topAnchor.constraint(equalTo: nameTextFeild.bottomAnchor,constant:8).isActive = true
        emailTextFeild.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFeild.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x y, witdth , height, contrstraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextFeild.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x y, witdth , height, contrstraints
        passwordTextFeild.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        passwordTextFeild.topAnchor.constraint(equalTo: emailTextFeild.bottomAnchor).isActive = true
        passwordTextFeild.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFeild.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        //setupResgisterButton
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-20).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
    }
    
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }

}

extension UIColor {
    convenience init(r: CGFloat, g:CGFloat, b:CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha:1)
    }
}
