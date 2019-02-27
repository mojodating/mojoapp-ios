//
//  WalletController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/21/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class WalletController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerCellId = "headerCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        
        setupNavigationBar()
        
        fetchGifts()
        
        collectionView.register(WalletHeaderCell.self, forCellWithReuseIdentifier: headerCellId)
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var gifts = [Gift]()
    fileprivate func fetchGifts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
    let ref = Firestore.firestore().collection("drinks").whereField("owner", isEqualTo: uid)
    ref.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let giftType = document.data()
                        let gift = Gift(giftType: giftType)
                        self.gifts.append(gift)
                        
                        self.collectionView.reloadData()
                    }
                }
            }
        }
   
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return gifts.count
        }
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GiftCell
            
            let gift = gifts[indexPath.item]
            let imageUrl = gift.imageUrl
            cell.giftImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
            cell.nameLabel.text = gift.name
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellId, for: indexPath) as! WalletHeaderCell
        cell.accountButton.addTarget(self, action: #selector(handleAccount), for: .touchUpInside)
        cell.topUpButton.addTarget(self, action: #selector(handleTopup), for: .touchUpInside)
        cell.freeTokenButton.addTarget(self, action: #selector(handleFreeToken), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }
        
        return CGSize(width: view.frame.width, height: 216)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 1
    }
    
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Wallet"
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transactions", style: .plain, target: self, action: #selector(handleTransaction))        
        // nav background color
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .white
    }
  
    @objc fileprivate func handleAccount() {
        let walletAccountController = WalletAccountController()
        navigationController?.pushViewController(walletAccountController, animated: true)
    }
    @objc fileprivate func handleTopup() {
        let topupController = TopUpController()
        navigationController?.pushViewController(topupController, animated: true)
    }
    
    @objc fileprivate func handleFreeToken() {
        let inviteNewUserController = InviteNewUserController()
        navigationController?.pushViewController(inviteNewUserController, animated: true)
    }

}
