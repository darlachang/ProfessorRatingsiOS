//
//  UserProfileTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 11/29/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 5
        editButton.layer.borderColor = PR_Colors.lightGreen.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindContent(titleText:String?, contentText:String?, showEditButton: Bool) {
        if let tt = titleText {
            title.text = tt
            title.isHidden = false
        } else {
            title.isHidden = true
        }
        if let ct = contentText {
            content.text = ct
            content.isHidden = false
        } else {
            content.isHidden = true
        }
        
        editButton.isHidden = !showEditButton
    }

}
