//
//  RegistrationViewModel.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/4/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable <UIImage> ()
    
//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }
//    var imageObserver:((UIImage?) -> ())?
    
    var fullName: String? {
        didSet{
            checkFormValidity()
        } }
    var email: String? { didSet{ checkFormValidity() } }
    var password: String? { didSet{ checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
//        isFormValidObserver?(isFormValid)
    } 

    var bindableIsFormValid = Bindable<Bool >()
    //reactive programming
//    var isFormValidObserver:((Bool) ->())?

    
}

