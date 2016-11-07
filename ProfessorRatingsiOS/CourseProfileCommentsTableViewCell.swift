//
//  CourseProfileCommentsTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/17/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CourseProfileCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var student: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var Agree: UIButton!
    @IBOutlet weak var disagreeLabel: UILabel!
    @IBOutlet weak var Disagree: UIButton!
    @IBOutlet weak var endStar: UIView!

    @IBAction func likePressed(_ sender: AnyObject) {
        likeComment(isLike: true)
    }
    
    @IBAction func dislikePressed(_ sender: AnyObject) {
        likeComment(isLike: false)
    }
    var starCount = 0
    var commentObject:Comments?
    let starTag = 1000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Agree.isHidden = true
        //Disagree.isHidden = true
        //agreeLabel.isHidden = true
        //disagreeLabel.isHidden = true
        Agree.layer.borderWidth = 1.0
        Agree.layer.borderColor = PR_Colors.brightOrange.cgColor
        Agree.layer.cornerRadius = 10
        Disagree.layer.borderWidth = 1.0
        Disagree.layer.borderColor = PR_Colors.lightGreen.cgColor
        Disagree.layer.cornerRadius = 10
        
        commentLabel.sizeToFit()
        layoutIfNeeded()
        displayStars()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayStars() {
        self.layoutIfNeeded() //layout first, give us their location. w/o this the stars don't know their exact locations.
        for offset in 0..<5 {
            let stag = starTag + offset //star's tag.
            self.viewWithTag(stag)?.removeFromSuperview()
        }
        let count = starCount
        var currentStar = endStar
        var position:CGPoint = endStar.superview!.convert(endStar!.center, to: self)
        position.x -= currentStar!.frame.width/2
        position.y -= currentStar!.frame.height/2
        let space = 2
        
        for offset in 0 ..< (5-count) {
            // Apply empty star
            currentStar = addStar(position: position, size: currentStar!.frame.size, isFilled: false, tag: starTag + offset)
            position.x = position.x - currentStar!.frame.width - CGFloat(space)
        }
        
        for offset in 5-count ..< 5 {
            currentStar = addStar(position: position, size: currentStar!.frame.size, isFilled: true, tag: starTag + offset )
            position.x = position.x - currentStar!.frame.width - CGFloat(space)
        }
    }
    
    func addStar(position: CGPoint, size: CGSize, isFilled: Bool, tag: Int) -> UIView{
        let newStar = UIView()
        newStar.tag = tag //every view has its tag.
        let rect = CGRect(origin: position, size: size)
        newStar.frame = rect
//        UIGraphicsBeginImageContext(size)
//
//        if isFilled {
//            #imageLiteral(resourceName: "filled_star").draw(in: rect)
//        } else {
//            #imageLiteral(resourceName: "empty_star").draw(in: rect)
//        }
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        newStar.backgroundColor = UIColor(patternImage: image!)
        if isFilled {
            newStar.layer.contents = #imageLiteral(resourceName: "filled_star").cgImage
        } else {
            newStar.layer.contents = #imageLiteral(resourceName: "empty_star").cgImage
        }
        self.addSubview(newStar)
        return newStar
    }
    
    func likeComment(isLike: Bool){
        let defaults = UserDefaults.standard
        
        print("user id in likeComment is ", defaults.string(forKey: "user_id"))
        
        let params: [String: Any] = [
            "review_id": commentObject!.commentID,
            "user_id": defaults.string(forKey: "user_id")!,
            "like": isLike ? 1 : 0
        ]
        if isLike {
            commentObject!.agree = commentObject!.agree + Int(1)
        } else {
            commentObject!.disagree = commentObject!.disagree + Int(1)
        }
        
        Alamofire.request(Config.likeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
                self.updateUI(updateStar: false)
//                    return
//                }
            }
        }
    }
    
    func bindObject(_ comment:Comments) {
        commentObject = comment
        updateUI(updateStar: true)
    }
    
    func updateUI(updateStar :Bool){
        commentLabel.text = commentObject!.comment
        date.text = commentObject!.date
        student.text = "Senior, Electrical Engineer, A+"
        agreeLabel.text = String(commentObject!.agree)
        disagreeLabel.text = String(commentObject!.disagree)
        starCount = commentObject!.stdRating
        if updateStar{
            displayStars()
        }
    }

}
