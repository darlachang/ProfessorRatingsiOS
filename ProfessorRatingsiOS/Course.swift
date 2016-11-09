//
//  Course.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/2/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import Foundation
import CoreData

class Course {
    
    var db_id:String!
    var name:String!
    var id:String!
    var professor:Professor!
    var department:String!
    var avgReview:Double?
    var numOfReview:Int!
    var overalQual:Double?
    var overalQualCnt:[Int]?
    var workload:Double?
    var workloadCnt:[Int]?
    var grading:Double?
    var gradingCnt:[Int]?

    
    convenience init(db_id: String, name:String, id:String, professor:Professor, department:String, avgReview:Double, numOfReview:Int) {

            self.init()
            self.db_id = db_id
            self.name = name
            self.id = id
            self.professor = professor
            self.department = department
            self.avgReview = avgReview
            self.numOfReview = numOfReview
        }
    
    var workloadString:String? {
        if self.workload == nil {
            return nil
        }
        let workload = round(self.workload!)
        switch workload {
         
        case 0:
            return "no data"
        case 1:
            return "much greater"
        case 2:
            return "greater"
        case 3:
            return "similar"
        case 4:
            return "less"
        case 5:
            return "much less"
        default:
            break
        }
        
        return ""
    }
    
    var gradingString:String? {
        if self.grading == nil {
            return nil
        }
        let grading = round(self.grading!)
        switch grading {
        
        case 0:
            return "no data"
        case 1:
            return "very tough"
        case 2:
            return "tough"
        case 3:
            return "average"
        case 4:
            return "easy"
        case 5:
            return "very easy"
        default:
            break
        }
        
        return ""
    }
    

}
