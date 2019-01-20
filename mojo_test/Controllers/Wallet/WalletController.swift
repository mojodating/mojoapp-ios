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
    
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Wallet"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transactions", style: .plain, target: self, action: #selector(handleTransaction))
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Account", style: .plain, target: self, action: #selector(handleAccount))
    }
    
    fileprivate func setupLayout() {
        view.addSubview(currentUserImageView)
        view.addSubview(usernameLabel)
        view.addSubview(accountButton)
        view.addSubview(balanceLabel)
        view.addSubview(userBalanceLabel)
        view.addSubview(dollarBalanceLabel)
        view.addSubview(topUpButton)
        view.addSubview(sendButton)
        view.addSubview(cashOutButton)
        
        // user layout
        
        currentUserImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0), size: .init(width: 48, height: 48))
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        usernameLabel.anchor(top: currentUserImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        accountButton.anchor(top: usernameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        accountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // balance layout
        
        balanceLabel.anchor(top: accountButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 64, left: 0, bottom: 0, right: 0))
        balanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        userBalanceLabel.anchor(top: balanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        userBalanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        dollarBalanceLabel.anchor(top: userBalanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        dollarBalanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        topUpButton.anchor(top: dollarBalanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 4 * 3, height: 50))
        
        sendButton.anchor(top: topUpButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 4 * 3, height: 50))
        
        cashOutButton.anchor(top: sendButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 4 * 3, height: 50))
        
        sendButton.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        topUpButton.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        cashOutButton.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
    
    }
    
    
    let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let accountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Account", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(#colorLiteral(red: 0.8765097099, green: 0.3622604107, blue: 0.9166203997, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleAccount), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleAccount() {
        let controller = WalletAccountController()
//        let navController = UINavigationController(rootViewController: controller)
        navigationController?.pushViewController(controller, animated: true)
    }
        
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
            button.backgroundColor = #colorLiteral(red: 1, green: 0.7380045896, blue: 0.1112664202, alpha: 1)
            button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
            return button
        }()

    
    @objc fileprivate func handleTopup() {
        let controller = TopUpController()
//        controller.user = user
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
