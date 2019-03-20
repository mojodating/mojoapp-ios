//
//  TransactionCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    let txLabel = UILabel(text: "Gift: ABC, from User A to User B", font: .systemFont(ofSize: 16, weight: .medium))
    let timeLabel = UILabel(text: "10.30.2018", font: .systemFont(ofSize: 13))
    let valueLabel = UILabel(text: "5 Jo", font: .systemFont(ofSize: 16, weight: .medium))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        
        addSubview(txLabel)
        txLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: valueLabel.leadingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        txLabel.numberOfLines = 0
        txLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        addSubview(timeLabel)
        timeLabel.anchor(top: txLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 16, bottom: 0, right: 0))
        timeLabel.textColor = .darkGray
        
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.9319355397, green: 0.9319355397, blue: 0.9319355397, alpha: 1)
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 8))
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
