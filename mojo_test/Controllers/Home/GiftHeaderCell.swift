//
//  GiftHeaderCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/10/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class GiftHeaderCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [
            GiftHeaderLabel,
            balanceLabel,
            
            ])
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        stackView.distribution = .fill
    }
    
    let GiftHeaderLabel = UILabel(text: "GIFTS", font: .systemFont(ofSize: 16, weight: .semibold))
    let balanceLabel = UILabel(text: "Balance: 12 Jo", font: .systemFont(ofSize: 16, weight: .medium))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
