//
//  Transactions.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

struct Transaction {
    
    let fromUid: String
    let toAddr: String
    let value: Int
    let status: String
    
    
    init(tx:[String : Any]) {
        self.fromUid = tx["fromUid"] as? String ?? ""
        self.toAddr = tx["toAddr"] as? String ?? ""
        self.value = tx["value"] as? Int ?? 0
        self.status = tx["status"] as? String ?? ""
    }
}
