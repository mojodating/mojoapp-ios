//
//  HomeBottomControlStackView.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/1/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import TinyConstraints

class HomeBottomControlStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.filledImage = #imageLiteral(resourceName: "filled-star").withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = #imageLiteral(resourceName: "empty-star").withRenderingMode(.alwaysOriginal)
        view.settings.starSize = 32
        view.settings.starMargin = 4
        view.settings.fillMode = .full
        view.rating = 0
        return view
    }()
    
    
//    let profileThumbnail = createButton(image: #imageLiteral(resourceName: "profile"))
    let chatButton = createButton(image: #imageLiteral(resourceName: "chatbutton-1"))
    let refreshButton = createButton(image: #imageLiteral(resourceName: "review-1"))
    
    override init (frame: CGRect) {
        super.init(frame:frame)
        axis = .vertical
        distribution = .equalSpacing
        alignment = .trailing
        
        [refreshButton, cosmosView].forEach{(button) in
            self.addArrangedSubview(button)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 0, bottom: 16, right: 8)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
