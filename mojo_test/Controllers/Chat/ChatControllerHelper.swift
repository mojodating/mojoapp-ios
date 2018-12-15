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
            
            let jaime = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)  as! Friend
            jaime.name = "Ser Jaime"
            jaime.profileImageName = "jaime"
            
            createMessageWithText(text: "Lost one hand", friend: jaime, minutesAgo: 3.0, context: context)
            createMessageWithText(text: "Hello, how are you?", friend: jaime, minutesAgo: 2.0, context: context)
            createMessageWithText(text: "picked up the sword again ...", friend: jaime, minutesAgo: 1, context: context)
            
            let cersi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context)  as! Friend
            cersi.name = "Cersi Lannister"
            cersi.profileImageName = "cersi"
            
            createMessageWithText(text: "Give me more Wine", friend: cersi, minutesAgo: 5, context: context)
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
        
    }
    
    fileprivate func createMessageWithText(text:String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext ) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context )  as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60.0)
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    print(friend.name)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let fetchedMessages = try(context.fetch(fetchRequest) ) as? [Message]
                        
                        messages?.append(contentsOf: fetchedMessages!)
                        
                    } catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
            }
            
        }
    }
    
    fileprivate func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
         
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
               return try (context.fetch(request)) as? [Friend]
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
}
