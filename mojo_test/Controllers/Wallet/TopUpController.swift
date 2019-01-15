//
//  TopUpController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/10/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class TopUpController: UIViewController {
    
    var user: User? {
        didSet {
            
        }
    }
    
    fileprivate let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    fileprivate let userBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "10 Mojo Coin"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    fileprivate let dollarBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "$10.00"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    fileprivate let topupLabel: UILabel = {
        let label = UILabel()
        label.text = "Top up"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
//    static func createTopupButton(text: Int) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFill
//        return button
//    }
    
//    fileprivate let topupButton: UIButton {
//        let button = UIButton(type: .system)
//        button.setAttributedTitle(NSMutableAttributedString(string: "5 Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.strokeColor : UIC)]), for: .normal
//        return button
//    }()
    
    let topupButtons: UIStackView = {
        let sv = UIStackView()
        
        
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Balance Top Up"
        
        setupLayout()
        
    }
    
    func setupLayout() {
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 56, left: 0, bottom: 0, right: 0))
        balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(userBalanceLabel)
        userBalanceLabel.anchor(top: balanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        userBalanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(dollarBalanceLabel)
        dollarBalanceLabel.anchor(top: userBalanceLabel.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        dollarBalanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(topupLabel)
        topupLabel.anchor(top: dollarBalanceLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 56, left: 24, bottom: 0, right: 0))
        
        
    }

}
