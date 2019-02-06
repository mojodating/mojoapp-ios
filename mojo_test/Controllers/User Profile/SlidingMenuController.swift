//
//  MenuController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/1/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

struct MenuItem {
    let icon: UIImage
    let title: String
}

class SlidingMenuController: UITableViewController {
    
    let menuItems = [
        MenuItem(icon: #imageLiteral(resourceName: "first"), title: "Edit Profile"),
        MenuItem(icon: #imageLiteral(resourceName: "first"), title: "Feedbacks"),
        MenuItem(icon: #imageLiteral(resourceName: "first"), title: "Free Token"),
        MenuItem(icon: #imageLiteral(resourceName: "first"), title: "Log Out")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SlidingMenuHeaderView()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SlidingMenuCell(style: .default, reuseIdentifier: "cellId")
        let menuItem = menuItems[indexPath.row]
        cell.titleLabel.text = menuItem.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select menu item:", indexPath.row)
        
        switch indexPath.row {
        case 0:
            self.openEditProfile()
        case 1:
            
            openFeedbacksController()
            
        case 2:
            self.openFreeToken()
            
        default:
            self.handleLogout()
        }
        
        handleClose()
        
    }

    func handleClose() {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.view.transform = CGAffineTransform(translationX: -300, y: 0)
            self.navigationController?.view.transform = CGAffineTransform(translationX: 0, y: 0)

            //            self.view.transform = transform
        })
    }
    
    fileprivate func openEditProfile() {
        let editProfileController = EditProfileController()
        let navController = UINavigationController(rootViewController: editProfileController)
        present(navController, animated: true)
    }
    
    fileprivate func openFeedbacksController() {
        let controller = FeedbacksController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func openFreeToken() {
        let inviteNewUserController = InviteNewUserController()
        navigationController?.pushViewController(inviteNewUserController, animated: true)
    }
    
    fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        let registrationController = RegistrationController()
        let navController = UINavigationController(rootViewController: registrationController)
        self.present(navController, animated: true)
    }
    
}
