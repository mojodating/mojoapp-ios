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
        
        view.backgroundColor = .white
        
        fetchCurrentUser()
        
        setupLayout()

        setupAnimations()
        
        navigationItem.title = "welcome to house"
    }
    
    
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
            guard let rateCount = self.user?.rateCount else { return }
            var rate = Double()
               rate = Double(userRate) / Double (rateCount)
            guard let name = self.user?.name else { return }
            let attributedString = NSMutableAttributedString(string: "\(name)\n\(rate)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.alignment = .center
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            self.userInfoLabel.attributedText = attributedString
        }
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(mainTitleLabel)
        view.addSubview(rewardLabel)
        view.addSubview(currentUserImageView)
        view.addSubview(userInfoLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(mainButton)
        
        mainTitleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 48, right: 0))
        mainTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: userInfoLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140 / 2
//        currentUserImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        userInfoLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        userInfoLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true
        userInfoLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1).isActive = true
        
        rewardLabel.anchor(top: userInfoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 48, left: 36, bottom: 0, right: 36))
        
        descriptionLabel.anchor(top: rewardLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 36, bottom: 0, right: 36))
        
        mainButton.anchor(top: descriptionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 48, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
    }
    
    fileprivate func setupAnimations() {
        
        let angel = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angel).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        rewardLabel.transform = CGAffineTransform(translationX: -500, y: 0)
        mainButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
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
            self.rewardLabel.transform = .identity
            self.mainButton.transform = .identity
        })
    }
    
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Congrats! You are invited to the exclusive Mojo house!🎉"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let rewardLabel: UILabel = {
        let label = UILabel()
        label.text = "We are rewarding you 100 Jo coin!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.9374479128, green: 0.9374479128, blue: 0.9374479128, alpha: 1)
        return imageView
    }()
    
    fileprivate let mainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check your free token", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "Now you are able to receive chat requests and gifts from other users. You can start talk to users you like and purchase gifts with the tokens we reward you. Happy mingle!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let userInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)

    }

}
