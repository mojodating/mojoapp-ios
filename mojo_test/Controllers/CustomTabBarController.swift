//
//  CustomTabBarController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/12/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //setup our custom view controllers
        
        let homeController = HomeController()
        homeController.tabBarItem.title = "HOME"
        homeController.tabBarItem.image = #imageLiteral(resourceName: "first")
        
//        let layout = UICollectionViewFlowLayout()
//        let chatController = ChatController(collectionViewLayout: layout)
//        let navController = UINavigationController(rootViewController: chatController)
        
        let messagesController = MessagesController()
        let navController = UINavigationController(rootViewController: messagesController)
        navController.tabBarItem.title = "CHAT"
        navController.tabBarItem.image = #imageLiteral(resourceName: "first")
        
//        let walletController = WalletController()
//        walletController.tabBarItem.title = "WALLET"
//        homeController.tabBarItem.image = #imageLiteral(resourceName: "first")
//        let meController = MeController()
//        meController.tabBarItem.title = "ME"
//        homeController.tabBarItem.image = #imageLiteral(resourceName: "first")
        
        viewControllers = [homeController, navController, createDummyControllerWithTitles(title: "WALLET", imageName: "first"), createDummyControllerWithTitles(title: "ME", imageName: "first")]
    }
    
    private func createDummyControllerWithTitles(title:String, imageName: String) -> UIViewController {
        let viewController = UIViewController()
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: imageName)
        return viewController
    }
}
