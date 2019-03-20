//
//  GiftCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/10/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import SDWebImage

class GiftCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = #colorLiteral(red: 0.9922668147, green: 0.9574156984, blue: 0.9535622223, alpha: 1)
        }
    }
    
    var digitalGood: DigitalGood?  {
        didSet{
            
            guard let digitalGoodUrl = digitalGood?.imageUrl else { return }
            
            if let url = URL(string: digitalGoodUrl) {
                giftImageView.sd_setImage(with: url)
            }
            guard let giftName = digitalGood?.name  else { return }
            self.nameLabel.text = giftName
            
            self.priceLabel.text = "\(digitalGood?.price ?? 0) Jo"
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(giftImageView)
        giftImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 0), size: .init(width: 50, height: 50))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: giftImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 0, right: 4))
        nameLabel.textAlignment = .center
        
        
        addSubview(priceLabel)
        priceLabel.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        priceLabel.textAlignment = .center
    }
    
    fileprivate let giftImageView = UIImageView(cornerRadius: 0)
    fileprivate let nameLabel = UILabel(text: "DrinkName", font: .systemFont(ofSize: 12, weight: .medium))
    fileprivate let priceLabel = UILabel(text: "", font: .systemFont(ofSize: 12))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
