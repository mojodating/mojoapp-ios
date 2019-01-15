//
//  WalletController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/21/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class WalletController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        fetchCurrentUser()
        
        setupNavigationBar()
        
        setupLayout()
    }
    
    var user: User?
    lazy var functions = Functions.functions()

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

            //fetch user name
            self.usernameLabel.text = self.user?.name
            guard let profileImageUrl = self.user?.imageUrl1 else { return }
            
            self.currentUserImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
            self.functions.httpsCallable("getBalance").call(["uid": self.user?.uid]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                            if let balance = (result?.data as? [String: Any])?["balance"] as? Int {
                                self.userBalanceLabel.text = "\(balance) Mojo Coin"
                                print(balance)
                            }
            }
        }
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
    
    fileprivate func setupLayout() {
        view.addSubview(currentUserImageView)
        view.addSubview(usernameLabel)
        view.addSubview(balanceLabel)
        view.addSubview(userBalanceLabel)
        view.addSubview(dollarBalanceLabel)
        view.addSubview(topUpButton)
        view.addSubview(sendButton)
        view.addSubview(cashOutButton)
        
        currentUserImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 48, left: 0, bottom: 8, right: 0), size: .init(width: 68, height: 68))
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        usernameLabel.anchor(top: currentUserImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        balanceLabel.anchor(top: nil, leading: nil, bottom: userBalanceLabel.topAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        balanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        userBalanceLabel.anchor(top: nil, leading: nil, bottom: dollarBalanceLabel.topAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        userBalanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        dollarBalanceLabel.anchor(top: nil, leading: nil, bottom: topUpButton.topAnchor, trailing: nil,padding: .init(top: 8, left: 0, bottom: 16, right: 0))
        dollarBalanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        topUpButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0), size: .init(width: 273, height: 50))
        
        sendButton.anchor(top: topUpButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 273, height: 50))
        
        cashOutButton.anchor(top: sendButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 48, bottom: 0, right: 48), size: .init(width: 273, height: 50))
        topUpButton.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        topUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        cashOutButton.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
    }
    
    //Setup stackView Layout
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 34
        return imageView
    }()
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
        
    fileprivate let balanceLabel: UILabel = {
            let label = UILabel()
            label.text = "Balance"
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
    fileprivate let userBalanceLabel: UILabel = {
            let label = UILabel()
            label.text = "0 Mojo Coin"
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            return label
        }()
        
       fileprivate let dollarBalanceLabel: UILabel = {
            let label = UILabel()
            label.text = "$0.00"
            label.textAlignment = .center
            label.textColor = .darkGray
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        
       fileprivate let topUpButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Top up", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
            return button
        }()
    
    @objc fileprivate func handleTopup() {
        let controller = TopUpController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
        
       fileprivate let sendButton: UIButton = {
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
        
       fileprivate let cashOutButton: UIButton = {
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
    

}
