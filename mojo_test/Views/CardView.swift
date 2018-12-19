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
    func didTapChatButton(cardViewModel: CardViewModel)
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
            
            (0..<cardViewModel.imageUrls.count).forEach{ (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = {[weak self] (idx, imageUrl) in
            print ("changing photo from view model")
//            if let url = URL(string: imageUrl ?? "") {
//                self?.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo-3x"), options: .continueInBackground)
//            }
            
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
            
    //encapsulation
    fileprivate let swipingPhotosController =   SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    //configuration
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer (target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
//    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    @objc fileprivate func handleTap(gesture:UITapGestureRecognizer){
        print("Handling tap and cycling photos")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "chatbutton-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlChatRequest), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handlChatRequest() {
        print("Present chat request window")
        delegate?.didTapChatButton(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupLayout() {
        
        clipsToBounds = true
        //custom code
        
        let swipingPhotosView = swipingPhotosController.view!

        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
//        setupBarsStackView()
        
        //add gradient layer
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 96, right: 24))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
//        addSubview(chatButton)
    }
    
    let barsStackView = UIStackView()
   
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor , bottom: nil, trailing: trailingAnchor, padding: .init(top: 48, left: 160, bottom: 0, right:160), size: .init(width:0, height:4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradientLayer() {

        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor,UIColor.clear.cgColor, UIColor.black.cgColor,]
        gradientLayer.locations = [-0.2, 0.2, 0.6,1.1]
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

