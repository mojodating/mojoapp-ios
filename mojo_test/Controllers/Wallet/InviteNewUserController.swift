//
//  InviteNewUserController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/26/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class InviteNewUserController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var user: User? {
        didSet {
            guard let invitationCode = self.user?.invitationCode else { return }
            self.codeLabel.text = "Your code: \(invitationCode)"
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Invite Friends"
        
//        fetchCurrentUser()
        setupLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
  
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(inviteFriendsLabel)
        inviteFriendsLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 36, bottom: 0, right: 36))
        inviteFriendsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(invitationButton)
        invitationButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 36, bottom: 48, right: 36), size: .init(width: view.frame.width - 72, height: 56))
        invitationButton.backgroundColor = .black
        invitationButton.setTitleColor(.white, for: .normal)
        invitationButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        view.addSubview(codeLabel)
        codeLabel.anchor(top: nil, leading: nil, bottom: invitationButton.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 24, right: 0))
        codeLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true
    }
    
    @objc fileprivate func handleSendMessage() {
        if MFMessageComposeViewController.canSendText() {
            
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = [""]
            composeVC.body = "I've been using Mojo and think you'd really like it too! A new social app built on ethereum blockchain. If you sign up with my code, \(user?.invitationCode ?? ""), we'll both get 10 free Jo tokens. You can download the app here: ..."
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        } else {
            print("SMS services are not available")
        }
    }
    
    let codeLabel = UILabel(text: "Your code: ", font: .systemFont(ofSize: 18, weight: .bold))
    
    let inviteFriendsLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Get Free 10 Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .medium)])
        attributedString.append(NSMutableAttributedString(string: "\nWant more mojo? Every friend you get to join is worth 10 tokens, for both of you. Hit your peeps up!.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let invitationButton = UIButton(title: "Send Text", cornerRadius: 4, font: .systemFont(ofSize: 18))
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
