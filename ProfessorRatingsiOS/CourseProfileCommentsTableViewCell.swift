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
        if (!liked && !disliked){
            likeComment(isLike: true)
        }
    }
    
    @IBAction func dislikePressed(_ sender: AnyObject) {
        if(!disliked && !liked){
            likeComment(isLike: false)
        }
        
    }
    var starCount = 0
    var commentObject:Comments?
    let starTag = 1000
    let GREY_OUT_THRESHOLD = 0.6
    let greyStar = convertImageToBW(image: #imageLiteral(resourceName: "filled_star"))
    let greyEmptyStar = convertImageToBW(image: #imageLiteral(resourceName: "empty_star"))
    var liked = false
    var disliked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Agree.setImage(#imageLiteral(resourceName: "Thumbs up"), for: UIControlState.normal)
        Disagree.setImage(#imageLiteral(resourceName: "Thumbs down"), for: UIControlState.normal)
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

        if isFilled {
            if needGreyOut {
                newStar.layer.contents = greyStar.cgImage
            } else {
                newStar.layer.contents = #imageLiteral(resourceName: "filled_star").cgImage
            }
        } else {
            if needGreyOut {
                newStar.layer.contents = greyEmptyStar.cgImage
            } else {
                newStar.layer.contents = #imageLiteral(resourceName: "empty_star").cgImage
            }
        
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
            liked = true
        } else {
            commentObject!.disagree = commentObject!.disagree + Int(1)
            disliked = true
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
        commentLabel.text = commentObject!.comment == "" ? "This student did not leave a message." : commentObject!.comment
        date.text = commentObject!.date
        student.text = "Student"//commentObject!.stdStatus + "," + commentObject!.stdMajor
        agreeLabel.text = String(commentObject!.agree)
        disagreeLabel.text = String(commentObject!.disagree)
        starCount = commentObject!.stdRating
        if updateStar{
            displayStars()
        }
        if (needGreyOut) {
            greyOut()
        } else {
            normalColor()
        }
    }
    
    func normalColor() {
        
        commentLabel.textColor = UIColor.black
        agreeLabel.textColor = PR_Colors.lightGreen
        disagreeLabel.textColor = PR_Colors.brightOrange
        Agree.setImage(#imageLiteral(resourceName: "Thumbs up"), for: UIControlState.normal)
        Disagree.setImage(#imageLiteral(resourceName: "Thumbs down"), for: UIControlState.normal)
    }
    
    func greyOut(){
        commentLabel.textColor = UIColor.lightGray
        agreeLabel.textColor = UIColor.lightGray
        disagreeLabel.textColor = UIColor.lightGray
        Agree.setImage(#imageLiteral(resourceName: "grey thumbs up"), for: UIControlState.normal)
        Disagree.setImage(#imageLiteral(resourceName: "grey thumbs down"), for: UIControlState.normal)
    }
    
    var needGreyOut: Bool {
        get {
            if commentObject == nil {
                return false
            }
            let totalLikeCount = Double(commentObject!.agree + commentObject!.disagree)
            let percentage = (totalLikeCount == 0) ? 0 : (Double(commentObject!.disagree)) / totalLikeCount
            return totalLikeCount > 8 && percentage > GREY_OUT_THRESHOLD
        }
    }

}
