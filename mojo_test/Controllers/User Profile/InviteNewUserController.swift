//
//  InviteNewUserController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/26/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class InviteNewUserController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Invite Friends"
        
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
        inviteFriendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inviteFriendsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(inviteFriendsButton)
        inviteFriendsButton.anchor(top: inviteFriendsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 36, left: 36, bottom: 0, right: 36), size: .init(width: view.frame.width, height: 56))
        
        
        
    }
    
    let inviteFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Earn 10 mojo tokens for each friend you invited on the platform. The more friends that join, the more token you all will get."
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let inviteFriendsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite friends", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor =  #colorLiteral(red: 0.2274509804, green: 0.8235294118, blue: 0.6235294118, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    

    

}
