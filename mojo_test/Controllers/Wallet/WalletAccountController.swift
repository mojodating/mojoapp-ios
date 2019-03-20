//
//  WalletAccountController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/18/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import JGProgressHUD

class WalletAccountController: UIViewController {
    
    var user: User? {
        didSet {
            nameLabel.text = user?.name
            generateQrCode()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Account"
        
        setupLayout()
        
    }
    
    fileprivate func generateQrCode() {
        guard let userAddr = user?.address else { return }
        let data = userAddr.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        let image = UIImage(ciImage: scaledQrImage)
        self.qrcodeImageView.image = image
    }
    
    fileprivate func setupLayout() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 48, left: 0, bottom: 0, right: 0))
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(qrcodeImageView)
        qrcodeImageView.anchor(top: nameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: view.frame.width / 6 * 4))
        qrcodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(qrLabel)
        qrLabel.anchor(top: qrcodeImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48))
        qrLabel.textColor = .darkGray
        qrLabel.textAlignment = .center
        
        view.addSubview(copyAddressButton)
        copyAddressButton.anchor(top: qrLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: 44))
        copyAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyAddressButton.addTarget(self, action: #selector(handleCopyAddress), for: .touchUpInside)
        
        view.addSubview(transactionButton)
        transactionButton.anchor(top: copyAddressButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 6 * 4, height: 44))
        transactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        transactionButton.addTarget(self, action: #selector(handleTransactions), for: .touchUpInside)
        
    }
    
    @objc fileprivate func handleTransactions() {
        let transactionController = TransactionsController()
        navigationController?.pushViewController(transactionController, animated: true)
    }
    
    @objc fileprivate func handleCopyAddress() {
        guard let walletAddress = self.user?.address else { return }
        UIPasteboard.general.string = walletAddress
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Your ethereum address copied to clipboard!"
        hud.show(in: view)
        hud.dismiss(afterDelay: 2)
    }
    
    let qrLabel = UILabel(text: "Scan the QR code to send tokens", font: .systemFont(ofSize: 13))
    let nameLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 24))
    
    let qrcodeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let copyAddressButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Copy wallet address", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    let transactionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View transaction history", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        return btn
    }()


}
