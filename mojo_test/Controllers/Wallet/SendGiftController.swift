//
//  SendGiftController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SendGiftController: UITableViewController {
    
    var gift: Gift?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Send Gift"
        tableView.separatorStyle = .none
        
        fetchContacts()
    }
    
    var contacts = [Conversation]()
    
    fileprivate func fetchContacts() {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(currentUID)
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                
                guard let dictionaries = document.data() else { return }
                guard let dictionary = dictionaries["conversations"] as? [String : Any] else { return }
                dictionary.forEach({ (key, value) in
                    
                    guard let conv = value as? [String: Any] else {return}
                    let conversation = Conversation(conv: conv)
                    if (conversation.accepted) {
                        
                        self.contacts.append(conversation)
                    }
                    self.tableView.reloadData()
                })
                
            } else {
                print("Document does not exist")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactCell(style: .default, reuseIdentifier: nil)
        cell.conversation = contacts[indexPath.row]
        cell.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return cell
    }
    
    lazy var functions = Functions.functions()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = self.contacts[indexPath.row]
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        var chatProfileUID: String?
        if currentUser == conversation.sender {
            chatProfileUID = conversation.receiver
        } else {
            chatProfileUID = conversation.sender
        }
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Sending gift 🎁.."
        hud.show(in: self.view)
        
        functions.httpsCallable("sendDrink").call(["uid": chatProfileUID, "drinkid":gift?.id]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            hud.textLabel.text = "Sent!"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2)
        }
    }
    

}
