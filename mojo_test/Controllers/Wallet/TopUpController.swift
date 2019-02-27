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
    
    let topupButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.lineBreakMode=NSLineBreakMode.byWordWrapping
        let attributedTitle = NSMutableAttributedString(string: "5 Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)])
        attributedTitle.append(NSMutableAttributedString(string: "\n$5", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6235294118, green: 0.7960784314, blue: 0.7411764706, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        
        let topupButton1: UIButton = {
            let button = UIButton(type: .system)
            button.titleLabel?.lineBreakMode=NSLineBreakMode.byWordWrapping
            let attributedTitle = NSMutableAttributedString(string: "5 Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)])
            attributedTitle.append(NSMutableAttributedString(string: "\n$5", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6235294118, green: 0.7960784314, blue: 0.7411764706, alpha: 1)]))
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.borderColor = #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 2
            return button
        }()
        
        let topupButton2: UIButton = {
            let button = UIButton(type: .system)
            button.titleLabel?.lineBreakMode=NSLineBreakMode.byWordWrapping
            let attributedTitle = NSMutableAttributedString(string: "5 Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)])
            attributedTitle.append(NSMutableAttributedString(string: "\n$5", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6235294118, green: 0.7960784314, blue: 0.7411764706, alpha: 1)]))
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.borderColor = #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 2
            return button
        }()
        
        let topupButton3: UIButton = {
            let button = UIButton(type: .system)
            button.titleLabel?.lineBreakMode=NSLineBreakMode.byWordWrapping
            let attributedTitle = NSMutableAttributedString(string: "5 Jo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)])
            attributedTitle.append(NSMutableAttributedString(string: "\n$5", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6235294118, green: 0.7960784314, blue: 0.7411764706, alpha: 1)]))
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.borderColor = #colorLiteral(red: 0.07450980392, green: 0.5607843137, blue: 0.2745098039, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 2
            return button
        }()
        
        sv.addArrangedSubview(topupButton1)
        sv.addArrangedSubview(topupButton2)
        sv.addArrangedSubview(topupButton3)
        
        topupButton1.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 3/10).isActive = true
        topupButton2.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 3/10).isActive = true
        topupButton3.widthAnchor.constraint(equalTo: sv.widthAnchor, multiplier: 3/10).isActive = true
        
        sv.distribution = .equalSpacing
        
        return sv
    }()
    
    let amountlabel: UILabel = {
        let label = UILabel()
        label.text = "Other amount"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        containerView.backgroundColor = .white
        
        let JoLabel = UILabel()
        JoLabel.text = "Jo"
        JoLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        containerView.addSubview(JoLabel)
        JoLabel.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 8, right: 0))
        
        let textField = UITextField()
        textField.placeholder = "custom amount..."
        containerView.addSubview(textField)
        textField.anchor(top: nil, leading: JoLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        textField.centerYAnchor.constraint(equalTo: JoLabel.centerYAnchor).isActive = true
        
        let usdLabel = UILabel()
        usdLabel.text = "$ 0.00"
        usdLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        usdLabel.textColor = .lightGray
        containerView.addSubview(usdLabel)
        usdLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 36))
        usdLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        containerView.addSubview(lineView)
        lineView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor)
        lineView.widthAnchor.constraint(equalToConstant: containerView.frame.width).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm to pay", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Top up"
        
        setupLayout()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    func setupLayout() {
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 56, left: 0, bottom: 0, right: 0))
        balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(userBalanceLabel)
        userBalanceLabel.anchor(top: balanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        userBalanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(dollarBalanceLabel)
        dollarBalanceLabel.anchor(top: userBalanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        dollarBalanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(topupLabel)
        topupLabel.anchor(top: dollarBalanceLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 56, left: 24, bottom: 0, right: 0))
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: topupLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: view.frame.width, height: 56))
        
        view.addSubview(amountlabel)
        amountlabel.anchor(top: buttonStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 24, bottom: 0, right: 0))
        view.addSubview(containerView)
        containerView.anchor(top: amountlabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: view.frame.width, height: 50))
        
        view.addSubview(payButton)
        payButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 48))
        
    }

}
