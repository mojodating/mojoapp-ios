//
//  RegistrationViewModel.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/4/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable <UIImage> ()
    var bindableIsFormValid = Bindable<Bool> ()

    
    var fullName: String? {
        didSet{
            checkFormValidity()
        } }
    var email: String? { didSet{ checkFormValidity() } }
    var password: String? { didSet{ checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {return}
    
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) {
            (res, err) in
            
            if let err = err {
                completion(err)
                return
            }
            print("sucessfully registered user", res?.user.uid ?? "")
            
            self.saveImageToFirebase(completion: completion)
        }

    }
    
    //only upload images to firebase storage once you are authorized
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/image/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return // bail
            }
            
            print ("Fnished uploading image to storage")
            ref.downloadURL(completion: {(url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                print("Download url of our image size:", url?.absoluteString ?? "")
                //store the download url in firebase
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl:String, completion:@escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let docData: [String: Any] = [
            "fullname": fullName ?? "",
            "uid": uid,
            "imageUrl1":imageUrl,
            "age": 18,
            "profileImageUrl": imageUrl,
            "minSeekingAge": EditProfileController.defaultMinSeekingAge,
            "maxSeekingAge": EditProfileController.defaultMaxSeekingAge,
            "insideHouse": false
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) {(err) in
            self.bindableIsRegistering.value = false
            if let err = err {
                completion(err)
                return
            }
            
            completion(nil)
        }
    }


}
