//
//  chatRequestCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/14/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
protocol ChatRequestCellDelegate {
    func didTapCell(conversation : Conversation)
}

class ChatRequestCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RequestsFeedCellDelegate {
    
    var delegate: ChatRequestCellDelegate?
    
    let cellId = "cellId"
    let sentCellId = "sentCellId"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: sentCellId, for: indexPath) as! SentFeedCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RequestsFeedCell

        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 146)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
     
        let indexPath = IndexPath(item: menuIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func didTapCell(conversation: Conversation) {
        let conversation = conversation
        delegate?.didTapCell(conversation: conversation)
    }
    
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
    
    let titleLabel = UILabel(text: "CHAT", font: .boldSystemFont(ofSize: 14))
    
    func setupLayout() {
        addSubview(menuBar)
        menuBar.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 44))
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        
        addSubview(collectionView)
        collectionView.anchor(top: menuBar.bottomAnchor, leading: self.leadingAnchor, bottom: titleLabel.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 24, right: 0))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(RequestsFeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SentFeedCell.self, forCellWithReuseIdentifier: sentCellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

