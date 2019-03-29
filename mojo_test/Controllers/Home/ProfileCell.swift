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
import SDWebImage

protocol ProfileCellDelegate {
    func didTapChat(user: User)
    func didTapProfileImage(user: User)
}

class ProfileCell: UICollectionViewCell {
    
    var delegate: ProfileCellDelegate?
    
    var cardViewModel: CardViewModel!
    var user: User? {
        didSet {
            cardView.cardViewModel = user?.toCardViewModel()
            guard let profileImageUrl = user?.imageUrl1 else { return }
            if let url = URL(string: profileImageUrl) {
                profileImageView.sd_setImage(with: url)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        
    }
    
    let cardView = CardView(frame: .zero)
    let badge = UIImageView(image: #imageLiteral(resourceName: "popular"))
    
    fileprivate func setupLayout() {
        
        addSubview(cardView)
        cardView.layer.cornerRadius = 16
        cardView.fillSuperview()

        addSubview(cosmosView)
        cosmosView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 122, right: 0))
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 48, height: 48))
        profileImageView.centerYAnchor.constraint(equalToSystemSpacingBelow: cosmosView.centerYAnchor, multiplier: 1).isActive = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOpenProfileDetail))
        singleTap.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(singleTap)
        
        addSubview(chatButton)
        chatButton.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        chatButton.centerXAnchor.constraint(equalToSystemSpacingAfter: profileImageView.centerXAnchor, multiplier: 1).isActive = true
        chatButton.addTarget(self, action: #selector(handleChatRequest), for: .touchUpInside)
        chatButton.setImage(#imageLiteral(resourceName: "chat-1").withRenderingMode(.alwaysOriginal), for: .normal)
        
    }
    @objc fileprivate func handleChatRequest() {
        guard let user = self.user else { return }
        self.delegate?.didTapChat(user: user)
    }
    
    @objc fileprivate func handleOpenProfileDetail() {
        guard let user = self.user else { return }
        self.delegate?.didTapProfileImage(user: user)
    }
    
    lazy var profileImageView = UIImageView(cornerRadius: 24)

    lazy var chatButton = UIButton(type: .system)
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
