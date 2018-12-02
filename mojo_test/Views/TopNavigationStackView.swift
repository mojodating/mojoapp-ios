//
//  TopNavigationStackView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/1/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let filterButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        settingsButton.setImage(#imageLiteral(resourceName: "208322b9-6bf3-4241-9cec-17a73e689bac").withRenderingMode(.alwaysOriginal), for: .normal)
        filterButton.setImage(#imageLiteral(resourceName: "filter").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), UIView(), filterButton].forEach{(v) in
            addArrangedSubview(v)
        }
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
        
}

