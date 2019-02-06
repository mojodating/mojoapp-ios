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
    
    var feedbacks = [Conversation]()
    
    fileprivate func fetchChatUsers() {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(currentUID)
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                
                guard let dictionaries = document.data() else { return }
                guard let dictionary = dictionaries["conversations"] as? [String : Any] else { return }
                dictionary.forEach({ (key, value) in
                    
                    guard let conv = value as? [String: Any] else {return}
                    //
                    let conversation = Conversation(conv: conv)
                    if (conversation.accepted) {
                        
                        self.feedbacks.append(conversation)
                    }
                    self.collectionView.reloadData()
                })
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    let reviewCellId = "reviewCellId"
    let feedbackCellId = "feedbackCellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        navigationItem.title = "Feedbacks"
        
        fetchChatUsers()
        
        collectionView.register(UserReviewCell.self, forCellWithReuseIdentifier: reviewCellId)
        collectionView.register(FeedbackPollCell.self, forCellWithReuseIdentifier: feedbackCellId)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return feedbacks.count
        }
            return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedbackCellId, for: indexPath) as! FeedbackPollCell
            cell.backgroundColor = .white
            cell.conversation = feedbacks[indexPath.item]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! UserReviewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: 60)
        }
        return CGSize(width: view.frame.width, height: 176)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let controller = UserDetailFeedbackController()
            let conversation = self.feedbacks[indexPath.row]
            controller.conversation = conversation
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

}


