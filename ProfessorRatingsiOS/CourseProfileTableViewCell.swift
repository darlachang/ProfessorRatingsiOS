//
//  CourseProfileTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/17/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class CourseProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingAmt: UILabel!
    @IBOutlet weak var ratingTitle: UILabel!
    @IBOutlet weak var ratingNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
