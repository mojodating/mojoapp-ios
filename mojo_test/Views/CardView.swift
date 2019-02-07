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
    
    func handleChatRequest(cardViewModel: CardViewModel)
    
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
            userProfileView.loadImageUsingCacheWithUrlString(urlString: cardViewModel.imageUrls.first ?? "")
            
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
    fileprivate let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    //configuration
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer (target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    
//    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    
    let userProfileView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    let chatRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "chat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleChatRequest), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc fileprivate func handleChatRequest() {

        self.delegate?.handleChatRequest(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupLayout() {
        
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!

        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
        //add gradient layer
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 16, bottom: 48, right: 0))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        addSubview(chatRequestButton)
        chatRequestButton.anchor(top: nil, leading: nil, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 180, right: 8), size: .init(width: 40, height: 40))
        
        addSubview(userProfileView)
        userProfileView.anchor(top: nil, leading: nil, bottom: chatRequestButton.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 44, height: 44))
        userProfileView.centerXAnchor.constraint(equalTo: chatRequestButton.centerXAnchor).isActive =  true
        
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

