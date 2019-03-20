 //
//  CustomTextField.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/4/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

 class CustomTextField: UITextField {
    
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0.9640902602, green: 0.9640902602, blue: 0.9640902602, alpha: 1)
        layer.cornerRadius = 8
//        layer.borderWidth = 1
//        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return.init(width:0, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 }


 
