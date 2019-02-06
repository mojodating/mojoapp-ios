//
//  CustomTabBarController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/12/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, LoginControllerDelegate, editProfileControllerDelegate {

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
        
        setupViewControllers()
    }
    
    func didFinishLoggingIn() {
        setupViewControllers()
    }
    
    func didSaveProfile() {
        setupViewControllers()
    }
    
        func setupViewControllers() {
            
            transparentTabBarColor()
            
            //setup our custom view controllers
            
            let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "image-5"), selectedImage: #imageLiteral(resourceName: "home"), rootViewController: HomeController())
            
            
            let chatNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "image-7"), selectedImage: #imageLiteral(resourceName: "imag-1"), rootViewController: ChatController())
            
//            let controller = PrivateChatController(collectionViewLayout: UICollectionViewFlowLayout())
//            let chatNavController = UINavigationController(rootViewController: controller)
            
           
            let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "image-1"), selectedImage: #imageLiteral(resourceName: "image-3"), rootViewController: UserProfileController())
            
            let walletNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "image-4"), selectedImage: #imageLiteral(resourceName: "image-6"), rootViewController: WalletController())
            
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
        
        let transperentBlackColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15)
        
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
