//
//  SignupPhotoController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension SignupPhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

class SignupPhotoController: UIViewController {
    
    var email: String?
    var password: String?
    var userName: String?
    
    var delegate: LoginControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupRegistrationViewModelObserver()
    }
    
    let titleLabel = UILabel(text: "Upload a fabulous photo of you", font: .boldSystemFont(ofSize: 24))
    
    let uploadPhotoButton = UIButton(title: "Upload a photo", cornerRadius: 0, font: .boldSystemFont(ofSize: 18))
    
    let registerButton = UIButton(title: "Sign Up", cornerRadius: 0, font: .boldSystemFont(ofSize: 18))
    
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 36, left: 36, bottom: 0, right: 0))
        
        view.addSubview(uploadPhotoButton)
        uploadPhotoButton.fillSuperview()
        uploadPhotoButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside )
        uploadPhotoButton.imageView?.contentMode = .scaleAspectFill
        uploadPhotoButton.clipsToBounds = true
        
        view.addSubview(registerButton)
        registerButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 36, bottom: 16, right: 36), size: .init(width: view.frame.width - 72, height: 50))
        registerButton.isEnabled = false
        registerButton.backgroundColor = .blue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister() {
        
//        self.handleTapDismiss()
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
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD (style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay:4)
    }
    
    @objc func handleSelectPhoto() {
        print("select photo")
        let imagePickerController  = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    //Mark:- private
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self]
            (isFormValid) in
            self.registerButton.isEnabled = true
        }
        
        registrationViewModel.bindableImage.bind {[unowned self] (img) in
            self.uploadPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)            
            
        }
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            }else {
                self.registeringHUD.dismiss()
            }
        }
    }


}
