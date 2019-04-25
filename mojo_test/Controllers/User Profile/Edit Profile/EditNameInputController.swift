//
//  EditProfileInputController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 4/2/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class EditNameInputController: UITableViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Name"
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EditProfileCell(style: .default, reuseIdentifier: nil)
        cell.textField.placeholder = "Your name"
        if let name = user?.name {
            cell.textField.text = String(name)
        }
        
        return cell
    }


}
