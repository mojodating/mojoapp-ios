//
//  Extensions + UILabel.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIButton {
    convenience init(title: String, cornerRadius: CGFloat, font: UIFont) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = font
    }
}
