//
//  GradientView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/9/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class CurrentUserPhotoView: UIView {
    
    var user: User! {
        didSet{
            userSwipingPhotosController.user = self.user
        }
    }
    
    let userSwipingPhotosController = CurUserSwipingPhotoController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        let userSwipingView = userSwipingPhotosController.view!

        addSubview(userSwipingView)
        userSwipingView.fillSuperview()
        
        setupGradientLayer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor,UIColor.clear.cgColor, UIColor.black.cgColor,]
        gradientLayer.locations = [-0.2, 0.2, 0.6,1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
}
