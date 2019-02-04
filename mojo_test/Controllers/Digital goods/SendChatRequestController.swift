//
//  ViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/9/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SendChatRequestController: UIViewController {
    
    var drinkPrice:Int = 0
    
    var digitalGood: DigitalGood? {
        didSet {

            guard let digitalGoodUrl = digitalGood?.imageUrl else { return }
            
            drinkImageView.loadImageUsingCacheWithUrlString(urlString: digitalGoodUrl)
            
            nameLabel.text = digitalGood?.name
            
            priceLabel.text = "MOJO \(digitalGood?.price ?? 0)"
            
            descriptionLabel.text = digitalGood?.description
            
            drinkPrice = digitalGood?.price ?? 0
            
        }
    }

    lazy var functions = Functions.functions()
    
    var cardViewModel: CardViewModel! {
        didSet {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: cardViewModel.imageUrls.first ?? "")
            
            guard let userName = cardViewModel?.name else {return}
            
            userNameLabel.text = userName
            infoLabel.text = "Say Hi to " + userName + "!"
 
        }
    }
    
    var user: User?
    
    fileprivate func getBalance() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            //          fetch our user here
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
        
        self.functions.httpsCallable("getBalance").call(["uid": self.user?.uid]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            if let balance = (result?.data as? [String: Any])?["balance"] as? Int {
                
                let attributedText = NSMutableAttributedString(string: "Your balance", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)])
                attributedText.append(NSMutableAttributedString(string: "\n\(balance)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]))
                attributedText.append(NSMutableAttributedString(string: " Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]))
                self.balanceLabel.attributedText = attributedText
                
                print(balance)
                
                // check balance
                if balance >= self.drinkPrice {
                    self.payButton.isEnabled = true
                    self.payButton.backgroundColor = #colorLiteral(red: 1, green: 0.3040125447, blue: 0.4915377174, alpha: 1)
                    
                } else {
                    
                    self.payButton.isEnabled = false
                    self.payButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    self.topupButton.isHidden = false
                    self.topupButton.isEnabled = true
                    self.warningLabel.isHidden = false
                }
                    
                }
            }
            
        }
        
    }


    
    @objc func handleSendChatRequest() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Sending your chat request..."
        hud.show(in: self.view)
        self.functions.httpsCallable("sendConversationRequest").call(["uid": cardViewModel.uid, "text":inputTextView.text ?? "", "drinktypeid":digitalGood?.id ?? ""]) { (result, error) in
            hud.dismiss()
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            
            self.showAfterPurchasedController()

        }
        
    }
    
    fileprivate func showAfterPurchasedController() {
        let controller = AfterPurchaseController()
        controller.cardViewModel = self.cardViewModel
//        self.present(controller, animated: true)
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Send Chat request"
        
        setupLayout()
        
        getBalance()
        
        setupTapGesture()
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "peter")
        imageView.layer.cornerRadius = 20
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
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Say Hi to UserName!"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let inputTextView: MarketPlaceInputTextView = {
        let textView = MarketPlaceInputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        textView.layer.cornerRadius = 4
        textView.backgroundColor = #colorLiteral(red: 0.9518757931, green: 0.9518757931, blue: 0.9518757931, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return textView
    }()
  
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("10 Jo - pay and send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSendChatRequest), for: .touchUpInside)
        return button
    }()

    
    let topupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Top up", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "(Not enough)"
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    
    fileprivate func setupLayout() {        
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        view.addSubview(userNameLabel)
        userNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        view.addSubview(infoLabel)
        infoLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
        view.addSubview(inputTextView)
        inputTextView.anchor(top: infoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: view.frame.width, height: 100))

        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: inputTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0))
        
        view.addSubview(topupButton)
        topupButton.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 93, height: 32))
        topupButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor).isActive = true
        
        view.addSubview(warningLabel)
        warningLabel.anchor(top: nil, leading: balanceLabel.trailingAnchor, bottom: balanceLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0))
        
        view.addSubview(payButton)
        payButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 50))
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: payButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 16, right: 24))
        
        view.addSubview(priceLabel)
        priceLabel.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 24))
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 8, right: 0))
        
        view.addSubview(drinkImageView)
        drinkImageView.anchor(top: nil, leading: view.leadingAnchor, bottom: nameLabel.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 8, right: 24), size: .init(width: view.frame.width, height: 240))

    }

    let drinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "DRINK ONE"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        //        label.text = "10 MOJO"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
        
    }()
    

}
