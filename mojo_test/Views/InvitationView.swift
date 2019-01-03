//
//  InvitationView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/20/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class InvitationView: UIView {
    
    var cardUID: String! {
        didSet {
            Firestore.firestore().collection("users").document(cardUID).getDocument { (snapshot, err) in
                if let err = err {
                    print("failed to fetch users:", err)
                    return
                }
                
                guard let dictionary = snapshot?.data() else { return }
                let user = User(dictionary: dictionary)
                guard let url = URL(string: user.imageUrl1 ?? "") else { return }
                self.currentUserImageView.sd_setAnimationImages(with: [url])
                
                
            }
        }
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
        label.text = "Your profile got a rating of 4.8 by 100 people in just 36 hrs."
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "peter"))
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
        return button
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        
        setupLayout()
        
        setupAnimations()
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
    
    fileprivate func setupLayout() {
        addSubview(invitationImageView)
        addSubview(descriptionLabel)
        addSubview(rateSummaryLabel)
        addSubview(currentUserImageView)
        addSubview(enjouHouseButton)
        
        invitationImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 316, height: 137))
        invitationImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 32, right: 48), size: .init(width: 0, height: 50))
        
        rateSummaryLabel.anchor(top: currentUserImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentUserImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        enjouHouseButton.anchor(top: rateSummaryLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView() {
        
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            
        }
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
