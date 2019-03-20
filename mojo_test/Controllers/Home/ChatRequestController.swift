//
//  ChatRequestController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class ChatRequestController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cardViewModel: CardViewModel!
    var user: User? {
        didSet {
            cardViewModel = user?.toCardViewModel()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.9639985156, green: 0.9639985156, blue: 0.9639985156, alpha: 1)
        navigationItem.title = "Send Chat Request"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchGifts()
        getBalance()
        setupLayout()
        
    }
    
    let titleLabel = UILabel(text: "Choose a Gift", font: .systemFont(ofSize: 24, weight: .heavy))
    let messageLabel = UILabel(text: "Add a Message", font: .systemFont(ofSize: 24, weight: .heavy))
    let giftsCellId = "giftsCellId"
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    let balanceLabel = UILabel(text: "Your balance: \n ..Jo", font: .systemFont(ofSize: 14))
    let topupButton = UIButton(title: "Top up", cornerRadius: 8, font: .systemFont(ofSize: 14))
    let separatorView = UIView()
    let payButton = UIButton(title: "Pay and Send", cornerRadius: 0, font: .systemFont(ofSize: 16, weight: .semibold))
    let inputTextView: ChatRequestInputTextView = {
        let textView = ChatRequestInputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 4
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return textView
    }()
    let descriptionLabel = UILabel(text: "You will find your chat request under Chat Tab", font: .systemFont(ofSize: 12))
    let warningLabel = UILabel(text: "(Not enough)", font: .systemFont(ofSize: 16, weight: .semibold))

    
    fileprivate func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        balanceLabel.numberOfLines = 0
        view.addSubview(warningLabel)
        warningLabel.anchor(top: nil, leading: balanceLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        warningLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: balanceLabel.centerYAnchor, multiplier: 1).isActive = true
        warningLabel.isHidden = true
        warningLabel.textColor = .orange
        view.addSubview(topupButton)
        topupButton.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 80, height: 32))
        topupButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor).isActive = true
        topupButton.backgroundColor = .orange
        topupButton.setTitleColor(.white, for: .normal)
        topupButton.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
        
        view.addSubview(separatorView)
        separatorView.anchor(top: balanceLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 1))
        separatorView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: giftsCellId)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(inputTextView)
        inputTextView.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width , height: 100))
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: inputTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(payButton)
        payButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: 50))
        payButton.setTitleColor(.white, for: .normal)
        payButton.addTarget(self, action: #selector(handleSendChatRequest), for: .touchUpInside)

    }

    
    var digitalGoods = [DigitalGood]()
    fileprivate func fetchGifts() {
        Firestore.firestore().collection("drinkTypes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let drinkType = document.data()
                    
                    let digitalGood = DigitalGood(drinkType: drinkType)
                    self.digitalGoods.append(digitalGood)
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return digitalGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: giftsCellId, for: indexPath) as! GiftCell
        cell.digitalGood = digitalGoods[indexPath.item]
        
        if indexPath.row == 0 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left) //Add this line
            cell.isSelected = true
            self.digitalGood = cell.digitalGood
            self.giftPrice = cell.digitalGood?.price
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    var giftPrice: Int?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9922668147, green: 0.9574156984, blue: 0.9535622223, alpha: 1)
        let digitalGood = self.digitalGoods[indexPath.row]
        self.digitalGood = digitalGood
        giftPrice = digitalGood.price
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleTopup() {
        let topupController = TopUpController()
        topupController.user = self.user
        navigationController?.pushViewController(topupController, animated: true)
    }
    
    var digitalGood: DigitalGood?
    @objc fileprivate func handleSendChatRequest() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Sending.."
        hud.show(in: self.view)
        
        if inputTextView.text != "" && digitalGood?.id != "" {
            self.functions.httpsCallable("sendConversationRequest").call(["uid": user?.uid, "text":inputTextView.text ?? "", "drinktypeid":digitalGood?.id ?? ""]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        _ = FunctionsErrorCode(rawValue: error.code)
                        _ = error.localizedDescription
                        _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                
                //            self.showAfterPurchasedController()
                hud.textLabel.text = "Sent"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2)
                self.dismiss(animated: true)
            }
        } else {
            hud.textLabel.text = "Please select a gift and leave a meesage"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 3)
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
                
                let attributedText = NSMutableAttributedString(string: "Your balance", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])
                attributedText.append(NSMutableAttributedString(string: "\n\(balance)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)]))
                attributedText.append(NSMutableAttributedString(string: " Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
                self.balanceLabel.attributedText = attributedText

//                 check balance
                if balance >= self.giftPrice ?? 0 {
                    self.payButton.isEnabled = true
                    self.payButton.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)
                } else {                
                    self.payButton.isEnabled = false
                    self.payButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//                    self.topupButton.isHidden = false
//                    self.topupButton.isEnabled = true
                    self.warningLabel.isHidden = false
                }
            }
            
        }
        
    }

}
