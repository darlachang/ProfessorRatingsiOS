//
//  CourseProfileTableViewCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/17/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class CourseProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingAmt: UILabel!
    @IBOutlet weak var ratingTitle: UILabel!
    @IBOutlet weak var ratingNum: UILabel!
    var ratingObject: Course!
    enum ratingRow{
        case overalQual, workLoad, grading
    }
    var selectRow: ratingRow = .overalQual
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let course = ratingObject{
            print("ratingObject's object", ratingObject.overalQualCnt)
            
            switch selectRow{
            case .overalQual:
                if let rating = course.overalQualCnt{
                    let qualChart = RatingBar.init(values: rating, color: PR_Colors.lightGreen, space: 2, frame:CGRect(x: 180, y: 70, width: 130, height: 70))
                    addSubview(qualChart)

                }
                break
            case .workLoad:
                if let work = course.workloadCnt{
                    let workloadChart = RatingBar.init(values: work, color: PR_Colors.lightGreen, space: 2, frame:CGRect(x: 180, y: 70, width: 130, height: 70))
                    addSubview(workloadChart)
                }

                break
            case .grading:
                if let grade = course.gradingCnt{
                    let gradingChart = RatingBar.init(values: grade, color: PR_Colors.lightGreen, space: 2, frame:CGRect(x: 180, y: 70, width: 130, height: 70))
                    addSubview(gradingChart)
                }
                break
                
            }
            

        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
