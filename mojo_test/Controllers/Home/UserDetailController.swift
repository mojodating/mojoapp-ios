//
//  UserDetailController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/11/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class UserDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var cardViewModel: CardViewModel!
    var user: User? {
        didSet {
            cardViewModel = user?.toCardViewModel()
        }
    }

    let cellHeaderId = "cellHeaderId"
    let infoCellID = "infoCellID"
    let closeButton = UIButton()
    let chatRequestButton = UIButton(title: "Send Chat Request", cornerRadius: 0, font: .systemFont(ofSize: 16, weight: .semibold))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.keyboardDismissMode = .interactive
    
        self.collectionView!.register(UserDetailHeaderCell.self, forCellWithReuseIdentifier: cellHeaderId)
        self.collectionView.register(UserDetailInfoCell.self, forCellWithReuseIdentifier: infoCellID)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: .init(width: 30, height: 30))
        closeButton.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        
        view.addSubview(chatRequestButton)
        chatRequestButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: 50))
        chatRequestButton.backgroundColor = #colorLiteral(red: 0.9840267933, green: 0.9859146527, blue: 0.524038941, alpha: 1)
        chatRequestButton.setTitleColor(.black, for: .normal)
        chatRequestButton.addTarget(self, action: #selector(handleOpenRequest), for: .touchUpInside)
       
    }
    
    @objc fileprivate func handleOpenRequest() {
        let chatRequestController = ChatRequestController()
        let navController = UINavigationController(rootViewController: chatRequestController)
        chatRequestController.user = user
        present(navController, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellID, for: indexPath) as! UserDetailInfoCell
            cell.userInfoLabel.attributedText = cardViewModel.attributedString
            cell.userAboutLabel.text = user?.bio
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellHeaderId, for: indexPath) as! UserDetailHeaderCell
            cell.swipingController.cardViewModel = self.cardViewModel
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
        return CGSize(width: view.frame.width, height: view.frame.width + 72)
    }

    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    

}
