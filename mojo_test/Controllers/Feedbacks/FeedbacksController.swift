//
//  FeedbacksController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 1/21/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class FeedbacksController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let reviewCellId = "reviewCellId"
    let feedbackCellId = "feedbackCellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        navigationItem.title = "Feedbacks"
        
        collectionView.register(UserReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
        collectionView.register(FeedbackPollCell.self, forCellWithReuseIdentifier: feedbackCellId)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
            return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedbackCellId, for: indexPath) as! FeedbackPollCell
            cell.backgroundColor = .white
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! UserReviewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: 60)
        }
        return CGSize(width: view.frame.width, height: 150)
    }

}


