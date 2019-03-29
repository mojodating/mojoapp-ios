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
    
    func setupViewControllers() {
            
//            changeTabBarColor()
            
            //setup our custom view controllers
            
            let homeNavController = createNavController(unselectedImage: #imageLiteral(resourceName: "image-5"), selectedImage: #imageLiteral(resourceName: "home"), viewController: HomeController())
            
            let chatNavController = createNavController(unselectedImage: #imageLiteral(resourceName: "image-7"), selectedImage: #imageLiteral(resourceName: "imag-1"), viewController: ChatController())
            
            let userProfileNavController = createNavController(unselectedImage: #imageLiteral(resourceName: "image-1"), selectedImage: #imageLiteral(resourceName: "image-3"), viewController: UserProfileController())
            
            let walletNavController = createNavController(unselectedImage: #imageLiteral(resourceName: "image-4"), selectedImage: #imageLiteral(resourceName: "image-6"), viewController: WalletController())
            
            tabBar.tintColor = .black
            tabBar.unselectedItemTintColor = #colorLiteral(red: 0.2329869924, green: 0.2329869924, blue: 0.2329869924, alpha: 1)
            
            viewControllers = [homeNavController, chatNavController, walletNavController, userProfileNavController]
        
        
            //modity tab bar item insets
            guard let items = tabBar.items else { return }
            
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
            
    }
    
    fileprivate func createNavController(unselectedImage: UIImage, selectedImage: UIImage, viewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    
    fileprivate func changeTabBarColor() {
        
        let transperentBlackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.backgroundImage = image
        }
        
        UIGraphicsEndImageContext()
    }

    func didFinishLoggingIn() {
        setupViewControllers()
    }
    
    func didSaveProfile() {
        setupViewControllers()
    }
    

}
