//
//  CourseProfileSuggestionsTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit



class CourseProfileSuggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var sugDate: UILabel!
    @IBOutlet weak var sugAgreeLabel: UILabel!
    @IBOutlet weak var sugAgree: UIButton!
    @IBOutlet weak var sugDisagreeLabel: UILabel!
    @IBOutlet weak var sugDisagree: UIButton!
    @IBAction func sugLikePressed(_ sender: AnyObject) {
        print("like Button pressed 😃")
    }
    @IBAction func sugDislikePressed(_ sender: AnyObject) {
        print("dislike button pressed 😏")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sugAgree.setImage(#imageLiteral(resourceName: "Thumbs up"), for: UIControlState.normal)
        sugDisagree.setImage(#imageLiteral(resourceName: "Thumbs down"), for: UIControlState.normal)
        suggestionLabel.sizeToFit()
        layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
