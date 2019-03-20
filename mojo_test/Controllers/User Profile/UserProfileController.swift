//
//  UserProfileController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/17/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserProfileController: UIViewController {
 
    var user: User?
    func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }

            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            
            self.setupCardFromUser(user: self.user!)
            
            guard let profileImageUrl = self.user?.imageUrl1 else { return }
            if let url = URL(string: profileImageUrl) {
                self.navProfileView.sd_setImage(with: url)
            }
            
            guard let userRate = self.user?.rate else { return }
            guard let rateCount = self.user?.rateCount else { return }
            let rate = Double(userRate) / Double (rateCount)
            guard let roundedRate = Double(String(format: "%.1f", rate)) else { return }
            
            self.ratingLabel.text = "\(roundedRate)"
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrentUser()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupNavProfileView()
        
        setupLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            let navController = UINavigationController(rootViewController: registrationController)
            self.present(navController, animated: true)
        }
    }
    
    let cardDeckView = UIView()
    
    fileprivate func setupLayout() {
        
        let userInfoStackView = UIStackView(arrangedSubviews: [
            ratingLabel,
            feedbacksButton
            ])
        userInfoStackView.spacing = 16
        view.addSubview(userInfoStackView)
        userInfoStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 12, right: 8))
        
        feedbacksButton.setTitleColor(.black, for: .normal)
        feedbacksButton.height(40)
        feedbacksButton.width(150)
        feedbacksButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        feedbacksButton.layer.borderWidth = 1
        feedbacksButton.addTarget(self, action: #selector(handleFeedbacks), for: .touchUpInside)
        
        view.addSubview(cardDeckView)
        cardDeckView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: userInfoStackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 12, right: 0))
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
        cardView.gestureRecognizers?.forEach(cardView.removeGestureRecognizer)
    }
    
    @objc fileprivate func handleFeedbacks() {
        let controller = FeedbacksController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    fileprivate let navProfileView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        iv.width(40)
        iv.height(40)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = true
        return iv
    }()
    let ratingLabel = UILabel(text: "No rating yet", font: .systemFont(ofSize: 18, weight: .semibold))
    let feedbacksButton = UIButton(title: "View Feedbacks", cornerRadius: 20, font: .systemFont(ofSize: 14, weight: .medium))
    
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
        
        addTargetToNavProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navProfileView.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navProfileView.isHidden = true
    }

    
    fileprivate func addTargetToNavProfileImage() {
                let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleEditProfile))
                singleTap.numberOfTapsRequired = 1;
                navProfileView.addGestureRecognizer(singleTap)
    }
    
    @objc fileprivate func handleEditProfile() {
        let editProfileController = EditProfileController()
        let navController = UINavigationController(rootViewController: editProfileController)
        present(navController, animated: true)
    }
    
}
