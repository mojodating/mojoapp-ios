//
//  UserProfileController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/17/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class UserProfileController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
  
        setupLayout()
        
        fetchCurrentUser()
        
        setupSettingsButton()
    }
    
    fileprivate func setupNavigation() {
        //set up navigation to transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 34
        return imageView
    }()
    
    fileprivate func setupSettingsButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettingMenu))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "208322b9-6bf3-4241-9cec-17a73e689bac").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleEditProfile))
    }
    
    
    @objc fileprivate func handleSettingMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Free Tokens", style: .default, handler: { (_) in
            
            self.handleInviteNewUser()
            
        }))
   
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            self.handleLogout()

        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }

    
    var user: User?
    
    func fetchCurrentUser() {
        //fetch some firestore data
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            //fether our user here
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            guard let currentUserName = self.user?.name else { return }
            self.navigationItem.title = currentUserName
            self.userNameLabel.text = currentUserName
            self.userInfoLabel.text = "\(self.user?.age ?? 0), "  + (self.user?.profession ?? "")
//            self.userSwipingPhotosController.user = self.user
            self.gradientView.user = self.user
            
        }
    }
    
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return label
        
    }()
    
    let userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Age, Profession"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
//    let userSwipingPhotosController = CurUserSwipingPhotoController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let gradientView = CurrentUserPhotoView()
    
    fileprivate func setupLayout() {
        
//        let userPhotoView = userSwipingPhotosController.view!
//        view.addSubview(userPhotoView)
//        userPhotoView.fillSuperview()

        view.addSubview(gradientView)
        gradientView.fillSuperview()
        
        view.addSubview(userInfoLabel)
        userInfoLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 0))
        
        view.addSubview(userNameLabel)
        userNameLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: userInfoLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 8, right: 0))

    }
    
    
    @objc func handleEditProfile() {
        
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    fileprivate func handleInviteNewUser() {
        let controller = InviteNewUserController()
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        
        let registrationController = RegistrationController()
        let navController = UINavigationController(rootViewController: registrationController)
        self.present(navController, animated: true)
    }
    


}
