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
    fileprivate func loadData() {
         Firestore.firestore().collection("drinkTypes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    let drinkType = document.data()
//                    drinkType.forEach({ (key, value) in
                    
                        let digitalGood = DigitalGood(drinkType: drinkType)
                        self.digitalGoods.append(digitalGood)
 
                    self.menuCollectionView.reloadData()
                }
            }
        }
    }
    
    var cardViewModel: CardViewModel! {
        didSet{
//                userNameLabel.attributedText = cardViewModel.attributedString
            
            guard let toUID = cardViewModel?.uid else { return }
            
            Firestore.firestore().collection("users").document(toUID).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                
                guard let toName = self.user?.name else {return}
                guard let toUserAge = self.user?.age else {return}
                guard let toUserProfession = self.user?.profession else {return}
                
                let attributedText = NSMutableAttributedString(string: toName, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .black), NSMutableAttributedString.Key.foregroundColor : UIColor.black])
                attributedText.append(NSMutableAttributedString(string: "\n\(toUserAge), " + toUserProfession, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.darkGray]))
                
              self.userNameLabel.attributedText = attributedText
            }
   
            profileImageView.loadImageUsingCacheWithUrlString(urlString: cardViewModel.imageUrls.first ?? "")
            infoLabel.text = "Say Hi To " + cardViewModel.name
        }
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
            
            self.functions.httpsCallable("getBalance").call(["uid": self.user?.uid]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                if let balance = (result?.data as? [String: Any])?["balance"] as? Int {
                    self.balanceLabel.text = "Your balance: \(balance) Jo"
                    print(balance)
                }
            }
        }
        
        
    }
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "peter")
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9686274529, green: 0.5610659366, blue: 0.2193926538, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "In Mojo we believe saying Hi should not be a spam. Choose a gift to show your sincerity."
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "GIFTS"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your balance: 30 Jo"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // Set up collectionView
    
    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9509438452, green: 0.9509438452, blue: 0.9509438452, alpha: 1)
        
        navigationItem.title = "Send Chat Request"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchCurrentUser()
        
        setupLayout()
        
        loadData()
        
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0), size: .init(width: 64, height: 64))
        view.addSubview(userNameLabel)
        userNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        view.addSubview(infoLabel)
        infoLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 32, left: 24, bottom: 0, right: 0))
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: infoLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 24, bottom: 0, right: 24))
        
        
        setupCollectionViewLayout()
        
    }
    
    fileprivate func setupCollectionViewLayout() {
        // set up collectionView
        view.addSubview(menuCollectionView)
        menuCollectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        menuCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(menuLabel)
        menuLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: menuCollectionView.topAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: nil, leading: nil, bottom: menuCollectionView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 24))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return digitalGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8

        cell.digitalGood = digitalGoods[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 56, height: view.frame.width - 56)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let digitalGood = self.digitalGoods[indexPath.row]
        let controller = SendChatRequestController()
        controller.cardViewModel = cardViewModel
        controller.digitalGood = digitalGood
        navigationController?.pushViewController(controller, animated: true)
    }

}
