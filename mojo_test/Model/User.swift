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
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullname"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"

        attributedText.append(NSMutableAttributedString(string: "\n\(ageString), ", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not Available"

        attributedText.append(NSMutableAttributedString(string: "\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]))
        
        var imageUrls = [String]() // empty string array
        if let url = imageUrl1 {imageUrls.append(url)}
        if let url = imageUrl2 {imageUrls.append(url)}
        if let url = imageUrl3 {imageUrls.append(url)}
        
        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
