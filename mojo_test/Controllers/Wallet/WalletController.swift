//
//  WalletController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/21/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class WalletController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        fetchCurrentUser()
        
        setupNavigationBar()
        
        setupLayout()
        
        setupCollectionViewLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: cellId)
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
//            self.usernameLabel.text = self.user?.name
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
    
    fileprivate func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.anchor(top: giftsTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        view.addSubview(lineView)
        lineView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GiftCell
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Wallet"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transactions", style: .plain, target: self, action: #selector(handleTransaction))
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Account", style: .plain, target: self, action: #selector(handleAccount))
    }
    
    fileprivate func setupLayout() {
        view.addSubview(currentUserImageView)
//        view.addSubview(usernameLabel)
        view.addSubview(accountButton)
        view.addSubview(balanceLabel)
        view.addSubview(userBalanceLabel)
        view.addSubview(dollarBalanceLabel)
        view.addSubview(buttonStackView)
        view.addSubview(giftsTitleLabel)
        
        // user layout
        
        currentUserImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 48, height: 48))
        currentUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
//        usernameLabel.anchor(top: currentUserImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
//
//        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        accountButton.anchor(top: currentUserImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size:  .init(width: 180, height: 32))
        
        accountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // balance layout
        
        balanceLabel.anchor(top: accountButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 24, left: 0, bottom: 0, right: 0))
        balanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        userBalanceLabel.anchor(top: balanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        userBalanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        dollarBalanceLabel.anchor(top: userBalanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        dollarBalanceLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
        
        buttonStackView.anchor(top: dollarBalanceLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24), size: .init(width: view.frame.width, height: 50))
        
       giftsTitleLabel.anchor(top: buttonStackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0))
        giftsTitleLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1).isActive = true
    }
    
    
    let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.textColor = .darkGray
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
    
    let accountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Wallet account", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(handleAccount), for: .touchUpInside)
        return button
    }()
    
    
    @objc fileprivate func handleAccount() {
        let controller = WalletAccountController()
        controller.user = user
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
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        
       let topUpButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Top up", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.8235294118, blue: 0.6235294118, alpha: 1)
            button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
            return button
        }()

       let sendButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Send", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
            button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 4
            return button
        }()
        
        sv.addArrangedSubview(topUpButton)
        sv.addArrangedSubview(sendButton)
        sv.addArrangedSubview(cashOutButton)
        
        topUpButton.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 3/10).isActive = true
        sendButton.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 3/10).isActive = true
        cashOutButton.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 3/10).isActive = true
        
        sv.distribution = .equalSpacing
        
        return sv
    }()
    
    fileprivate let giftsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "GIFTS"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    @objc fileprivate func handleTopup() {
        let controller = TopUpController()
        //        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    

}
