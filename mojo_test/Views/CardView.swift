//
//  CardView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/2/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "5"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //custom code
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        let panGesture = UIPanGestureRecognizer (target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform (rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: nil)
            self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        case .ended:
            
            let shouldDismissCard = true
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1,initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                if shouldDismissCard {
                    
                    let offScreenTransform = self.transform.translatedBy(x: 1000, y: 0)
                    
                    self.transform = offScreenTransform
                } else {
                   self.transform = .identity
                }
            }) {(_) in                
            }
        default:
            ()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
