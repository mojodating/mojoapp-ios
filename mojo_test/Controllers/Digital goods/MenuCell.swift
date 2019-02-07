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
            
            drinkImageView.loadImageUsingCacheWithUrlString(urlString: digitalGoodUrl)
            
            nameLabel.text = digitalGood?.name
            
            priceLabel.text = "MOJO \(digitalGood?.price ?? 0)"
            
            descriptionLabel.text = digitalGood?.description
        }
    }
    
    
    let drinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "DRINK ONE"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
//        label.text = "10 MOJO"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        layer.cornerRadius = 8
        
    }
    
    func setupLayout() {
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 32, bottom: 40, right: 32))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, leading: leadingAnchor, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 32, bottom: 8, right: 0))
        
        addSubview(priceLabel)
        priceLabel.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 32))
        
        addSubview(drinkImageView)
        drinkImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nameLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 24, bottom: 16, right: 24))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
