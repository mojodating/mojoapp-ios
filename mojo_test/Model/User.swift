//
//  User.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/2/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

struct User {
    //defining our properties for our model layer
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        attributedText.append(NSMutableAttributedString(string: "\n\(age), ", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        attributedText.append(NSMutableAttributedString(string: "\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
}
