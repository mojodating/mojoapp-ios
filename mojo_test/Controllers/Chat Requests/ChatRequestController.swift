//
//  ChatRequestController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/11/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class ChatRequestController: UIViewController {
    
    //Need to create a ChatRequestViewModel
    //Created the cardViewModel for marketplace(digital goods)
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "drink-2"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Say Hi to Username!"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupLayout()
//        setupVisualBlurEffectView()
    }
    
//    fileprivate func setupVisualBlurEffectView() {
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//
//        view.addSubview(visualEffectView)
//        visualEffectView.fillSuperview()
//        view.sendSubviewToBack(visualEffectView)
//
//    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(infoLabel)
        infoLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 16, bottom: 16, right: 16))
        
        view.addSubview(imageView)
        imageView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 32, right: 16) , size: .init(width: view.frame.width, height: view.frame.width))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }


}
