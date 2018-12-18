//
//  ChatRequestController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/11/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class ChatRequestController: UIViewController {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "peter")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Say Hi to Peter!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "MENU"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your balance: 30 Jo"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.isOpaque = false
        
        setupLayout()
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    fileprivate func setupLayout() {
        
        let menuSwipingView = swipingPhotosController.view!
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 24, left: 24, bottom: 8, right: 8), size: .init(width: 80, height: 32))
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: cancelButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 32, left: 24, bottom: 16, right: 8), size: .init(width: 64, height: 64))
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 24, bottom: 16, right: 24))
        
        view.addSubview(menuSwipingView)
        menuSwipingView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 32, right: 16) , size: .init(width: view.frame.width, height: view.frame.width))
        
        view.addSubview(menuLabel)
        menuLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: menuSwipingView.topAnchor, trailing: nil, padding: .init(top: 8, left: 24, bottom: 16, right: 16))
        
        view.addSubview(balanceLabel)
        balanceLabel.anchor(top: nil, leading: nil, bottom:menuSwipingView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 16, right: 24))
        
        
    }


}
