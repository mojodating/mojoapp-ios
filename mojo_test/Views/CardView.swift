//
//  CardView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/2/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            
            swipingPhotosController.cardViewModel = self.cardViewModel
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment

        }
    }
            
    //encapsulation
    fileprivate let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    //configuration
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
    }
    
    
    fileprivate func setupLayout() {
        
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!

        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
        //add gradient layer
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 24, right: 70))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0

    }
    
    fileprivate func setupGradientLayer() {

        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor,]
        gradientLayer.locations = [0.5,1.2]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        //cardview frame
        gradientLayer.frame = self.frame
    }
    
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let _: CGFloat = translation.y / 20
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let shouldDismissCard = abs (gesture.translation(in: nil).y) > threshold
        
        let translationAnimation = CABasicAnimation(keyPath: "position.y")
        translationAnimation.toValue = -1700
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock({
            self.transform = .identity
            if shouldDismissCard {                
                self.removeFromSuperview()
                self.delegate?.didRemoveCard(cardView: self)
                }
        })
        
        self.layer.add(translationAnimation, forKey: "translation")
        
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

