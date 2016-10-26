//
//  CourseProfileCommentsTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/17/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class CourseProfileCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var student: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var Agree: UIButton!
    @IBOutlet weak var disagreeLabel: UILabel!
    @IBOutlet weak var Disagree: UIButton!
    @IBOutlet weak var endStar: UIView!
    
    var starCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Agree.isHidden = true
        Disagree.isHidden = true
        agreeLabel.isHidden = true
        disagreeLabel.isHidden = true
        Agree.layer.borderWidth = 1.0
        Agree.layer.borderColor = PR_Colors.brightOrange.cgColor
        Agree.layer.cornerRadius = 10
        Disagree.layer.borderWidth = 1.0
        Disagree.layer.borderColor = PR_Colors.brightOrange.cgColor
        Disagree.layer.cornerRadius = 10
        
        comment.sizeToFit()
        layoutIfNeeded()
        displayStars()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayStars() {
        let count = starCount
        var currentStar = endStar
        var position:CGPoint = currentStar!.superview!.convert(currentStar!.center, to: self)
        position.x -= currentStar!.frame.width/2
        position.y -= currentStar!.frame.height/2
        let space = 2
        
        for _ in 0 ..< (5-count) {
            // Apply empty star
            currentStar = addStar(position: position, size: currentStar!.frame.size, isFilled: false)
            position.x = position.x - currentStar!.frame.width - CGFloat(space)
        }
        
        for _ in 0 ..< count {
            currentStar = addStar(position: position, size: currentStar!.frame.size, isFilled: true)
            position.x = position.x - currentStar!.frame.width - CGFloat(space)
        }
    }
    
    func addStar(position: CGPoint, size: CGSize, isFilled: Bool) -> UIView{
        let newStar = UIView()
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
    
}
