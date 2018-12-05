//
//  FourthViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/29/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    let cardsDeckView = UIView()
    var cardViewModels = [CardViewModel]() // empty array
    let topStackView = TopNavigationStackView()
    let buttonStackView = HomeBottomControlStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = .white
        view.addSubview(cardsDeckView)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        setupDummyCards()
        fetchUsersFromFirestore()

    }
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print( "fail to fetch users", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
        })
        self.setupDummyCards()
    }
}

    @objc func handleSignup () {
        print ("show registration page")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach {(cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview ()
            cardView.addSubview(topStackView)
            cardView.addSubview(buttonStackView)
            
            topStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
            buttonStackView.frame = .init(x: view.frame.size.width - 48, y:view.frame.size.height - 403 , width: 48, height: 403)
            
            topStackView.settingsButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        }
        
    }
            
}
        

    



