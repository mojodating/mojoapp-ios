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

class UserProfileController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //set up navigation to transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        
        setupLayout()
        
        fetchCurrentUser()
        
        setupSettingsButton()
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
        
        alertController.addAction(UIAlertAction(title: "Invite Friends", style: .default, handler: { (_) in
            
        }))
   
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
  
            try? Auth.auth().signOut()
            self.dismiss(animated: true)
     
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("UserProfileController did appear")
        //kick the user out when they log out
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
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
            self.navigationItem.title = self.user?.name
        }
    }
    
//    fileprivate func setupCardFromUser(user: User) {
//        let cardView = CardView(frame: .zero)
//        cardView.delegate = self as? CardViewDelegate
//        cardView.cardViewModel = user.toCardViewModel()
//        cardsDeckView.addSubview(cardView)
//        cardView.fillSuperview()
//        cardsDeckView.sendSubviewToBack(cardView)
//
//    }
    
    fileprivate func setupLayout() {
        
        //add a gradient layer
        
    }
    
    @objc func handleEditProfile() {
        
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    func didSaveSettings() {
        print("notified of dismissal from settingController to homeController")
        fetchCurrentUser()
    }


}
