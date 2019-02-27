//
//  ChatRequestController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/11/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class MarketPlaceController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
 
                    self.menuCollectionView.reloadData()
                }
            }
        }
    }
    
    var cardViewModel: CardViewModel! {
        didSet{
            profileImageView.loadImageUsingCacheWithUrlString(urlString: cardViewModel.imageUrls.first ?? "")
            infoLabel.text = "Say Hi To " + cardViewModel.name
        }
    }
    
    var user: User? {
        didSet {
            guard let profileUrl = user?.imageUrl1 else { return }
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
            guard let name = user?.name else { return }
            let attributedString = NSMutableAttributedString(string: "Choose a gift for \n\(name)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            infoLabel.attributedText = attributedString
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
                    self.balanceLabel.text = "Your Balance: \(balance) Jo"
                    print(balance)
                }
            }
    }
    
    // Set up collectionView
    
    let menuCollectionView: UICollectionView = {
        let layout = snappingLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
//        cv.isPagingEnabled = true
        return cv
    }()
//    let menuCollectionView = HorizentalSnappingView()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9218030841, green: 0.9218030841, blue: 0.9218030841, alpha: 1)
        
        navigationItem.title = "Send Chat Request"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        getBalance()
        
        setupLayout()
        
        fetchGifts()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    let profileImageView = UIImageView(cornerRadius: 50)
    let infoLabel = UILabel()
    let giftShopLabel = UILabel(text: "GIFT SHOP", font: .systemFont(ofSize: 16, weight: .semibold))
    let balanceLabel = UILabel(text: "Your Balance: ..", font: .systemFont(ofSize: 16, weight: .regular))
    
    fileprivate func setupLayout() {
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        profileImageView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9333333333, blue: 0.5058823529, alpha: 1)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: profileImageView.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 16))
        infoLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: profileImageView.centerYAnchor, multiplier: 1).isActive = true
        infoLabel.numberOfLines = 0
        
        view.addSubview(giftShopLabel)
        giftShopLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 36, left: 24, bottom: 0, right: 0))
        
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 36, left: 0, bottom: 0, right: 24))
        
        // set up collectionView
        view.addSubview(menuCollectionView)
        menuCollectionView.anchor(top: giftShopLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return digitalGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell

        cell.digitalGood = digitalGoods[indexPath.item]
        cell.backgroundColor = .white
        
        return cell
    }
    
    let leftRightPadding: CGFloat = 12
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 48, height: menuCollectionView.frame.height - leftRightPadding * 2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return leftRightPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: leftRightPadding, bottom: 0, right: leftRightPadding)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let digitalGood = self.digitalGoods[indexPath.row]
        let controller = SendChatRequestController()
        controller.user = self.user
        controller.digitalGood = digitalGood
        navigationController?.pushViewController(controller, animated: true)
    }

}


