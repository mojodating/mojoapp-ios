//
//  SignupPhotoController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/22/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class SignupPhotoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 36, left: 36, bottom: 0, right: 0))
        
        view.addSubview(uploadPhotoButton)
        uploadPhotoButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 36, right: 24), size: .init(width: view.frame.width, height: 56))
        uploadPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload a fabulous photo of you"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let uploadPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("upload a photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.backgroundColor = #colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)
        return button
    }()


}
