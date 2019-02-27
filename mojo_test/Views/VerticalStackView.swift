//
//  VerticalStackView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/12/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
    init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        arrangedSubviews.forEach({addArrangedSubview($0)})        
        self.spacing = spacing
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
