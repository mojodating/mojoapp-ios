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
    let titles = ["REQUEST", "SENT"]
    
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
        
        let x = CGFloat(indexPath.item) * frame.width / 2
        lightLightBarLeftAnchor?.constant = x
        
        chatRequestCell?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: cellId)
        
        let selectedInexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedInexPath as IndexPath, animated: false, scrollPosition: .right)
        
    }
    
    var lightLightBarLeftAnchor: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuBarCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 14))
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.black : UIColor.lightGray
//            titleLabel.backgroundColor = isSelected ? UIColor.init(red: 1, green: 0.8980392157, blue: 0.3529411765, alpha: 1) : UIColor.white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0))
//        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.textColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

