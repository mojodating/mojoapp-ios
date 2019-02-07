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
        
        setupBottomControl()
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
            self.rateSummaryLabel.text = "Your profile got a rating of \(userRate), beat 90% of users."
        }
    }
    
    fileprivate func setupBottomControl() {
        view.addSubview(priviousButton)
        priviousButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 48, bottom: 36, right: 0), size: .init(width: 40, height: 40))
        
        view.addSubview(pageControl)
        pageControl.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 36, right: 0))
        pageControl.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true
        
        view.addSubview(NextButton)
        NextButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 36, right: 48), size: .init(width: 40, height: 40))
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(mainTitleLabel)
        view.addSubview(rateSummaryLabel)
        view.addSubview(currentUserImageView)
        view.addSubview(mainButton)
        
        mainTitleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 48, right: 0))
        mainTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        rateSummaryLabel.anchor(top: currentUserImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        mainButton.anchor(top: rateSummaryLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
    }
    
    fileprivate func setupAnimations() {
        
        let angel = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angel).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        rateSummaryLabel.transform = CGAffineTransform(translationX: -500, y: 0)
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
            self.rateSummaryLabel.transform = .identity
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
    
    fileprivate let rateSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Your profile got a rating of"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
        button.setTitle("View your privilege", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    fileprivate let priviousButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    fileprivate let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return pc
    }()
    
    fileprivate let NextButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "left image").withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)
    }

}
