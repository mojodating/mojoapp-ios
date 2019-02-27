//
//  ProfileCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

protocol ProfileCellDelegate {
    func didTapChat(user: User)
}

class ProfileCell: UICollectionViewCell {
    
    var delegate: ProfileCellDelegate?
    
    var cardViewModel: CardViewModel!
    var user: User? {
        didSet {
//            self.cardViewModel = user?.toCardViewModel()
//            self.infoLabel.attributedText = cardViewModel.attributedString
//            swipingPhotosController.cardViewModel = self.cardViewModel
            cardView.cardViewModel = user?.toCardViewModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.dropShadow()
        
        setupLayout()
        
    }
    
    let cardView = CardView(frame: .zero)
    
    fileprivate func setupLayout() {
        
        addSubview(cardView)
        cardView.layer.cornerRadius = 16
        cardView.fillSuperview()
        cardView.chatButton.isHidden = true
        cardView.gestureRecognizers?.forEach(cardView.removeGestureRecognizer)

        addSubview(cosmosView)
        cosmosView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 152, right: 0))
        addSubview(chatButton)
        chatButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 4, right: 16), size: .init(width: 80, height: 36))
        chatButton.centerYAnchor.constraint(equalToSystemSpacingBelow: cosmosView.centerYAnchor, multiplier: 1).isActive = true
        
        chatButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        chatButton.setTitleColor(.black, for: .normal)
        chatButton.addTarget(self, action: #selector(handleChatRequest), for: .touchUpInside)
        
        
    }
    @objc fileprivate func handleChatRequest() {
        guard let user = self.user else { return }
        self.delegate?.didTapChat(user: user)
    }

    lazy var chatButton = UIButton(title: "CHAT", cornerRadius: 18, font: .systemFont(ofSize: 14, weight: .bold))
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.filledImage = #imageLiteral(resourceName: "filled-star").withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = #imageLiteral(resourceName: "empty-star").withRenderingMode(.alwaysOriginal)
        view.settings.starSize = 32
        view.settings.starMargin = 2
        view.settings.fillMode = .full
        view.rating = 0
        return view
    }()
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 18
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
