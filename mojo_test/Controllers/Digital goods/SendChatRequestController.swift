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
            
            giftImageView.loadImageUsingCacheWithUrlString(urlString: digitalGoodUrl)
            
            nameLabel.text = digitalGood?.name
            
            priceLabel.text = "\(digitalGood?.price ?? 0) Jo"
            
            descriptionLabel.text = digitalGood?.description
            
            drinkPrice = digitalGood?.price ?? 0
            
        }
    }

    
    var cardViewModel: CardViewModel! {
        didSet {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: cardViewModel.imageUrls.first ?? "")
            
            guard let userName = cardViewModel?.name else {return}
            
            infoLabel.text = "Say Hi to " + userName + "!"
        }
    }
    
    var user: User? {
        didSet {
            guard let profileUrl = user?.imageUrl1 else { return }
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
            guard let name = user?.name else { return }
            infoLabel.text = "Say Hi to " + name + "!"
            self.cardViewModel = user?.toCardViewModel()
        }
    }
    
    lazy var functions = Functions.functions()
    fileprivate func getBalance() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.functions.httpsCallable("getBalance").call(["uid": uid]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            if let balance = (result?.data as? [String: Any])?["balance"] as? Int {
                
                let attributedText = NSMutableAttributedString(string: "Your balance", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)])
                attributedText.append(NSMutableAttributedString(string: "\n\(balance)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]))
                attributedText.append(NSMutableAttributedString(string: " Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]))
                self.balanceLabel.attributedText = attributedText
                print("Balance is:", balance)
                // check balance
                if balance >= self.drinkPrice {
                    self.payButton.isEnabled = true
                    self.payButton.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)
                    
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
   
    @objc func handleSendChatRequest() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Sending your chat request..."
        hud.show(in: self.view)
        
        self.functions.httpsCallable("sendConversationRequest").call(["uid": cardViewModel.uid, "text":inputTextView.text ?? "", "drinktypeid":digitalGood?.id ?? ""]) { (result, error) in
            hud.dismiss()
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
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
        
        navigationItem.title = "Send Chat Request"
        
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
    
    
    let profileImageView = UIImageView(cornerRadius: 20)
    let infoLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 18))
    let balanceLabel = UILabel(text: "", font: .systemFont(ofSize: 18))
    let warningLabel = UILabel(text: "(Not enough)", font: .systemFont(ofSize: 16, weight: .semibold))
    
    let giftImageView = UIImageView(cornerRadius: 0)
    let nameLabel = UILabel(text: "DRINK ONE", font: .systemFont(ofSize: 24, weight: .bold))
    let priceLabel = UILabel(text: ".. Jo", font: .systemFont(ofSize: 18, weight: .medium))
    let descriptionLabel = UILabel(text: "Description", font: .systemFont(ofSize: 16))
    
    let inputTextView: ChatRequestInputTextView = {
        let textView = ChatRequestInputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 4
        textView.backgroundColor = #colorLiteral(red: 0.9518757931, green: 0.9518757931, blue: 0.9518757931, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return textView
    }()
  
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay and send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        button.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    @objc fileprivate func handleTopup() {
        let topupController = TopUpController()
        topupController.user = self.user
        navigationController?.pushViewController(topupController, animated: true)
    }

    
    fileprivate func setupLayout() {        
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 40, height: 40))

        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        infoLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: profileImageView.centerYAnchor, multiplier: 1).isActive = true

        view.addSubview(inputTextView)
        inputTextView.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: view.frame.width, height: 100))

        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: inputTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0))
        balanceLabel.numberOfLines = 0

        view.addSubview(topupButton)
        topupButton.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 93, height: 32))
        topupButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor).isActive = true

        view.addSubview(warningLabel)
        warningLabel.anchor(top: nil, leading: balanceLabel.trailingAnchor, bottom: balanceLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0))
        warningLabel.textColor = .orange
        warningLabel.isHidden = true

        view.addSubview(payButton)
        payButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 50))

        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: payButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 16, right: 24))

        view.addSubview(priceLabel)
        priceLabel.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 24))

        view.addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 8, right: 0))

        view.addSubview(giftImageView)
        giftImageView.anchor(top: nil, leading: view.leadingAnchor, bottom: nameLabel.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 8, right: 24), size: .init(width: view.frame.width, height: view.frame.height / 3))
        
    }
    


}
