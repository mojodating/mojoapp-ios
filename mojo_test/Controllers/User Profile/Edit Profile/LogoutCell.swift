//
//  LogoutCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/26/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {
    let LogoutButton = UIButton(title: "Log out", cornerRadius: 0, font: .systemFont(ofSize: 16, weight: .medium))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(LogoutButton)
        LogoutButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0))
        LogoutButton.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        LogoutButton.height(36)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
