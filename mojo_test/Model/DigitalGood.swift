//
//  DigitalGoods.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/7/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

struct DigitalGood {
    
    let id: String
    let imageUrl: String
    let name: String
    let price : Int
    let description: String
    
    init(drinkType:[String : Any]) {
        self.id = drinkType["id"] as? String ?? ""
        self.imageUrl = drinkType["imageUrl"] as? String ?? ""
        self.name = drinkType["name"] as? String ?? ""
        self.price = drinkType["price"] as? Int ?? 0
        self.description = drinkType["description"] as? String ?? ""
    }
}


