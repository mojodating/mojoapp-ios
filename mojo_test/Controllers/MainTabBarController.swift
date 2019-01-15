//
//  CustomTabBarController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/12/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, LoginControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let registrationController = RegistrationController()
                registrationController.delegate = self
                let navController = UINavigationController(rootViewController: registrationController)
                self.present(navController, animated: true)
            }
            return
        }
        didFinishLoggingIn()
    }
    
    func didFinishLoggingIn() {
        setupViewControllers()
    }

        
        func setupViewControllers() {
            
            transparentTabBarColor()
            
            //setup our custom view controllers
            
            let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "second"), rootViewController: HomeController())
            
            let chatNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "second"), rootViewController: ChatController())
            
            let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "second"), rootViewController: UserProfileController())
            
            let walletNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "second"), rootViewController: WalletController())
            
            tabBar.tintColor = .black
            
            viewControllers = [homeNavController, chatNavController, walletNavController, userProfileNavController]
            
            //modity tab bar item insets
            guard let items = tabBar.items else { return }
            
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
            
        }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    fileprivate func transparentTabBarColor() {
        //change tab bar color to transparent
        let transperentBlackColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.backgroundImage = image
        }
        
        UIGraphicsEndImageContext()
    }



}
