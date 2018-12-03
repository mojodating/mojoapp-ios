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
    
    let users = [
        User(name: "Peter Dinklage", age: 40, profession: "Hand of the King", imageName: "5"),
        User(name: "Magic Max", age: 23, profession: "Dancer", imageName: "2")
    ]
    
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
        users.forEach {(user) in
            let cardView = CardView(frame : .zero)
            cardView.imageView.image = UIImage (named: user.imageName)
            cardView.informationLabel.text = "\(user.name)\(user.age) \n \(user.profession)"
            
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .heavy)])
            
             attributedText.append(NSMutableAttributedString(string: "\n\(user.age) ,", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .regular)]))
            
            attributedText.append(NSMutableAttributedString(string: "\(user.profession)", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .regular)]))
            
            
            cardView.informationLabel.attributedText = attributedText
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
            
        }
        
    }
    



