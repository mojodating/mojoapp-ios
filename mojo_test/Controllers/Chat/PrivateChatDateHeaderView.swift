//
//  PrivateChatDateHeaderView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/6/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class PrivateChatDateHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(dateLabel)
        
        dateLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 1).isActive = true
        dateLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: self.centerYAnchor, multiplier: 1).isActive = true
        
        dateLabel.textColor = .lightGray
        
        dateLabel.textAlignment = .center
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        
    }
    
    let dateLabel = UILabel(text: "Mar 6, 2019, 9:52 PM", font: .systemFont(ofSize: 12))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
