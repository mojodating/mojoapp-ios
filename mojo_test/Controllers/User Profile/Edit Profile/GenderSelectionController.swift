//
//  GenderSelectionController.swift
//  mojo_test
//
//  Created by Yunyun Chen on 2/4/19.
//  Copyright © 2019 Yunyun Chen. All rights reserved.
//

import UIKit

class GenderSelectionController: UITableViewController {
    
    let genders = ["Men", "Woman", "Other"]
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "My Gender"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectionCell(style: .default, reuseIdentifier: "cellId")
        cell.titleLabel.text = genders[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row:\(indexPath.row)")
        
        if indexPath.row == 0 {
            
        }
    }

}

class SelectionCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 18))
    let checkImage = UIImageView(image: #imageLiteral(resourceName: "first"))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 16, left: 24, bottom: 16, right: 0))
        
        addSubview(checkImage)
        checkImage.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 18, height: 18))
        checkImage.centerYAnchor.constraint(equalToSystemSpacingBelow: self.centerYAnchor, multiplier: 1).isActive = true
        checkImage.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
