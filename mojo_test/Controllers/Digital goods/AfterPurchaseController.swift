//
//  AfterPurchaseController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/16/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class AfterPurchaseController: UIViewController {
    
    var cardViewModel: CardViewModel! {
        didSet {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: cardViewModel.imageUrls.first ?? "")
            
            guard let userName = cardViewModel?.name else {return}
            userNameLabel.text = userName
            
            titleLabel.text = "Chat request to " + userName + " successfully delivered!"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 24, bottom: 0, right: 0), size: .init(width: 48, height: 48))
        view.addSubview(userNameLabel)
        userNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 48, left: 24, bottom: 0, right: 24))
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24))
//        view.addSubview(twoButton)
//        twoButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 36, bottom: 36, right: 36), size: .init(width: view.frame.width, height: 56))
        
        view.addSubview(oneButton)
        oneButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 36, bottom: 36, right: 36), size: .init(width: view.frame.width, height: 56))
    
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "peter")
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@username"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat requests to successfully delivered!"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let oneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Keep swiping", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleBackHome), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBackHome() {
        
        self.dismiss(animated: true)
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You can check your chat request under 'Chat > Chat Request' tab."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
//    let twoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("See your chat request", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .white
//        button.layer.cornerRadius = 18
//        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        button.layer.borderWidth = 2
//        button.addTarget(self, action: #selector(handleToChat), for: .touchUpInside)
//        return button
//    }()
//
//    @objc func handleToChat() {
//
//    }
    
    

}
