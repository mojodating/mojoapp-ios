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

class HomeController: UIViewController, CardViewDelegate, LoginControllerDelegate {
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
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
            
            self.fetchSwipes()
            
//            self.fetchUsersFromFirestore()
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("bouncingLineRating").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print ("failed to fetch swipes for currently logged in user:", err)
                return
            }
            
            print("Rated:", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
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
        topCardView = nil
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
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                if isNotCurrentUser && hasNotSwipedBefore {
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
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            guard let cardUID = self.topCardView?.cardViewModel.uid else { return }
            
            let documentData = [cardUID: rating]
            
            Firestore.firestore().collection("bouncingLineRating").document(uid).getDocument { (snapshot, err) in
                if let err = err {
                    print("failed to fetch rating document", err)
                    return
                }
                
                if snapshot?.exists == true {
                    Firestore.firestore().collection("bouncingLineRating").document(uid).updateData(documentData) { (err) in
                        if let err = err {
                            print("failed to save rating data", err)
                            return
                        }
                        print("successfully updated rating...")
                        self.checkIfMadeInTheHouse(cardUID: cardUID)
                    }
                } else {
                    Firestore.firestore().collection("bouncingLineRating").document(uid).setData(documentData) { (err) in
                        if let err = err {
                            print("failed to save rating data", err)
                            return
                        }
                        print("successfully saved rating")
                        self.checkIfMadeInTheHouse(cardUID: cardUID)
                    }
                }
            }
  
            self.performSwipeAnimation()
        }
    }
    
    fileprivate func checkIfMadeInTheHouse(cardUID: String) {
        //detect whether user made in the house
        print("detecting rating")
//        Firestore.firestore().collection("bouncingLineRating").document(cardUID).getDocument { (snapshot, err) in
//            if let err = err {
//                print("Failed to fetch document for card user:", err)
//                return
//            }
//
//            guard let data = snapshot?.data() else { return }
//            print (data)
//
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            let hasMadeInHouse = data[uid] as? Int == ??
//
//            if hasMadeInHouse {
//                print("You are invited to the house")
//                let hud = JGProgressHUD(style: .dark)
//                hud.textLabel.text = "You are invited to the house"
//                hud.show(in: self.view)
//                hud.dismiss(afterDelay: 4)
//            }
//
//        }

    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
        self.bottomControls.cosmosView.rating = 0
    }
    
    fileprivate func performSwipeAnimation() {
        let translationAnimation = CABasicAnimation(keyPath: "position.y")
        translationAnimation.toValue = -1700
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        
        let cardView = self.topCardView
        self.topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock({
            cardView?.removeFromSuperview()
            self.bottomControls.cosmosView.rating = 0
        })
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        
        CATransaction.commit()
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


    }
    

}
        

    



