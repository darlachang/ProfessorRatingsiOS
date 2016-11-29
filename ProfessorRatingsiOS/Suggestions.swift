//
//  Suggestions.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/27/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class Suggestions: UITableViewCell {
    
    var course:String!
    var suggestion:String!
    var date:String!
    var agree:Int!
    var disagree:Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shorten(_ date: String) -> String{
        let index = date.characters.index(of:"T")
        if let i = index {
            return date.substring(to: i)
        }
        return date
    }
    
    convenience init(suggestion: String, date: String, agree:Int, disagree:Int){
        self.init()
        self.suggestion = suggestion
        self.date = shorten(date)
        self.agree = agree
        self.disagree = disagree
    }

}
