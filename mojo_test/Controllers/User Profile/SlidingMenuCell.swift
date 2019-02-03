//
//  SlidingMenuCellTableViewCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/2/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class SlidingMenuCell: UITableViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "profile"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 16, left: 24, bottom: 16, right: 0))   
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
