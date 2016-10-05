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
    
    var name:String = ""
    var cid:String?
    var professor:String = ""
    var department:String = ""
    var avgReview:Double = 0.0
    var numOfReview:Int = 0
 

    
    convenience init(name:String, cid:String, professor:String, department:String, avgReview:Double, numOfReview:Int) {

            self.init()
            self.name = name
            self.cid = cid
            self.professor = professor
            self.department = department
            self.avgReview = avgReview
            self.numOfReview = numOfReview
        }
}
