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

class CardSwipingController: UIViewController, CardViewDelegate, editProfileControllerDelegate {
   
    let cardsDeckView = UIView()
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        setupLayout()
        
        handleRating()
        
        fetchCurrentUser()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(cardsDeckView)
        view.addSubview(cosmosView)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        cosmosView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 0))

    }
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.filledImage = #imageLiteral(resourceName: "filled-star").withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = #imageLiteral(resourceName: "empty-star").withRenderingMode(.alwaysOriginal)
        view.settings.starSize = 40
        view.settings.starMargin = 4
        view.settings.fillMode = .full
        view.rating = 0
        return view
    }()
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
    func fetchCurrentUser() {
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
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge ?? EditProfileController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? EditProfileController.defaultMaxSeekingAge
  
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
        cosmosView.didFinishTouchingCosmos = { rating in
            
            guard let cardUID = self.topCardView?.cardViewModel.uid else { return }
      
            self.functions.httpsCallable("rate").call(["uid": cardUID, "rate": rating]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        _ = FunctionsErrorCode(rawValue: error.code)
                        _ = error.localizedDescription
                        _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
            }
  
            self.performSwipeAnimation()
        }
    }
    
    func didRemoveCard(cardView: CardView) {
            
            self.topCardView?.removeFromSuperview()
            self.topCardView = self.topCardView?.nextCardView
            self.cosmosView.rating = 0
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
            self.cosmosView.rating = 0
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
    
    func didSaveProfile() {
        fetchCurrentUser()
    }
    
}
    



