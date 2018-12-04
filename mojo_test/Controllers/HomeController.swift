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
    
    let cardViewModels :  [CardViewModel] = {
        let producers = [
            User(name: "Peter Dinklage", age: 40, profession: "hand of the King", imageNames: ["4", "4-2", "4-3"]),
            User(name: "Magic Max", age: 23, profession: "dancer", imageNames: ["2"]),
            InHouseUser(name: "Jordan Wolf", age: 46, profession: "Wolf in Wall Street", imageNames: "1")
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
    
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
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview ()
        }
        
    }
            
}
        

    



