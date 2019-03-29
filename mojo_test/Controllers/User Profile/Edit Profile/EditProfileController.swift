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
    lazy var image1Button = createButton(selector: #selector(handlePhotoOptions))
    lazy var image2Button = createButton(selector: #selector(handlePhotoOptions))
    lazy var image3Button = createButton(selector: #selector(handlePhotoOptions))
    lazy var image4Button = createButton(selector: #selector(handlePhotoOptions))
    lazy var image5Button = createButton(selector: #selector(handlePhotoOptions))
    lazy var image6Button = createButton(selector: #selector(handlePhotoOptions))
    
    @objc fileprivate func handlePhotoOptions(button:UIButton) {
        
        if button.currentImage == nil {
                self.handleSelectPhoto(button:button)
        } else {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Change photo", style: .default, handler: { (_) in
                self.handleSelectPhoto(button:button)
            }))
            alertController.addAction(UIAlertAction(title: "Delete photo", style: .destructive, handler: { (_) in
                self.handleDeletePhoto(button:button)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    fileprivate func handleSelectPhoto (button:UIButton) {
        print("Select photo with button:", button)
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    fileprivate func handleDeletePhoto(button:UIButton) {
        button.setImage(nil, for: .normal)
        
        if button == self.image1Button {
            self.user?.imageUrl1 = ""
        } else if button == self.image2Button {
            self.user?.imageUrl2 = ""
        } else if button == self.image3Button {
            self.user?.imageUrl3 = ""
        } else if button == self.image4Button {
            self.user?.imageUrl4 = ""
        } else if button == self.image5Button {
            self.user?.imageUrl5 = ""
        } else {
            self.user?.imageUrl6 = ""
        }
        self.savePhotoToFirestore()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
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
                self.savePhotoToFirestore()
            })
        }
    }
    
    fileprivate func savePhotoToFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docData: [String: Any] = [
            "imageUrl1": self.user?.imageUrl1 ?? "",
            "imageUrl2": self.user?.imageUrl2 ?? "",
            "imageUrl3": self.user?.imageUrl3 ?? "",
            "imageUrl4": self.user?.imageUrl4 ?? "",
            "imageUrl5": self.user?.imageUrl5 ?? "",
            "imageUrl6": self.user?.imageUrl6 ?? "",
        ]
    
        Firestore.firestore().collection("users").document(uid).updateData(docData) {
            (err) in
            if let err = err {
                print("Failed to save user settings", err)
                return
            }
            print ("Finished saving user photo")
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "addPhoto").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Add", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrentUser()
        setupNavigationItem()
        setupTapGesture()
        setupLogout()
        
        tableView.keyboardDismissMode = .interactive
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
    
    
    fileprivate func setupLogout() {
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        tableView.tableFooterView?.backgroundColor = #colorLiteral(red: 0.9582804569, green: 0.9582804569, blue: 0.9582804569, alpha: 1)
        tableView.tableFooterView?.addSubview(logoutButton)
        logoutButton.fillSuperview()
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    let logoutButton = UIButton(title: "Log out", cornerRadius: 0, font: .systemFont(ofSize: 16, weight: .medium))
    
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
    
    fileprivate func fetchUserData() {
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            self.user = user
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
    
    @objc fileprivate func deletePhoto(button:UIButton) {
        
        print("Delete photo with", button)

    }
    
    
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
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Age"
        case 3:
            headerLabel.text = "Profession"
        case 4:
            headerLabel.text = "School"
        case 5:
            headerLabel.text = "Location"
        case 6:
            headerLabel.text = "About"
        case 7:
            headerLabel.text = "I identify my gender as ..."
        case 8:
            headerLabel.text = "Show me gender of ..."
        default:
            headerLabel.text = "Show me age of ..."
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)

        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 446
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
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
        guard let ageRangeCell = tableView.cellForRow(at: [9, 0]) as? AgeRangeCell else { return }
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
    static let defaultSeekingGender = "All"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // age range cell
        if indexPath.section == 9 {
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
    
        
        if indexPath.section == 7 {
            let genderCell = EditProfileSelectionCell(style: .default, reuseIdentifier: nil)
            genderCell.button.addTarget(self, action: #selector(handleChooseGender), for: .touchUpInside)
            genderCell.button.setTitle(user?.gender ?? "Select gender", for: .normal)
            return genderCell
        }

        if indexPath.section == 8 {
            let genderSeekingCell = EditProfileSelectionCell(style: .default, reuseIdentifier: nil)
            genderSeekingCell.button.addTarget(self, action: #selector(handleGenderSeeking), for: .touchUpInside)
            genderSeekingCell.button.setTitle(user?.genderSeeking ?? "Select...", for: .normal)
            return genderSeekingCell
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
        case 5:
            cell.textField.placeholder = "City, Country"
            cell.textField.text = user?.location
            cell.textField.addTarget(self, action: #selector(handleLocationChange), for: .editingChanged)
        case 6:
            cell.textField.placeholder = "About.."
            cell.textField.text = user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        default:
            print("")
        }
            
        return cell        
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleChooseGender() {
        let genderSelctionController = GenderSelectionController()
        navigationController?.pushViewController(genderSelctionController, animated: true)
    }
    @objc fileprivate func handleGenderSeeking() {
        let genderSeekingController = GenderSeekingController()
        navigationController?.pushViewController(genderSeekingController, animated: true)
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
    @objc fileprivate func handleLocationChange(textField: UITextField) {
        self.user?.location = textField.text
    }
    @objc fileprivate func handleBioChange(textField: UITextField) {
        self.user?.bio = textField.text
    }

    fileprivate func setupNavigationItem() {
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
    let hud = JGProgressHUD(style: .dark)
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let docData: [String: Any] = [
            "imageUrl1": self.user?.imageUrl1 ?? "",
            "uid": uid,
            "fullname": self.user?.name ?? "",
            "age": self.user?.age ?? -1,
            "profession": self.user?.profession ?? "",
            "school": self.user?.school ?? "",
            "gender": self.user?.gender ?? "",
            "location": self.user?.location ?? "",
            "bio": self.user?.bio ?? "",
            "minSeekingAge": self.user?.minSeekingAge ?? -1,
            "maxSeekingAge":self.user?.maxSeekingAge ?? -1
        ]
        
        if (user?.imageUrl1 != "" && user?.name != "" && user?.gender != "") {
            hud.textLabel.text = "Saving profile"
            hud.show(in: view)
            
            Firestore.firestore().collection("users").document(uid).updateData(docData) {
                (err) in
                self.hud.dismiss()
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
        } else {
            hud.textLabel.text = "First photo, name and gender can't be empty"
            hud.show(in: view)
            hud.dismiss(afterDelay: 3)
        }
        
    }

}
