//
//  Extensions+Catches.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/16/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!,completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
//            if url?.absoluteString != self.lastURLUsedToLoadImage { return }
            
            DispatchQueue.global(qos: .userInitiated).async  {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage

                }
                
            }
            
        }).resume()
    }
}
