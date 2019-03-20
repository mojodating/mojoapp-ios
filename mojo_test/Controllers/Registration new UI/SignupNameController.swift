//
//  SignupNameController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class SignupNameController: UIViewController {
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 36, left: 36, bottom: 0, right: 0))
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 48, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 40))
        
        view.addSubview(lineView)
        lineView.anchor(top: nameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 4, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 1))
        
        view.addSubview(nextButton)
        nextButton.anchor(top: lineView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 36, left: 0, bottom: 0, right: 36), size: .init(width: 60, height: 50))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's Create Your Profile"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your Name"
        tf.addTarget( self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registrationViewModel = RegistrationViewModel()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == nameTextField {
            print ("changing")
            registrationViewModel.password = textField.text
        }
//        checkFormValidity()
    }
    
    func checkFormValidity() {
        
        if nameTextField.text?.isEmpty == false {
            nextButton.isEnabled = true
            nextButton.setTitleColor(#colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1), for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        }
        
    }
    
    let lineView: UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.8874994674, green: 0.8874994674, blue: 0.8874994674, alpha: 1)
        return lv
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(#colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSignupNext), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleSignupNext() {        
        let controller = SignupPhotoController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
