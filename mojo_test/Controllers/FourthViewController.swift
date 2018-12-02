//
//  FourthViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 11/29/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

//import Firebase
import UIKit

class FourthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueView = UIView()
        let topStackView = TopNavigationStackView()
        let buttonStackView = HomeBottomControlStackView()
        
        blueView.backgroundColor = .blue
        view.addSubview(blueView)
        blueView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        let contentStackView = UIStackView(arrangedSubviews: [topStackView, buttonStackView])
            contentStackView.axis = .vertical
            contentStackView.distribution = .equalSpacing
        
        
            blueView.addSubview(contentStackView)
        contentStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        


        
//        setupLayout()
        

    }
    
    
    // MARK: -Fileprivate
    
//    fileprivate func setupLayout() {
////        let overallStackView = UIStackView(arrangedSubviews: [blueView])
//////        overallStackView.axis = .vertical
//        view.addSubview(blueView)
//        blueView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
//
//    }
    
}


