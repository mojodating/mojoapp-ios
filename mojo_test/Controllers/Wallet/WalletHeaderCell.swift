//
//  WalletHeaderCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/12/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class WalletHeaderCell: UICollectionViewCell {
    
    lazy var functions = Functions.functions()
    func getBalance() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

            self.functions.httpsCallable("getBalance").call(["uid": uid]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        _ = FunctionsErrorCode(rawValue: error.code)
                        _ = error.localizedDescription
                        _ = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                if let balance = (result?.data as? [String: Any])?["balance"] as? Int {
                    self.userBalanceLabel.text = "\(balance) Jo"
                }
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        getBalance()
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        let walletStackView = UIStackView(arrangedSubviews: [
            VerticalStackView(arrangedSubviews: [balanceLabel,userBalanceLabel]),
            topUpButton,
            freeTokenButton
            ])
        
        accountButton.backgroundColor = #colorLiteral(red: 0.9582804569, green: 0.9582804569, blue: 0.9582804569, alpha: 1)
        accountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        topUpButton.setTitleColor(.black, for: .normal)
        topUpButton.backgroundColor = #colorLiteral(red: 0.7864880562, green: 0.9731746316, blue: 0.9783737063, alpha: 1)
        topUpButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        topUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        freeTokenButton.setTitleColor(.black, for: .normal)
        freeTokenButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        freeTokenButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        freeTokenButton.layer.borderWidth = 1
        freeTokenButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        freeTokenButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        walletStackView.spacing = 16
        walletStackView.alignment = .center        
        
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 0.918273579, green: 0.918273579, blue: 0.918273579, alpha: 1)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            walletStackView, accountButton, lineView, titleLabel
            ], spacing: 16)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 24, bottom: 16, right: 24))
        titleLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    let titleLabel = UILabel(text: "YOUR GIFTS", font: .boldSystemFont(ofSize: 14))
    let balanceLabel = UILabel(text: "Balance", font: .systemFont(ofSize: 16))
    let userBalanceLabel = UILabel(text: "Loading...", font: .boldSystemFont(ofSize: 24))
    
    let accountButton = UIButton(title: "Address & Transaction history", cornerRadius: 4, font: .boldSystemFont(ofSize: 14))
    let topUpButton = UIButton(title: "Top up", cornerRadius: 20, font: .systemFont(ofSize: 14, weight: .medium))
    let freeTokenButton = UIButton(title: "Free Tokens", cornerRadius: 20, font: .systemFont(ofSize: 14, weight: .medium))

   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
