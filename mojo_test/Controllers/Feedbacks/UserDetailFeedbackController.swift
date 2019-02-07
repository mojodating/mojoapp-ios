//
//  UserDetailFeedbackController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/31/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class UserDetailFeedbackController: UIViewController {
    
    var toUid = String()
    
    var user : User?
    var conversation : Conversation? {
        didSet {
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            var chatProfileUID: String?
            
            if currentUser == conversation?.sender {
                chatProfileUID = conversation?.receiver
            } else {
                chatProfileUID = conversation?.sender
            }
            self.toUid = chatProfileUID ?? ""
            Firestore.firestore().collection("users").document(chatProfileUID!).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                guard let userName = self.user?.name else { return }
                
                self.titleLabel.text = "How’s your conversation with " + userName + "?"
                
                guard let profileUrl = self.user?.imageUrl1 else { return }
                self.userProfileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
                
                
                
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Submit Feedback"
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        view.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 24, bottom: 0, right: 0), size: .init(width: 56, height: 56))
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: userProfileImageView.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 24))
        titleLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 0, right: 24))
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        buttonStackView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1).isActive = true
        
        view.addSubview(labelStackView)
        labelStackView.anchor(top: buttonStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 12))
        labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(reportButton)
        reportButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 72, right: 0))
    
    }
    
    let userProfileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "default-profileUrl"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 28
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How’s your conversation with UserName?"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return button
    }
    
    static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }
    
    let labelStackView: UIStackView = {
        let sv = UIStackView()

        let likeButtonLabel  = createLabel(text: "Like")
        let loveButtonLabel  = createLabel(text: "Love")
        let dopeButtonLabel  = createLabel(text: "Super \nduper")
        let mehButtonLabel  = createLabel(text: "Meh")
        let fakeIdButtonLabel  = createLabel(text: "Fake \nidentity")
        let madButtonLabel  = createLabel(text: "Mad")
        

        [likeButtonLabel,loveButtonLabel, dopeButtonLabel, mehButtonLabel, fakeIdButtonLabel, madButtonLabel].forEach{(label) in
            sv.addArrangedSubview(label)
        }

        sv.distribution = .equalSpacing
        sv.alignment = .firstBaseline

        return sv
    }()
    
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        
        let likeButton = createButton(image: #imageLiteral(resourceName: "image 3"))
        let loveButton = createButton(image: #imageLiteral(resourceName: "image2"))
        let dopeButton = createButton(image: #imageLiteral(resourceName: "image 5"))
        let mehButton = createButton(image: #imageLiteral(resourceName: "image 4"))
        let fakeIdButton = createButton(image: #imageLiteral(resourceName: "image 6"))
        let madButton = createButton(image: #imageLiteral(resourceName: "image"))
        
        [likeButton,loveButton, dopeButton, mehButton, fakeIdButton, madButton].forEach{(button) in
           sv.addArrangedSubview(button)
        }
        
        likeButton.addTarget(self, action: #selector(handleFeedback), for: .touchUpInside)
        
        sv.distribution = .equalSpacing
        
        return sv
    }()
    
    @objc fileprivate func handleFeedback() {
        

        let feedback: [String: Any] = [
            "like" : 1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        Firestore.firestore().collection("feedbackRating").document(toUid).setData(feedback) {
            (err) in
            if let err = err {
                print("Failed to save user settings", err)
                return
            }
            print("submitted feedback")
            hud.textLabel.text = "feedback submitted"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2)
        }
    }
    
    
    let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "report").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Report this user", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()

    

}
