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
    var gender: String?
    var genderSeeking: String?
    var location: String?
    var invitationCode: String?
    var address: String?
    var bio: String?
    
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
        self.gender = dictionary["gender"] as? String
        self.genderSeeking = dictionary["genderSeeking"] as? String
        self.location = dictionary["location"] as? String
        self.invitationCode = dictionary["invitationCode"] as? String
        self.address = dictionary["address"] as? String
        self.bio = dictionary["bio"] as? String
    }
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .bold)])

        let aveRate = Double(rate ?? 0) / Double (rateCount ?? 1)
        if (aveRate >= 4.5) {
        attributedText.append(NSMutableAttributedString(string: " ♚", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), .font:UIFont.systemFont(ofSize: 24, weight: .heavy) ]))
        }
        
        let ageString = age != nil ? "\(age!)" : "Age not available"

        attributedText.append(NSMutableAttributedString(string: "\n\(ageString) ", attributes: [.font:UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let locationString = location != nil ? location! : ""
        attributedText.append(NSMutableAttributedString(string: " \(locationString) ", attributes: [.font:UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Profession not available"
        attributedText.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        let schoolString = school != nil ? school! : ""
        attributedText.append(NSMutableAttributedString(string: "\n\(schoolString)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
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
