//
//  Comments.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/25/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class Comments: UITableViewCell {
    
    var commentID:String!
    var comment:String!
    var date:String!
    var agree:Int!
    var disagree:Int!
    var stdRating:Int!
    var stdMajor:String!
    var stdYear:String!
    var stdStatus:String!
    
    var popularity:Double {
        get {
            // TODO: Use our popularity algorithm here
            return Double(agree) / Double(agree + disagree)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shorten(_ date: String) -> String{
        let index = date.characters.index(of: "T")
        if let i = index {
            return date.substring(to: i)
        }
        return date
    }
    
    convenience init(commentID: String, comment: String, date:String, agree:Int, disagree:Int, stdRating:Int, stdMajor:String, stdYear:String, stdStatus: String) {
        
        self.init()
        self.commentID = commentID
        self.comment = comment
        self.date = shorten(date)
        self.agree = agree
        self.disagree = disagree
        self.stdRating = stdRating
        self.stdMajor = stdMajor
        self.stdYear = stdYear
        self.stdStatus = stdStatus
    }
    
    func compareToByPopularity(_ anotherComment: Comments) -> Bool{
        if self.popularity == anotherComment.popularity {
            return self.agree > anotherComment.agree
        }
        return self.popularity > anotherComment.popularity
    }
    
}
