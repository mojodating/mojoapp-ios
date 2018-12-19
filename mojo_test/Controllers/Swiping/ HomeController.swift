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
import Cosmos
import TinyConstraints

class HomeController: UIViewController, CardViewDelegate {
    
    
    let cardsDeckView = UIView()
    var cardViewModels = [CardViewModel]() // empty array
//    let topStackView = TopNavigationStackView()
        let bottomControls = HomeBottomControlStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = .white
        view.addSubview(cardsDeckView)
//        view.addSubview(topStackView)
        view.addSubview(bottomControls)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
//        topStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        bottomControls.frame = .init(x: view.frame.size.width - 184, y:view.frame.size.height - 403 , width: 184, height: 212)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        handleRating()
        
        view.sendSubviewToBack(cardsDeckView)
        
//        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        fetchCurrentUser()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("HomeController did appear")
//        //kick the user out when they log out
//        if Auth.auth().currentUser == nil {
//            let registrationController = RegistrationController()
//            registrationController.delegate = self
//            let navController = UINavigationController(rootViewController: registrationController)
//            present(navController, animated: true)
//        }
//    }
    
//    func didFinishLoggingIn() {
//        fetchCurrentUser()
//    }
    
    
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
  
//        let query = Firestore.firestore().collection("users").order(by:"uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to:2)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
//        let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 26)
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print( "fail to fetch users", err)
                return
            }
            
            //set up the nextCard relationship with the card
            //link list
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
        })

    }
}
    
    var topCardView:  CardView?
    
    fileprivate func handleRating() {
        bottomControls.cosmosView.didFinishTouchingCosmos = { rating in
            print("Rated: \(rating)")
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.topCardView?.frame = CGRect (x: 0 , y: -600, width: self.topCardView!.frame.width, height: self.topCardView! .frame.height)
            }) { (_) in
                self.topCardView?.removeFromSuperview()
                self.topCardView = self.topCardView?.nextCardView
                self.bottomControls.cosmosView.rating = 0
                
            }
        }
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
        self.bottomControls.cosmosView.rating = 0
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
        cardsDeckView.sendSubviewToBack(cardView)
        return cardView
    }
    
    func didTapChatButton(cardViewModel:CardViewModel) {
        print("Home controller:", cardViewModel.attributedString)
        let chatRequestController = ChatRequestController()
        chatRequestController.cardViewModel = cardViewModel
        present(chatRequestController, animated: true)
//        let modalViewController = ModalViewController()
//        modalViewController.cardViewModel = cardViewModel
//        modalViewController.modalPresentationStyle = .overCurrentContext
//        present(modalViewController, animated: true)

    }
    

}
        

    



