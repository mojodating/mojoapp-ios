//
//  UserController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/8/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class CurUserSwipingPhotoController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers = [UIViewController]()
    var user: User! {
        didSet{
            guard let profileImageUrl1 = self.user.imageUrl1 else { return }
            guard let profileImageUrl2 = self.user.imageUrl2 else { return }
            guard let profileImageUrl3 = self.user.imageUrl3 else { return }
            
            self.controllers = [
                PhotoController(imageUrl: profileImageUrl1),
                PhotoController(imageUrl: profileImageUrl2),
                PhotoController(imageUrl: profileImageUrl3)
            ]
            
            self.setViewControllers([self.controllers.first!], direction: .forward, animated: false)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        view.backgroundColor = .white
        
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers [index - 1]
        
    }
    
    
}

class UserPhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "4-2"))
    
    init(image: UIImage) {
        imageView.image = image
        imageView.clipsToBounds = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
    }
}

