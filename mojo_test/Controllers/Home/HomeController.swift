//
//  PeepsController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/13/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: BaseListController, UICollectionViewDelegateFlowLayout, ProfileCellDelegate {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrentUser()
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9322652284, green: 0.9322652284, blue: 0.9322652284, alpha: 1)
        
        setupNavigation()
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        collectionView.allowsMultipleSelection = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(handleRefreshPage), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc fileprivate func handleRefreshPage(refreshControl: UIRefreshControl) {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.setupViewControllers()
        refreshControl.endRefreshing()
    }
    
    lazy var functions = Functions.functions()
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    var cardViewModel: CardViewModel!
    var users = [User]()

    func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            self.user = user

            self.fetchUsersFromFirestore()
        }
    }
    

    fileprivate func fetchUsersFromFirestore() {
        
        self.functions.httpsCallable("getUsers").call() { (result, error) in
            self.hud.dismiss()
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
                }
                print(error)
            }
            if let dictionary = result?.data as? [String: Any] {
                dictionary.forEach({ (key, value) in
                    guard let conv = value as? [String: Any] else { return }
                    conv.forEach({ (key, value) in
                        if let userDict = value as? [String: Any] {
                            let user = User(dictionary: userDict)
                            if user.uid != Auth.auth().currentUser?.uid {
                                self.users.append(user)
                                self.collectionView.reloadData()
                            }
                            self.cardViewModel = user.toCardViewModel()
                            }
                        })
                    })
                }
            }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileCell
        cell.user = users[indexPath.item]
        cell.delegate = self
        cell.cosmosView.didTouchCosmos = { rating in
            print("Rated: \(rating)")
            
            guard let cardUID = cell.user?.uid else { return }
            print(cardUID)
            self.functions.httpsCallable("rate").call(["uid": cardUID, "rate": rating]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        _ = FunctionsErrorCode(rawValue: error.code)
                        _ = error.localizedDescription
                        _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
            }
            cell.cosmosView.isUserInteractionEnabled = false
            self.hud.textLabel.text = "Submitted"
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 0.5)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 56, height: view.frame.height / 3 * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    let navProfileView = UIImageView(cornerRadius: 20)
    
    fileprivate func setupNavigation() {
        navigationItem.title = "Mojo"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = #colorLiteral(red: 0.9585977157, green: 0.9585977157, blue: 0.9585977157, alpha: 1)
//        setupNavProfileView()
        
    }
    
    fileprivate func setupNavProfileView() {
        navProfileView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        navProfileView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        navProfileView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        navigationController?.navigationBar.addSubview(navProfileView)
        navProfileView.tag = 1
        navProfileView.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 20)
        
        let targetView = self.navigationController?.navigationBar
        
        let trailingContraint = NSLayoutConstraint(item: navProfileView, attribute:
            .trailingMargin, relatedBy: .equal, toItem: targetView,
                             attribute: .trailingMargin, multiplier: 1.0, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: navProfileView, attribute: .bottom, relatedBy: .equal,
                                                  toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -6)
        navProfileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func didTapChat(user: User) {
        let chatRequestController = ChatRequestController()
        chatRequestController.user = user
        let navController = UINavigationController(rootViewController: chatRequestController)
        present(navController, animated: true)
    }
    
    func didTapProfileImage(user: User) {
        
        let userDetailController = UserDetailController()
        userDetailController.user = user
        present(userDetailController, animated: true)        
    }
    

}
