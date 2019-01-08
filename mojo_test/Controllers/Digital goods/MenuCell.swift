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
            
            nameLabel.text = digitalGood?.digitalGoodName
            
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
        
        setupMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenu() {
        addSubview(drinkImageView)
        drinkImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 16, left: 24, bottom: 0, right: 24), size: .init(width: self.frame.width, height: 240))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: drinkImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 0, right: 0))

        addSubview(priceLabel)
        priceLabel.anchor(top: drinkImageView.bottomAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 24))
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nameLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 8, left: 24, bottom: 0, right: 24))
    }
}
