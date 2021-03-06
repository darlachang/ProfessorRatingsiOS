//
//  SearchTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/2/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cidLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    @IBOutlet var avgReviewLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
