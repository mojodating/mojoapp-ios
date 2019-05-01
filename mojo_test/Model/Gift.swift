//
//  Gift.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/5/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

struct Gift {
    
    let id: String
    let imageUrl: String
    let name: String
    let blocked: Bool?
    let sender: String
    
    init(giftType:[String : Any]) {
        self.id = giftType["id"] as? String ?? ""
        self.imageUrl = giftType["imageUrl"] as? String ?? ""
        self.name = giftType["name"] as? String ?? ""
        self.blocked = giftType["blocked"] as? Bool ?? false
        self.sender = giftType["sender"] as? String ?? ""
    }
}
