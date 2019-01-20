//
//  MenuBar.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/17/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let titles = ["Chat Requests", "Chat Sent"]
    
    var chatRequestCell: ChatRequestCell?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCell
        
        cell.titleLabel.text = titles[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(123)
        
        
//        let x = CGFloat(indexPath.item) * frame.width / 2
//        lightLightBarLeftAnchor?.constant = x
        
        chatRequestCell?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: cellId)
        
        setupHighlightBar()
        
    }
    
    var lightLightBarLeftAnchor: NSLayoutConstraint?
    
    func setupHighlightBar() {
        let hightlightBar = UIView()
        hightlightBar.backgroundColor = .yellow
        addSubview(hightlightBar)
        hightlightBar.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 132, height: 32))
        sendSubviewToBack(hightlightBar)
        
        lightLightBarLeftAnchor = hightlightBar.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        lightLightBarLeftAnchor?.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuBarCell: UICollectionViewCell {
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat Requests"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 138, height: 40))
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
