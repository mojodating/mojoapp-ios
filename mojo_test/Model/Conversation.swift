//
//  ChatRequest.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

struct Conversation {
    
    let id: String
    let accepted: Bool
    let drinkImage: String
    let drinkName : String
    let drinkPrice: Int
    let sender: String
    let receiver: String
    let text: String
    var lastMessageDate: Date
    let seen: Bool
    
    var hasFeedback = false
    
    init(conv:[String : Any]) {
        self.id = conv["id"] as? String ?? ""
        self.accepted = conv["accepted"] as? Bool ?? false
        self.drinkImage = conv["drinkImage"] as? String ?? ""
        self.drinkName = conv["drinkName"] as? String ?? ""
        self.drinkPrice = conv["drinkPrice"] as? Int ?? 0
        self.sender = conv["sender"] as? String ?? ""
        self.receiver = conv["receiver"] as? String ?? ""
        self.text = conv["text"] as? String ?? ""
        self.seen = conv["seen"] as? Bool ?? false
        let secondsFrom1970 = conv["lastMessageDate"] as? Double ?? 0
        self.lastMessageDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
