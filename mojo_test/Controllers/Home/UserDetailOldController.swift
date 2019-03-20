//
//  UserDetailController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/9/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class UserDetailOldController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerCellId = "headerCellId"
    var cardViewModel: CardViewModel!
    var user: User? {
        didSet {
            cardViewModel = user?.toCardViewModel()
            self.infoLabel.attributedText = cardViewModel.attributedString
            swipingController.cardViewModel = self.cardViewModel
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        setupLayout()
        fetchGifts()
        setupNotificationObservers()
        
    }
    
    // Encapsulation
    fileprivate let swipingController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let infoLabel = UILabel()
    
    lazy var containerView: ChatRequestInputAccessaryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let chatRequestInputAccessaryView = ChatRequestInputAccessaryView(frame: frame)
//        chatRequestInputAccessaryView.delegate = self
        return chatRequestInputAccessaryView
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0.9159337948, green: 0.9159337948, blue: 0.9159337948, alpha: 1)
        return cv
    }()
    
    let closeButton = UIButton()
    
    fileprivate func setupLayout() {
        
        let swipingPhotoView = swipingController.view!
        
        view.addSubview(swipingPhotoView)
        swipingPhotoView.backgroundColor = .white
        swipingPhotoView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 36)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: swipingPhotoView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        infoLabel.numberOfLines = 0
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: .init(width: 30, height: 30))
        closeButton.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 58, right: 0), size: .init(width: view.frame.width, height: 140))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(GiftHeaderCell.self, forCellWithReuseIdentifier: headerCellId)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GiftCell
            cell.digitalGood = digitalGoods[indexPath.item]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: 100, height: 100)
        }
        return CGSize(width: view.frame.width, height: 30)
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
    
    // Functions
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.containerView.isHidden = true
        self.dismiss(animated: true)
    }
    
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:1, initialSpringVelocity:1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification:Notification) {
        print ("keyboard will show")
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
        { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)

        //the gap from register button to the keyboard

        let bottomSpace = view.frame.height - collectionView.frame.origin.y - collectionView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    
    func didSendRequest(for requestText: String) {
        
    }

}
