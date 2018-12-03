//
//  FourthViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/29/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let cardsDeckView = UIView()
    let topStackView = TopNavigationStackView()
    let buttonStackView = HomeBottomControlStackView()
    
    let cardViewModels = [
        User(name: "Peter Dinklage", age: 40, profession: "hand of the King", imageName: "5").toCardViewModel(),
        User(name: "Magic Max", age: 23, profession: "dancer", imageName: "2").toCardViewModel()
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(cardsDeckView)
        cardsDeckView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        setupDummyCards()
        
        cardsDeckView.addSubview(topStackView)
        cardsDeckView.addSubview(buttonStackView)
        
        topStackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        buttonStackView.frame = .init(x: view.frame.size.width - 48, y:view.frame.size.height - 403 , width: 48, height: 403)
    
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach {(cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.informationLabel.attributedText = cardVM.attributedString
            cardView.informationLabel.textAlignment = cardVM.textAlignment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview ()
        }
        
    }
            
}
        

    



