//
//  DigitalGoods.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/7/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import Foundation

struct DigitalGood {
    
    let imageUrl: String
    let digitalGoodName: String
    let price : Int
    let description: String
    
    init(drinkType:[String : Any]) {
        self.imageUrl = drinkType["imageUrl"] as? String ?? ""
        self.digitalGoodName = drinkType["name"] as? String ?? ""
        self.price = drinkType["price"] as? Int ?? 0
        self.description = drinkType["description"] as? String ?? ""
    }
}


