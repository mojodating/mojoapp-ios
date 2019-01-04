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
    var cardViewModels = [CardViewModel]()
    let bottomControls = HomeBottomControlStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.addSubview(cardsDeckView)
        view.addSubview(bottomControls)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        bottomControls.frame = .init(x: view.frame.size.width - 184, y:view.frame.size.height - 403 , width: 184, height: 212)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        handleRating()
        
        view.sendSubviewToBack(cardsDeckView)

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
            
//            self.fetchSwipes()
            
            self.fetchUsersFromFirestore()
        }
    }
    
//    var rates = [String: Int]()
//
//    fileprivate func fetchSwipes() {
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        Firestore.firestore().collection("bouncingLineRating").document(uid).getDocument { (snapshot, err) in
//            if let err = err {
//                print ("failed to fetch swipes for currently logged in user:", err)
//                return
//            }
//
//            print("Rates:", snapshot?.data() ?? "")
//            guard let data = snapshot?.data() as? [String: Int] else { return }
//            self.rates = data
//            self.fetchUsersFromFirestore()
//        }
//    }
//
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
  
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil

        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print( "fail to fetch users", err)
                return
            }
            
            //set up the nextCard relationship with the card
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
//                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipedBefore = self.rates[user.uid!] == nil
//                if isNotCurrentUser && hasNotSwipedBefore {
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
    
    lazy var functions = Functions.functions()
    
    fileprivate func handleRating() {
        bottomControls.cosmosView.didFinishTouchingCosmos = { rating in
//            print("Rated: \(rating)")
            
            guard let cardUID = self.topCardView?.cardViewModel.uid else { return }
            
//            self.presentInvitationView(cardUID: cardUID)
            
            self.functions.httpsCallable("rate").call(["uid": cardUID, "rate": rating]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
            }
  
            self.performSwipeAnimation()
        }
    }
    
    fileprivate func presentInvitationView(cardUID:String) {
        let invitationView = InvitationView()
        invitationView.cardUID = cardUID
        view.addSubview(invitationView)
        invitationView.fillSuperview()
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
    
    func handleChatRequest(cardViewModel: CardViewModel) {
        let controller = ChatRequestController()
        controller.cardViewModel = cardViewModel
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true)
    }
    
}
    



