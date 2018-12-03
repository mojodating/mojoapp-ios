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
        
        cardsDeckView.addSubview(topStackView)
        cardsDeckView.addSubview(buttonStackView)
        
        topStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        buttonStackView.frame = .init(x: view.frame.size.width - 48, y:view.frame.size.height - 451 , width: 48, height: 451)
    
    }
    
    fileprivate func setupDummyCards() {
        print("dummy cards")
        let cardView = CardView(frame : .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
        
    }
    
}


