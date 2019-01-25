//
//  Message.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

struct Message {
    let date: Date
    let sender: String
    let text: String
    let receiver: String
    
    init(msg:[String : Any]) {
        self.sender = msg["sender"] as? String ?? ""
        self.text = msg["text"] as? String ?? ""
        self.receiver = msg["receiver"] as? String ?? ""
        
        let secondsFrom1970 = msg["date"] as? Double ?? 0
        self.date = Date(timeIntervalSince1970: secondsFrom1970)
    }

}
