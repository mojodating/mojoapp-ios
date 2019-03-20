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
    var inviteCode: String?{ didSet{checkInvitedUser()}}
    
    func checkInvitedUser() {
        let ref = Firestore.firestore().collection("users").whereField("invitationCode", isEqualTo: self.inviteCode ?? "")
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.inviteCode = user.uid
                })
            }
        }
    }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil && isValidEmail(testStr: email ?? "") && isValidPassword(testStr: password ?? "")
        
        bindableIsFormValid.value = isFormValid
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let passwordRegEx = "^(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: testStr)
    }
    
    lazy var functions = Functions.functions()
    
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
    var user: User?
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
            "insideHouse": false,
            "invitedBy": inviteCode ?? ""
        ]
        
        functions.httpsCallable("editUserData").call(docData) { (result, error) in
            self.bindableIsRegistering.value = false
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            completion(nil)
        }
    }

}
