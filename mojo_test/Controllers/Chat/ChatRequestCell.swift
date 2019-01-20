//
//  chatRequestCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatRequestCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    let cellId = "cellId"
    let sentCellId = "sentCellId"

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
//
//        menuBar.lightLightBarLeftAnchor?.constant = scrollView.contentOffset.x / 2
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: sentCellId, for: indexPath) as! SentFeedCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RequestsFeedCell
        
        cell.delegate = self as! RequestsFeedCellDelegate
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 224)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
     
        let indexPath = IndexPath(item: menuIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    
//    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupLayout()
        
        
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.chatRequestCell = self
        
        return mb
    }()
    
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 14
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.isScrollEnabled = false
        return cv
    }()
    
    
    func setupLayout() {
        
        addSubview(menuBar)
        menuBar.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 48))
        
        addSubview(collectionView)
        collectionView.anchor(top: menuBar.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        collectionView.register(RequestCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(RequestsFeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SentFeedCell.self, forCellWithReuseIdentifier: sentCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // setup each individual cell in chat request
    

}
