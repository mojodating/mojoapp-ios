//
//  MenuCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/7/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var digitalGood: DigitalGood?  {
        didSet{
            
            guard let digitalGoodUrl = digitalGood?.imageUrl else { return }
            
            giftImageView.loadImageUsingCacheWithUrlString(urlString: digitalGoodUrl)
            
            nameLabel.text = digitalGood?.name
            
            priceLabel.text = "\(digitalGood?.price ?? 0) Jo"
            
            descriptionLabel.text = digitalGood?.description
        }
    }
    
    
    
    let giftImageView = UIImageView(cornerRadius: 0)
    let nameLabel = UILabel(text: "DRINK ONE", font: .systemFont(ofSize: 24, weight: .bold))
    let priceLabel = UILabel(text: ".. Jo", font: .systemFont(ofSize: 18, weight: .medium))
    let descriptionLabel = UILabel(text: "Description", font: .systemFont(ofSize: 16))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        layer.cornerRadius = 8
        
    }
    
    func setupLayout() {
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            giftImageView, UIView(), nameLabel, descriptionLabel
            ], spacing: 8)
        
        giftImageView.heightAnchor.constraint(equalToConstant: frame.height / 6 * 4).isActive = true
        
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 24, left: 32, bottom: 0, right: 32))
        
        addSubview(priceLabel)
        priceLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 32))
        priceLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: nameLabel.centerYAnchor, multiplier: 1).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
