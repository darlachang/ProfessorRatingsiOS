//
//  Comments.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/25/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class Comments: UITableViewCell {
    
    var comment:String!
    var student:String!
    var date:String!
    var agree:Int!
    var disagree:Int!
    var stdRating:Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shorten(_ date: String) -> String{
       // let string = date
        let index = date.characters.index(of: "T")
        if let i = index {
            return date.substring(to: i)
        }
        return date
    }
    
    convenience init(comment: String, student:String, date:String, agree:Int, disagree:Int, stdRating:Int) {
        
        self.init()
        self.comment = comment
        self.student = student
        self.date = shorten(date)
        self.agree = agree
        self.disagree = disagree
        self.stdRating = stdRating
    }
}
