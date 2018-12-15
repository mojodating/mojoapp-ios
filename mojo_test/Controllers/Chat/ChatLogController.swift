//
//  ChatLogController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/14/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
    }
}
