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
import SDWebImage

class UserDetailFeedbackController: UIViewController {
    
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
                if let url = URL(string: profileUrl) {
                    self.userProfileImageView.sd_setImage(with: url)
                }
                
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
        userProfileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 24, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: userProfileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        let buttonStackView: UIStackView = {
            let sv = UIStackView()
            
            [likeButton, mehButton, madButton].forEach{(button) in
                sv.addArrangedSubview(button)
            }
            
            sv.distribution = .equalSpacing
            
            return sv
        }()
        
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 48, bottom: 0, right: 48))
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        buttonStackView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1).isActive = true
        
        view.addSubview(reportButton)
        reportButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 72, right: 0))
    
    }
    
    let userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How’s your conversation with UserName?"
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    lazy var likeButton = createButton(image: #imageLiteral(resourceName: "image 3"), selector: #selector(handleRateUser))
    lazy var mehButton = createButton(image: #imageLiteral(resourceName: "image 4"), selector: #selector(handleRateUser))
    lazy var madButton = createButton(image: #imageLiteral(resourceName: "mad"), selector: #selector(handleRateUser))
    
    
    let hud = JGProgressHUD(style: .dark)
    lazy var functions = Functions.functions()
    @objc fileprivate func handleRateUser(button: UIButton) {
        var feedbackString = String()
        
        if button == likeButton {
            feedbackString = "like"
        } else if button == mehButton {
            feedbackString = "meh"
        } else {
            feedbackString = "mad"
        }
        
        guard let uid = self.user?.uid else { return }
        
        self.hud.textLabel.text = "Submitting.."
        self.hud.show(in: self.view)
        
        functions.httpsCallable("sendFeedback").call(["uid": uid, "feedback":feedbackString]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
            self.hud.textLabel.text = "Feedback submited"
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2)
            
            self.markHasFeedback()
        }
    }
    
    fileprivate func markHasFeedback() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let conversationId = conversation?.id else { return }
        
        Firestore.firestore().collection("users").document(uid).updateData([
            "conversations.\(conversationId).hasFeedback": true,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    self.dissmissController()
                }
        }
    }
    
    fileprivate func dissmissController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
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
