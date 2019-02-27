//
//  BaseListController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/15/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
