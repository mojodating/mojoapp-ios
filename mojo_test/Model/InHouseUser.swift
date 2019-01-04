//
//  InHouseUser.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/3/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

struct InHouseUser : ProducesCardViewModel {
    let name: String
    let age: Int
    let profession: String
    let imageNames: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        attributedText.append(NSMutableAttributedString(string: "\n\(age), ", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        attributedText.append(NSMutableAttributedString(string: "\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        return CardViewModel(uid:"", name:self.name,imageNames: [imageNames], attributedString: attributedText, textAlignment: .left)
    }
}
