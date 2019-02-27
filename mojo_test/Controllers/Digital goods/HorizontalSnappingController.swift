//
//  HorizontalSnappingController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/19/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class HorizentalSnappingController: UICollectionViewController {
    init() {
        let layout = snappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class snappingLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        return .zero
    }
}
