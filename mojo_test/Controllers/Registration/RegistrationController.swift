//
//  RegistrationController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/4/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        registrationViewModel.checkFormValidity()
        
//        registrationViewModel.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

class RegistrationController: UIViewController {
    
    var delegate: LoginControllerDelegate?
    
    //UI components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.9640902602, green: 0.9640902602, blue: 0.9640902602, alpha: 1)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside )
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    } ()
    
    @objc func handleSelectPhoto() {
        print("select photo")
        let imagePickerController  = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Username"
        tf.addTarget( self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    } ()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.addTarget( self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16 )
        tf.placeholder = "Set up a password"
        tf.isSecureTextEntry = true
        tf.addTarget( self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let inviteCodeField: CustomTextField = {
        let tf = CustomTextField(padding: 16 )
        tf.placeholder = "Have an invitation code? (Optional)"
        tf.addTarget( self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            print ("changing")
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else if textField == passwordTextField {
            registrationViewModel.password = textField.text
        } else {
            registrationViewModel.inviteCode = textField.text
        }
    }
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up mojo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5664333767, blue: 1, alpha: 1)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister() {
        if selectPhotoButton.currentImage == nil {
            hud.textLabel.text = "Please choose a photo"
            hud.show(in: self.view)
            hud.dismiss(afterDelay:3)
            return
        } else {
            self.handleTapDismiss()
            registrationViewModel.performRegistration { [weak self] (err) in
                if let err = err {
                    self?.showHUDWithError(error: err)
                    return
                }
                
                print("Finished registering")
                
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                
                mainTabBarController.setupViewControllers()
                
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.didFinishLoggingIn()
                })
            }
        }
        
        
    }
    
    let hud = JGProgressHUD (style: .dark)
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay:4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
        
    }
    
    //Mark:- private
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        
    registrationViewModel.bindableIsFormValid.bind { [unowned self]
        (isFormValid) in
        self.registerButton.isEnabled = true
    }
        
        registrationViewModel.bindableImage.bind {[unowned self] (img) in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Registering"
                self.registeringHUD.show(in: self.view)
            }else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:1, initialSpringVelocity:1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification:Notification) {
        print ("keyboard will show")
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
        { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        //the gap from register button to the keyboard
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        print(bottomSpace)
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    let titleLabel = UILabel(text: "Mojo", font: .systemFont(ofSize: 24, weight: .black))
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        inviteCodeField,
        registerButton
        ])
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoToLogin() {
        let loginController = LoginController()
        loginController.delegate = delegate
        navigationController?.pushViewController(loginController, animated: true)
        
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        titleLabel.textAlignment = .center
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        selectPhotoButton.heightAnchor.constraint(equalToConstant: view.frame.height - 460).isActive = true
        
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        
    }

}
