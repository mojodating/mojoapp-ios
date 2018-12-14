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
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
   
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try (context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }
            
                
                try(context.save())
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupData() {
        
        clearData()
        
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
        }
        
        loadData()
        
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest : NSFetchRequest<Message> = Message.fetchRequest()
            
            do {
                messages = try(context.fetch(fetchRequest) ) as? [Message]
            } catch let err {
                print(err)
            }
        }

}
    
}
