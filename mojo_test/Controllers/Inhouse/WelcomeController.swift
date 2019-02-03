//
//  WelcomeController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/5/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class WelcomeController: UIViewController {
    
    var user: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        fetchCurrentUser()
        
        setupLayout()
//        setupBlurView()
        setupAnimations()
    }
    
//    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//
//    fileprivate func setupBlurView() {
//
////        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
//        view.addSubview(visualEffectView)
//        view.sendSubviewToBack(visualEffectView)
//        visualEffectView.fillSuperview()
//        visualEffectView.alpha = 0
//
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.visualEffectView.alpha = 1
//        }) { (_) in
//
//        }
//    }
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            //          fetch our user here
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            
            guard let profileImageUrl = self.user?.imageUrl1 else { return }
            
            self.currentUserImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
            guard let userRate = self.user?.rate else { return }
            self.rateSummaryLabel.text = "Your profile got a rating of \(userRate)"
        }
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(invitationImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(rateSummaryLabel)
        view.addSubview(currentUserImageView)
        view.addSubview(enjouHouseButton)
        
        invitationImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 316, height: 137))
        invitationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 32, right: 48), size: .init(width: 0, height: 50))
        
        rateSummaryLabel.anchor(top: currentUserImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        enjouHouseButton.anchor(top: rateSummaryLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
    }
    
    fileprivate func setupAnimations() {
        
        let angel = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angel).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        rateSummaryLabel.transform = CGAffineTransform(translationX: -500, y: 0)
        enjouHouseButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            //animation 1 - translation back to position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45, animations: {
                self.currentUserImageView.transform = CGAffineTransform (rotationAngle: -angel)
            })
            
            //animation 2 - rotation
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
            })
            
        }) { (_) in
            
        }
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.rateSummaryLabel.transform = .identity
            self.enjouHouseButton.transform = .identity
        })
    }
    
    
    fileprivate let invitationImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "invitation"))
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Now you can chat with people in the house, receive and send cryptocurrencies when making friends!"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let rateSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Your profile got a rating of"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.337254902, blue: 0.7529411765, alpha: 1)
        return imageView
    }()
    
    fileprivate let enjouHouseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enjoy the House", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.337254902, blue: 0.7529411765, alpha: 1)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)
    }

}
