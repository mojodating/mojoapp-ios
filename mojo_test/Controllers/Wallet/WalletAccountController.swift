//
//  WalletAccountController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class WalletAccountController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Account"
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 48, left: 0, bottom: 0, right: 0))
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(userNameLabel)
        userNameLabel.anchor(top: nameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(qrcodeImageView)
        qrcodeImageView.anchor(top: userNameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: view.frame.width / 6 * 4))
        qrcodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(button1)
        button1.anchor(top: qrcodeImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: 44))
        button1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(button2)
        button2.anchor(top: button1.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: 44))
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(button3)
        button3.anchor(top: button2.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: 44))
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sussie Lee"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@sussie223"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    let qrcodeImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "qr"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let button1: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Copy wallet address", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    let button2: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View transaction history ", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    let button3: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View on etherscan", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        return btn
    }()


}
