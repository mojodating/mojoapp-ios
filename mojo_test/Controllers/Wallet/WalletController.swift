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
    let emptyLabel = UILabel(text: "You will receive gifts in your wallet when accept chat request from other users. You can send your gifts to your friends on mojo.", font: .systemFont(ofSize: 14))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        
        setupNavigationBar()
        
        fetchCurrentUser()
        
        collectionView.register(WalletHeaderCell.self, forCellWithReuseIdentifier: headerCellId)
        collectionView.register(UserGiftCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifts.removeAll()
        fetchGifts()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(emptyLabel)
        emptyLabel.fillSuperview(padding: .init(top: 0, left: 36, bottom: 0, right: 36))
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.textColor = .lightGray
        emptyLabel.isHidden = true
    }
    
    var user: User?
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
        }
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
        if (self.gifts.count == 0) {
            self.emptyLabel.isHidden = false
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserGiftCell
            
            let gift = gifts[indexPath.item]
            let imageUrl = gift.imageUrl
            if let imageUrl = URL(string: imageUrl) {
                cell.giftImageView.sd_setImage(with: imageUrl)
            }
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            let gift = gifts[indexPath.row]
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Send to ..", style: .default, handler: { (_) in
                let sendGiftController = SendGiftController()
                sendGiftController.gift = gift
                self.navigationController?.pushViewController(sendGiftController, animated: true)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
        }
    }
    
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Wallet"
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.view.backgroundColor = .white
    }
  
    @objc fileprivate func handleAccount() {
        let walletAccountController = WalletAccountController()
        walletAccountController.user = self.user
        navigationController?.pushViewController(walletAccountController, animated: true)
    }
    @objc fileprivate func handleTopup() {
        let topupController = TopUpController()
        navigationController?.pushViewController(topupController, animated: true)
    }
    
    @objc fileprivate func handleFreeToken() {
        let inviteNewUserController = InviteNewUserController()
        inviteNewUserController.user = self.user
        navigationController?.pushViewController(inviteNewUserController, animated: true)
    }

}
