//
//  User.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/2/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
 
    //defining our properties for our model layer
    var name: String?
    var age: Int?
    var profession: String?
//    let imageNames: [String]
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullname"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"

        attributedText.append(NSMutableAttributedString(string: "\n\(ageString), ", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not Available"

        attributedText.append(NSMutableAttributedString(string: "\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]))

        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
