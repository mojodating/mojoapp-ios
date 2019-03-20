//
//  GenderSelectionController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/4/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class GenderSelectionController: UITableViewController {
    
    var user: User?
    
    let genders = ["Men", "Woman", "Other"]
    let cellId = "cellId"
    var choosedGender = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "My Gender"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectionCell(style: .default, reuseIdentifier: "cellId")
        cell.titleLabel.text = genders[indexPath.item]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.choosedGender = genders[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        handleSave()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
    fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String: Any] = [
            "gender": self.choosedGender
        ]
        
        let hud = JGProgressHUD(style: .dark)
        Firestore.firestore().collection("users").document(uid).updateData(docData) {
            (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings", err)
                return
            }
            print ("Finished saving user gender")
            hud.textLabel.text = "Saved!"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2)
        }
        
    }

}

class SelectionCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 18))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 16, left: 24, bottom: 16, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
