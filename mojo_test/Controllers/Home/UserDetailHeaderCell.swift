//
//  UserDetailHeaderCell.swift
//  mojo_test
//
//  Created by Yunyun Chen on 3/11/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class UserDetailHeaderCell: UICollectionViewCell {
    
    var cardViewModel: CardViewModel!
    var user: User? {
        didSet {
            cardViewModel = user?.toCardViewModel()
            self.swipingController.cardViewModel = self.cardViewModel
        }
    }
    
    let swipingController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let swipingPhotoView = swipingController.view!
        addSubview(swipingPhotoView)
        swipingPhotoView.fillSuperview()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
