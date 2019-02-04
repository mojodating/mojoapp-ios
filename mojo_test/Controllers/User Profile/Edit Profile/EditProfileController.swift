  //
//  SettingsControllerTableViewController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 12/5/18.
//  Copyright © 2018 Yunyun Chen. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage
  
  protocol editProfileControllerDelegate {
     func didSaveProfile()
  }
  
  class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
  }
  
  class EditProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: editProfileControllerDelegate?

    
    //instance properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image4Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image5Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image6Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto (button:UIButton) {
        print("Select photo with button:", button)
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/image/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {
            return
        }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) {
            (nil, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload image to storage", err)
                return
            }
            
            print("Finished uploading image")
            ref.downloadURL(completion: { (url, err) in
                hud.dismiss()
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                
                print("Finished gettng download url:", url?.absoluteString ?? "")
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else if imageButton == self.image3Button {
                    self.user?.imageUrl3 = url?.absoluteString
                } else if imageButton == self.image4Button {
                    self.user?.imageUrl4 = url?.absoluteString
                } else if imageButton == self.image5Button {
                    self.user?.imageUrl5 = url?.absoluteString
                } else {
                    self.user?.imageUrl6 = url?.absoluteString
                }
                    
            })
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addPhoto").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
//        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {
                (image, _, _, _, _, _)
                in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {
                (image, _, _, _, _, _)
                in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {
                (image, _, _, _, _, _)
                in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl4, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {
                (image, _, _, _, _, _)
                in
                self.image4Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl5, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {
                (image, _, _, _, _, _)
                in
                self.image5Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl6, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {
                (image, _, _, _, _, _)
                in
                self.image6Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

    }
    
    
    lazy var header: UIView = {
        let header = UIView()
//        header.backgroundColor = .white
        let padding: CGFloat = 16
        
        let photoRow1StackView = UIStackView(arrangedSubviews: [image1Button, image2Button, image3Button])
        photoRow1StackView.distribution = .fillEqually
        photoRow1StackView.spacing = padding
        
        header.addSubview(photoRow1StackView)
        photoRow1StackView.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: nil, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        photoRow1StackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let photoRow2StackView = UIStackView(arrangedSubviews: [image4Button, image5Button, image6Button])
        photoRow2StackView.distribution = .fillEqually
        photoRow2StackView.spacing = padding
        
        header.addSubview(photoRow2StackView)
        photoRow2StackView.anchor(top: photoRow1StackView.bottomAnchor, leading: header.leadingAnchor, bottom: nil, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        photoRow2StackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.9319355397, green: 0.9319355397, blue: 0.9319355397, alpha: 1)
        header.addSubview(separatorView)
        separatorView.anchor(top: nil, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy:0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Full name"
        case 2:
            headerLabel.text = "Age"
        case 3:
            headerLabel.text = "Profession"
        case 4:
            headerLabel.text = "School"
        case 5:
            headerLabel.text = "Location"
        case 6:
            headerLabel.text = "I identify my gender as ..."
        case 7:
            headerLabel.text = "Show me gender of ..."
        default:
            headerLabel.text = "Show me age of ..."
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)

        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 450
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1

    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {

        evaluateMinMax()
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {

        evaluateMinMax()
    }
    
    fileprivate func evaluateMinMax() {
        guard let ageRangeCell = tableView.cellForRow(at: [5, 0]) as? AgeRangeCell else { return }
        let minValue = Int(ageRangeCell.minSlider.value)
        var maxValue = Int(ageRangeCell.maxSlider.value)
        maxValue = max(minValue, maxValue)
        ageRangeCell.maxSlider.value = Float(maxValue)
        ageRangeCell.minLabel.text = "Min \(minValue)"
        ageRangeCell.maxLabel.text = "Max \(maxValue)"
        
        user?.minSeekingAge = minValue
        user?.maxSeekingAge = maxValue 
    }
    
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 50
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // age range cell
        if indexPath.section == 8 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            
            // we need to set up the labels on our cell here
            let minAge = user?.minSeekingAge ?? EditProfileController.defaultMinSeekingAge
            let maxAge = user?.maxSeekingAge ?? EditProfileController.defaultMaxSeekingAge
            
            ageRangeCell.minLabel.text = "Min \(minAge)"
            ageRangeCell.maxLabel.text = "Max \(maxAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxSlider.value = Float(maxAge)
            return ageRangeCell
        }
        
        if indexPath.section == 5 {
            let locationCell = EditProfileSelectionCell(style: .default, reuseIdentifier: nil)
            
            return locationCell
        }
        
        if indexPath.section == 6 {
            let genderCell = EditProfileSelectionCell(style: .default, reuseIdentifier: nil)
            
            return genderCell
        }

        if indexPath.section == 7 {
            let genderPrederenceCell = EditProfileSelectionCell(style: .default, reuseIdentifier: nil)
            return genderPrederenceCell
        }

        let cell = EditProfileCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter your full name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter your age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        case 3:
            cell.textField.placeholder = "Enter your profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "Enter your school"
            cell.textField.text = user?.school
            cell.textField.addTarget(self, action: #selector(handleSchoolChange), for: .editingChanged)
        default:
            print("")
        }
            
        return cell        
    }
    
    
    fileprivate func openGenderSelection() {
        
        let genderSelctionController = GenderSelectionController()
        
        navigationController?.pushViewController(genderSelctionController, animated: true)
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    @objc fileprivate func handleSchoolChange(textField: UITextField) {
        self.user?.school = textField.text
    }
    
    @objc fileprivate func handleCountryChange(textField: UITextField) {
        self.user?.location = textField.text
    }

    fileprivate func setupNavigationItem() {
        navigationItem.title = "Edit Profile"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleSave() {
        print("saving our settings")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String: Any] = [
            "uid": uid,
            "fullname": user?.name ?? "",
            "age": user?.age ?? -1,
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "imageUrl4": user?.imageUrl4 ?? "",
            "imageUrl5": user?.imageUrl5 ?? "",
            "imageUrl6": user?.imageUrl6 ?? "",
            "profession": user?.profession ?? "",
            "school": user?.school ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge":user?.maxSeekingAge ?? -1
            
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving profile"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).updateData(docData) {
            (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings", err)
                return
            }
            print ("Finished saving user info")
                print ("dismissal complete")
     
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                
                mainTabBarController.setupViewControllers()
                
                self.dismiss(animated: true, completion: {
                    self.delegate?.didSaveProfile()
                })
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
