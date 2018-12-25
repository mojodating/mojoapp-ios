//
//  WalletController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/21/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class WalletController: UIViewController {
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "peter"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 34
        return imageView
    }()
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@sussie12"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    fileprivate let BalanceStackView: UIStackView = {
        let stackView = UIStackView()
        
        let balanceLabel: UILabel = {
            let label = UILabel()
            label.text = "Balance"
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        let userBalanceLabel: UILabel = {
            let label = UILabel()
            label.text = "10 Mojo Coin"
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            return label
        }()
        
        let dollarBalanceLabel: UILabel = {
            let label = UILabel()
            label.text = "$10.00"
            label.textAlignment = .center
            label.textColor = .darkGray
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        
        let topUpButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Top up", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            button.layer.cornerRadius = 4
            return button
        }()
        
        let sendButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Send", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 4
            return button
        }()
        
        let cashOutButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Cash out", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 4
            return button
        }()
        
        stackView.addArrangedSubview(balanceLabel)
        stackView.addArrangedSubview(userBalanceLabel)
        stackView.addArrangedSubview(dollarBalanceLabel)
        stackView.addArrangedSubview(topUpButton)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(cashOutButton)
        
        topUpButton.widthAnchor.constraint(equalToConstant: 273).isActive = true
        topUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.widthAnchor.constraint(equalToConstant: 273).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cashOutButton.widthAnchor.constraint(equalToConstant: 273).isActive = true
        cashOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNavigationBar()
        
        view.addSubview(currentUserImageView)
        view.addSubview(usernameLabel)
        view.addSubview(BalanceStackView)
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: usernameLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 68, height: 68))
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        usernameLabel.anchor(top: nil, leading: nil, bottom: BalanceStackView.topAnchor, trailing: nil, padding: .init(top: 16, left: 0, bottom: 48, right: 0))
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        BalanceStackView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 268))
        BalanceStackView.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        BalanceStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    @objc fileprivate func handleTransaction() {
        
    }
    
    @objc fileprivate func handleAccount() {
        
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Wallet"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transactions", style: .plain, target: self, action: #selector(handleTransaction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Account", style: .plain, target: self, action: #selector(handleAccount))
    }
    
}
