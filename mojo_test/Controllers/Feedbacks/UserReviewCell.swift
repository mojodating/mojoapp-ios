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
        
        let ref = Firestore.firestore().collection(uid).document("feedback")
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionary = document.data() else { return }
                print(dictionary)
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
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 8, bottom: 0, right: 0))
        
        addSubview(ImageStackView)
        ImageStackView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 24, left: 16, bottom: 0, right: 16))
        
        addSubview(labelStackView)
        labelStackView.anchor(top: ImageStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(LineView)
        LineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 16, right: 2), size: .init(width: frame.width, height: 1))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your review"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    static func createImageView(image: UIImage) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.imageView?.width(32)
//        iv.imageView?.height(32)
        return iv
    }
    
    
    let ImageStackView: UIStackView = {
        let sv = UIStackView()
        
        let likeImage = createImageView(image: #imageLiteral(resourceName: "image 3"))
        let loveImage = createImageView(image: #imageLiteral(resourceName: "image2"))
        let dopeImage = createImageView(image: #imageLiteral(resourceName: "image 5"))
        let mehImage = createImageView(image: #imageLiteral(resourceName: "image 4"))
        let fakeIdImage = createImageView(image: #imageLiteral(resourceName: "image 6"))
        let madImage = createImageView(image: #imageLiteral(resourceName: "image"))
        
        [likeImage,loveImage, dopeImage, mehImage, fakeIdImage, madImage].forEach{(image) in
            sv.addArrangedSubview(image)
        }
        
        sv.distribution = .equalSpacing
        return sv
    }()
    
    static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }
    
    let labelStackView: UIStackView = {
        let sv = UIStackView()
        
        let likeButtonLabel  = createLabel(text: "0")
        let loveButtonLabel  = createLabel(text: "0")
        let dopeButtonLabel  = createLabel(text: "0")
        let mehButtonLabel  = createLabel(text: "0")
        let fakeIdButtonLabel  = createLabel(text: "0")
        let madButtonLabel  = createLabel(text: "0")
        
        
        [likeButtonLabel,loveButtonLabel, dopeButtonLabel, mehButtonLabel, fakeIdButtonLabel, madButtonLabel].forEach{(label) in
            sv.addArrangedSubview(label)
        }
        
        sv.distribution = .equalSpacing
        sv.alignment = .firstBaseline
        
        return sv
    }()
    
    let LineView : UIView = {
        let lv = UIView()
        lv.backgroundColor = #colorLiteral(red: 0.9365159648, green: 0.9365159648, blue: 0.9365159648, alpha: 1)
        return lv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
