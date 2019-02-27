//
//  ViewProfileController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/5/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class ViewProfileController: UIViewController {
    
    var user: User! 

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        setupCardFromUser(user: user)
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 24), size: .init(width: 24, height: 24))
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        view.addSubview(cardView)
        cardView.fillSuperview()
//        cardView.chatRequestButton.isHidden = true
//        cardView.userProfileView.isHidden = true
        cardView.gestureRecognizers?.forEach(cardView.removeGestureRecognizer)
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleClose() {
        self.dismiss(animated: true)
    }
    

}
