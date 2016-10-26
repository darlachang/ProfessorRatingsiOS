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
    @IBOutlet weak var ratingStar: UIImageView!
    
    @IBOutlet weak var endStar: UIView!
    
    var starCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingStar.isHidden = true
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
        
        displayStars()
        
        
        //        let label = UILabel()
        //        label.frame = CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        //       self.contentView.addSubview(label)
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayStars() {
        let count = starCount
        var currentStar = endStar
        var point = currentStar!.superview!.convert(currentStar!.center, to: self)
        var x = point.x
        let y = point.y
        let space = 5
        
        for i in 0 ..< (5-count) {
            // Apply empty star
            currentStar = addStar(x: x, y: y, size: currentStar!.frame.size, isFilled: false)
            x = x - currentStar!.frame.width - CGFloat(space)
        }
        
        for i in 0 ..< count {
            currentStar = addStar(x: x, y: y, size: currentStar!.frame.size, isFilled: true)
            x = x - currentStar!.frame.width
        }
    }
    
    func addStar(x: CGFloat, y: CGFloat, size: CGSize, isFilled: Bool) -> UIView{
        let newStar = UIView()
        let point = CGPoint(x: x, y: y)
        let rect = CGRect(origin: point, size: size)
        newStar.frame = rect
        UIGraphicsBeginImageContext(size)
        
        if isFilled {
            #imageLiteral(resourceName: "filled_star").draw(in: rect)
        } else {
            #imageLiteral(resourceName: "empty_star").draw(in: rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        newStar.backgroundColor = UIColor(patternImage: image!)
        UIGraphicsEndImageContext()
        self.addSubview(newStar)
        return newStar
    }
    
}
