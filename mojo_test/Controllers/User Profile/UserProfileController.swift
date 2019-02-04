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

class UserProfileController: UIViewController {
 
    var user: User?
    func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }

            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            
            guard let profileImageUrl = self.user?.imageUrl1 else { return }
            self.navProfileView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
            self.setupCardFromUser(user:self.user!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTransparentNavBar()
        
        fetchCurrentUser()
        
        setupCircularNavButton()
        
        setupMenuController()
        
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        view.addSubview(cardView)
        cardView.fillSuperview()
        cardView.chatRequestButton.isHidden = true
        cardView.userProfileView.isHidden = true
        cardView.gestureRecognizers?.forEach(cardView.removeGestureRecognizer)
    }
    
    
    let menuController = SlidingMenuController()
    
    fileprivate let menuWidth: CGFloat = 300
    
    fileprivate func performAnimations(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.menuController.view.transform = transform
            self.navigationController?.view.transform = transform
//            self.view.transform = transform
        })
    }
    
    @objc func handleOpenMenu() {
        
        if menuController.view.frame == CGRect(x: -menuWidth, y: 0, width: 300, height: self.view.frame.height) {
            // handle open
            performAnimations(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
        } else {
            // handle close
            performAnimations(transform: .identity)
        }
    }
    
    fileprivate func setupMenuController() {
        //initial position
        menuController.view.frame = CGRect(x: -menuWidth, y: 0, width: 300, height: self.view.frame.height)
        
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(menuController.view)
        addChild(menuController)
    }
    
    fileprivate func setupTransparentNavBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .white
    }
    
    // Set up navProfileButton
    
    fileprivate let navProfileView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "default-profileUrl"))
        iv.backgroundColor = #colorLiteral(red: 0.9565825892, green: 0.9565825892, blue: 0.9565825892, alpha: 1)
        iv.width(40)
        iv.height(40)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.layer.borderWidth = 2
        iv.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    fileprivate func setupCircularNavButton() {
        
        addTargetToNavProfileImage()
        
        let barButtonItem = UIBarButtonItem(customView: navProfileView)
        barButtonItem.action = #selector(handleOpenMenu)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    fileprivate func addTargetToNavProfileImage() {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOpenMenu))
        singleTap.numberOfTapsRequired = 1;
        navProfileView.addGestureRecognizer(singleTap)
    }
 
    
}
