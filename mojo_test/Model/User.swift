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
    var profileImageUrl: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var imageUrl4: String?
    var imageUrl5: String?
    var imageUrl6: String?
    var uid: String?
    var rate: Int?
    var rateCount: Int?
    var insideHouse: Bool?
    var school: String?
    
    var location: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.imageUrl4 = dictionary["imageUrl4"] as? String
        self.imageUrl5 = dictionary["imageUrl5"] as? String
        self.imageUrl6 = dictionary["imageUrl6"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
        self.rate = dictionary["bouncingLineRating"] as? Int
        self.rateCount = dictionary["bouncingLineRatingCount"] as? Int
        self.insideHouse = dictionary["insideHouse"] as? Bool ?? false
        self.school = dictionary["school"] as? String
        
        
        self.location = dictionary["location"] as? String
    }
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .bold)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"

        attributedText.append(NSMutableAttributedString(string: "\n\(ageString), ", attributes: [.font:UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let locationString = location != nil ? location! : "Earth"
        attributedText.append(NSMutableAttributedString(string: "\(locationString), ", attributes: [.font:UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let schoolString = school != nil ? school! : ""
        attributedText.append(NSMutableAttributedString(string: "\(schoolString)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not Available"
        attributedText.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
        
        var imageUrlsAll = [String]()

        if let url = imageUrl1 {imageUrlsAll.append(url)}
        if let url = imageUrl2 {imageUrlsAll.append(url)}
        if let url = imageUrl3 {imageUrlsAll.append(url)}
        if let url = imageUrl4 {imageUrlsAll.append(url)}
        if let url = imageUrl5 {imageUrlsAll.append(url)}
        if let url = imageUrl6 {imageUrlsAll.append(url)}
        
        var imageUrlRemove = [String]()
        
        imageUrlsAll.forEach { (url) in
            if url == "" {
                imageUrlRemove.append(url)
            }
        }
        
        let iamgeUrls = imageUrlsAll.filter { (url) -> Bool in
            !imageUrlRemove.contains(url)
        }

        return CardViewModel(uid:self.uid ?? "", name: self.name ?? "", rate: self.rate ?? 0, imageNames: iamgeUrls, attributedString: attributedText, textAlignment: .left)
    }
}
