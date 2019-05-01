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

        view.backgroundColor = #colorLiteral(red: 0.9322652284, green: 0.9322652284, blue: 0.9322652284, alpha: 1)
        navigationItem.title = "Send Chat Request"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchGifts()
        getBalance()
        setupLayout()
        setupNotificationObservers()
    }
    
    let titleLabel = UILabel(text: "Choose a Gift", font: .systemFont(ofSize: 28, weight: .bold))
    let giftsCellId = "giftsCellId"
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    let balanceLabel = UILabel(text: "Your balance: \n ..Jo", font: .systemFont(ofSize: 14))
    let topupButton = UIButton(title: "Top up", cornerRadius: 20, font: .systemFont(ofSize: 14, weight: .medium))
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
    let descriptionLabel = UILabel(text: "It requires a gift to send chat request.", font: .systemFont(ofSize: 14))
    let warningLabel = UILabel(text: "(Not enough)", font: .systemFont(ofSize: 14, weight: .regular))

    
    fileprivate func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
//        titleLabel.textColor = .lightGray
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        balanceLabel.numberOfLines = 0
        view.addSubview(warningLabel)
        warningLabel.anchor(top: nil, leading: balanceLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        warningLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: balanceLabel.centerYAnchor, multiplier: 1).isActive = true
        warningLabel.isHidden = true
        warningLabel.textColor = .orange
        view.addSubview(topupButton)
        topupButton.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 100, height: 40))
        topupButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor).isActive = true
        topupButton.backgroundColor = .white

//        topupButton.setTitleColor(.black, for: .normal)
        topupButton.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
        
        view.addSubview(separatorView)
        separatorView.anchor(top: balanceLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width, height: 1))
        separatorView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: giftsCellId)
        let width = (view.frame.width - 2) / 3
        collectionView.heightAnchor.constraint(equalToConstant: width * 2 + 4).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        
        view.addSubview(inputTextView)
        inputTextView.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width , height: 100))
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: inputTextView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 16))
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(payButton)
        payButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: view.frame.width - 32, height: 50))
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 8
        payButton.addTarget(self, action: #selector(handleSendChatRequest), for: .touchUpInside)
        payButton.isEnabled = false
        payButton.backgroundColor = #colorLiteral(red: 0, green: 0.7662263513, blue: 0.9543122649, alpha: 1)

    }
    
    var digitalGoods = [DigitalGood]()
    fileprivate func fetchGifts() {
        Firestore.firestore().collection("drinkTypes").order(by: "price", descending: false)
            .getDocuments(){ (querySnapshot, err) in
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return digitalGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: giftsCellId, for: indexPath) as! GiftCell
        cell.digitalGood = digitalGoods[indexPath.item]
        
        if (self.selectedIndexPath != nil && indexPath == self.selectedIndexPath) {
            cell.backgroundColor = #colorLiteral(red: 0.9632236362, green: 0.8585800529, blue: 0.8492385745, alpha: 0.5)
        } else {
                cell.backgroundColor = .clear
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 3
        return CGSize(width: width, height: width + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    var selectedIndexPath: IndexPath?
    var giftPrice: Int?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9632236362, green: 0.8585800529, blue: 0.8492385745, alpha: 0.5)
        let digitalGood = self.digitalGoods[indexPath.item]
        self.digitalGood = digitalGood
        self.giftPrice = digitalGood.price
        self.payButton.setTitle("\(giftPrice ?? 8) Jo / Pay and Send", for: .normal)
        self.selectedIndexPath = indexPath
        
        self.checkIfBalanceEnough()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
        self.selectedIndexPath = nil
        collectionView.reloadData()
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleTopup() {
        let topupController = TopUpController()
        topupController.user = self.user
        navigationController?.pushViewController(topupController, animated: true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:1, initialSpringVelocity:1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification:Notification) {
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
        { return }
        let keyboardFrame = value.cgRectValue
        //the gap from register button to the keyboard
        let difference = keyboardFrame.height
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var digitalGood: DigitalGood?
    @objc fileprivate func handleSendChatRequest() {
        view.endEditing(true)
        handleKeyboardHide()
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Sending.."
        hud.show(in: self.view)
        
        if inputTextView.text != "" && digitalGood?.id != nil {
            self.functions.httpsCallable("sendConversationRequest").call(["uid": user?.uid ?? "", "text":inputTextView.text ?? "", "drinktypeid":digitalGood?.id ?? ""]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        _ = FunctionsErrorCode(rawValue: error.code)
                        _ = error.localizedDescription
                        _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                
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
    var userBalance: Int?
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
                self.userBalance = balance

            }
            
        }
        
    }
    
    fileprivate func checkIfBalanceEnough() {
        // Check balance
        if self.userBalance ?? 0 >= self.giftPrice ?? 0 {
            self.payButton.isEnabled = true
            self.payButton.backgroundColor = #colorLiteral(red: 0, green: 0.7662263513, blue: 0.9543122649, alpha: 1)
//            self.payButton.setTitleColor(.black, for: .normal)
            self.warningLabel.isHidden = true
        } else {
            self.payButton.isEnabled = false
            self.payButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5951947774)
            self.payButton.setTitleColor(.white, for: .normal)
            self.warningLabel.isHidden = false
        }
    }

}
