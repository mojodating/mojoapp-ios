//
//  TransactionsController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class TransactionsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Transactions"
        tableView.separatorStyle = .none
        
        fetchCurrentAddr()
    }
    
    var user: User?
    let currentUID = Auth.auth().currentUser?.uid
    fileprivate func fetchCurrentAddr() {
        Firestore.firestore().collection("users").document(currentUID ?? "").getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.fetchTransactions()
        }
    }
    
    
    var transactions = [Transaction]()
    fileprivate func fetchTransactions() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        guard let currentAddr = user?.address else { return }
        
        let ref = Firestore.firestore().collection("transactions").whereField("fromUid", isEqualTo: currentUID)
            
            ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let tx = document.data()
                    let transaction = Transaction(tx: tx)
                    self.transactions.append(transaction)
                    self.tableView.reloadData()
                }
            }
        }
        let docRef = Firestore.firestore().collection("transactions").whereField("toAddr", isEqualTo: currentAddr)
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let tx = document.data()
                    let transaction = Transaction(tx: tx)
                    self.transactions.append(transaction)
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TransactionCell(style: .default, reuseIdentifier: nil)
        let transaction = transactions[indexPath.row]
//        fetchUsers(transaction: transaction)
        cell.txLabel.text = "From: \(transaction.fromUid), to \(transaction.toAddr)"
        cell.valueLabel.text = "\(transaction.value)"
        cell.heightAnchor.constraint(equalToConstant: 140).isActive = true
        return cell
    }
    

    fileprivate func fetchUsers(transaction: Transaction) {
        let uid = transaction.fromUid
        
        let ref = Firestore.firestore().collection("users")
        
        ref.document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
        }
    }
 
}
