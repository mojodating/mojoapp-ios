//
//  FourthViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/29/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
    
    let cardsDeckView = UIView()
    let topStackView = TopNavigationStackView()
    let buttonStackView = HomeBottomControlStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardsDeckView)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        setupDummyCards()
        
        let contentStackView = UIStackView(arrangedSubviews: [topStackView, buttonStackView])
            contentStackView.axis = .vertical
            contentStackView.distribution = .equalSpacing
        
        
            cardsDeckView.addSubview(contentStackView)
        contentStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)

    }
    
    fileprivate func setupDummyCards() {
        print("dummy cards")
        let cardView = CardView(frame : .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
        
    }
    
}


