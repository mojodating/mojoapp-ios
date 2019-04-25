//
//  UserReviewCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/29/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class UserReviewCell: UICollectionViewCell {
    
    fileprivate func fetchFeedbacksFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionaries = document.data() else { return }
                guard let dictionary = dictionaries["feedback"] as? [String : Any] else { return }
                print(dictionary)
                let likeCount = dictionary["like"]
                self.likeCountLabel.text = "\(likeCount ?? 0)"
                let mehCount = dictionary["meh"]
                self.mehCountLabel.text = "\(mehCount ?? 0)"
                let madCount = dictionary["mad"]
                self.madCountLabel.text = "\(madCount ?? 0)"
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        fetchFeedbacksFromFirestore()
    }
    
    fileprivate func setupLayout() {
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8))
        
        let stackView = UIStackView(arrangedSubviews: [likeImage, likeCountLabel, mehImage, mehCountLabel, madImage, madCountLabel])
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 24, left: 16, bottom: 0, right: 16))
        
        addSubview(secondTitleLabel)
        secondTitleLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 16, right: 8))
        
        addSubview(LineView)
        LineView.anchor(top: nil, leading: leadingAnchor, bottom: secondTitleLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 16, right: 2), size: .init(width: frame.width, height: 1))
        
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "YOUR REVIEW"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    static func createImageView(image: UIImage) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.width(48)
        iv.height(48)
        return iv
    }
    
    let likeImage = createImageView(image: #imageLiteral(resourceName: "image 3"))
    let likeCountLabel = UILabel(text: "0", font: .systemFont(ofSize: 16, weight: .medium))
    let mehImage = createImageView(image: #imageLiteral(resourceName: "image 4"))
    let mehCountLabel = UILabel(text: "0", font: .systemFont(ofSize: 16, weight: .medium))
    let madImage = createImageView(image: #imageLiteral(resourceName: "mad"))
    let madCountLabel = UILabel(text: "0", font: .systemFont(ofSize: 16, weight: .medium))
    
    let LineView : UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.9365159648, green: 0.9365159648, blue: 0.9365159648, alpha: 1)
        return lv
    }()
    
    let secondTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "RATE YOUR PEERS"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
