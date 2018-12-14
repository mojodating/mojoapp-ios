//
//  ChatControllerHelper.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/13/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import CoreData


extension ChatController {
    
    func setupData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let peter = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)  as! Friend
            peter.name = "Peter Dinklage"
            peter.profileImageName = "peter"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context)  as! Message
            message.friend = peter
            message.text = "Hello, nice to meet you!"
            message.date = NSDate()
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)  as! Friend
            steve.name = "Ser Jaimi"
            steve.profileImageName = "peter"
            
            let messageJaimi = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context)  as! Message
            messageJaimi.friend = steve
            messageJaimi.text = "Lost one hand"
            messageJaimi.date = NSDate()
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
            
            messages = [message, messageJaimi]
            
        }
        
    }
}
