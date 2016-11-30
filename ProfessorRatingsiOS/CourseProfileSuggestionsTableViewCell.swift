//
//  CourseProfileSuggestionsTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/26/16.
//
//  CourseProfileSuggestionsTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CourseProfileSuggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var sugDate: UILabel!
    @IBOutlet weak var sugAgreeLabel: UILabel!
    @IBOutlet weak var sugAgree: UIButton!
    var suggestionObject: Suggestions?
    var liked = false
    
    @IBAction func sugLikePressed(_ sender: AnyObject) {
        if(!liked){
            print("like Button pressed 😃")
            likeSuggestion(isLike: true)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sugAgree.setImage(#imageLiteral(resourceName: "Thumbs up"), for: UIControlState.normal)
        suggestionLabel.sizeToFit()
        layoutIfNeeded()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindObject(_ suggestion:Suggestions) {
        suggestionObject = suggestion
        updateUI()
    }
    
    func likeSuggestion(isLike: Bool){
        
        let defaults = UserDefaults.standard
        
        print("user id in likeSugestion is ", defaults.string(forKey: "user_id"))
        
        let params: [String: Any] = [
            "suggestion_id": suggestionObject!.suggestionID,
            "user_id": defaults.string(forKey: "user_id")!,
            ]
        suggestionObject!.agree = suggestionObject!.agree + Int(1)
        liked = true
        
        
        Alamofire.request(Config.suggestionURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            guard response.result.error == nil else {
                print("Error in adding like")
                print(response.result.error)
                return
            }
            if let value = response.result.value {
                let jsonObject = JSON(value)
                //                if !jsonObject["success"].bool!{
                //                    self.showMessage(jsonObject["message"].string!, type: .error)
                self.updateUI()
                //                    return
                //                }
            }
        }
        
    }
    
    func updateUI(){
        suggestionLabel.text = suggestionObject!.suggestion == "" ? "This student did not leave a message." : suggestionObject!.suggestion
        sugDate.text = suggestionObject!.date
        sugAgreeLabel.text = String(suggestionObject!.agree)
    }
    
}
