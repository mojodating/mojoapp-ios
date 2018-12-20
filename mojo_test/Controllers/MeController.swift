//
//  MeController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/17/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class MeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate {
    
    let cardsDeckView = UIView()
    var cardViewModel = [CardViewModel]()
    let topStackView = TopNavigationStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        setupLayout()
        
        fetchCurrentUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MeController did appear")
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
//            print(snapshot?.data())
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.setupCardFromUser(user: self.user!)
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self as? CardViewDelegate
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
        cardsDeckView.sendSubviewToBack(cardView)
        
    }
    
    fileprivate func setupLayout() {
        
        //add a gradient layer
        view.addSubview(cardsDeckView)
        cardsDeckView.fillSuperview()
        view.addSubview(topStackView)
        topStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    }
    
    @objc func handleSettings () {
        
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
