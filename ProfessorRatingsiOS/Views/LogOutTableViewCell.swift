//
//  LogOutTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 11/29/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class LogOutTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.layer.borderWidth = 1
        button.tintColor = PR_Colors.brightOrange
        button.layer.borderColor = PR_Colors.brightOrange.cgColor
        button.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func LogOutButtonClicked(_ sender: Any) {
        // Log out
    }
}
