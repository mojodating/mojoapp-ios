//
//  CustomMenuHeaderView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/2/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class SlidingMenuHeaderView: UIView {
    
    var user: User?
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
                if let err = err {
                    print(err)
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
            guard let profileUrl = self.user?.imageUrl1 else { return }
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
            self.nameLabel.text = self.user?.name
            
            guard let userRate = self.user?.rate else { return }
            guard let rateCount = self.user?.rateCount else { return }
            var rate = Double()
            rate = Double(userRate) / Double (rateCount)
            
            self.ratingLabel.text = "\(rate)"

            if self.user?.insideHouse == true {
                self.isInHouseLabel.text = "Popular bachelor"
            } else {
                self.isInHouseLabel.text = ""
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
        
        fetchUser()
    }
    
    let profileImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "cersi"))
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 32
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel = UILabel()
    let ratingLabel = UILabel()
    let isInHouseLabel = UILabel()
    let closeButton = UIButton()
    
    func setupLayout() {
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading:leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0), size: .init(width: 64, height: 64))
        
        nameLabel.text = "Dummy User"
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        ratingLabel.text = "4.7"
        ratingLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        isInHouseLabel.text = "In Bouncer’s Line"
        isInHouseLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let arrangedSubViews = [nameLabel, spacerView(space: 16), ratingLabel, isInHouseLabel, spacerView(space: 16)]
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.axis = .vertical
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 24, bottom: 16, right: 16)
        
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 0.9092515295, green: 0.9092515295, blue: 0.9092515295, alpha: 1)
        addSubview(lineView)
        lineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: frame.width, height: 1))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class spacerView: UIView {
    
    let space: CGFloat
    
    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
