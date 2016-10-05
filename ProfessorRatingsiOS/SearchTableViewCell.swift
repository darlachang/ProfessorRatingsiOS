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

    override func awakeFromNib() {
        super.awakeFromNib()
        print("searchhere")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
