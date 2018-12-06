//
//  FourthViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/29/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let cardsDeckView = UIView()
    var cardViewModels = [CardViewModel]() // empty array
    let topStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = .white
        view.addSubview(cardsDeckView)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        setupFirestoreUserCards()
        
        cardsDeckView.addSubview(topStackView)
        cardsDeckView.addSubview(bottomControls)
        
        topStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        bottomControls.frame = .init(x: view.frame.size.width - 48, y:view.frame.size.height - 403 , width: 48, height: 403)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        cardsDeckView.bringSubviewToFront(topStackView)
        cardsDeckView.bringSubviewToFront(bottomControls)
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD (style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in:view)
        // introduce pagination here
 
        let query = Firestore.firestore().collection("users").order(by:"uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to:2)
        
//        let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 26)
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print( "fail to fetch users", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
                
        })

    }
}
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
        cardsDeckView.sendSubviewToBack(cardView)
    }

    @objc func handleSignup () {
        print ("show registration page")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach {(cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            cardsDeckView.sendSubviewToBack(cardView)
        }
        
    }
            
}
        

    



