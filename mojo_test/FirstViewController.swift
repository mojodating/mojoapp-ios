//
//  FirstViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/28/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    //MARK: properties
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        profileImage.isUserInteractionEnabled = true
        
        let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swiftUp.direction = UISwipeGestureRecognizer.Direction.up
        profileImage.addGestureRecognizer(swiftUp)
    }
    
    //MARK: actions

    @objc func swipeGesture(sendr:UISwipeGestureRecognizer) {
        if let swipeGesture = sendr as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up:
                print("Swipe Up")
                profileImage.image = UIImage(named:"2")
            default:
                break
            }
        }
    }
}

