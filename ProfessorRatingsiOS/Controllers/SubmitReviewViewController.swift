//
//  SubmitReviewViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 10/4/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Eureka

class SubmitReviewViewController: FormViewController {

    var professor:Professor!
    var course:Course!
    
    enum fields:String {
        case
        score = "score",
        workload = "workload",
        grading = "grading"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTitle()
        buildForm()
        
    }
    
    func setUpTitle() {
        // TODO make sure these are set in prepare for segue
        //navigationItem.title = "\(course.id) by \n \(professor.name)"
    }
    
    func buildForm() {
        form +++ Section()
            <<< StickySliderViewRow("score"){
                $0.value = StickySliderContent(
                    leftText: "1",
                    rightText: "5",
                    title: "Rate Your Professor",
                    step: 1,
                    lowerValue: 0,
                    higherValue: 4,
                    value: 2)
            }
            <<< StickySliderViewRow("workload"){
                $0.value = StickySliderContent(
                    leftText: "Lighter", rightText: "Heavier", title: "Workload compare to other classes", step: 1, lowerValue: 0, higherValue: 4, value: 2)
            }
            <<< StickySliderViewRow("grading"){
                $0.value = StickySliderContent(
                    leftText: "Easy", rightText: "Difficult", title: "Grading", step: 1, lowerValue: 0, higherValue: 4, value: 2)
            }
            +++ Section("What would you like to tell somebody who wants to take this test?")
            <<< TextAreaRow("tell_others")
            +++ Section()
            <<< AlertRow<String>("grade"){ row in
                row.title = "Grade Received"
                row.options = ["A","B","C","D","E","F"]
            }
            
            +++ Section("Show my rater information")
            <<< SwitchRow("major") {
                $0.title = "Major"
                $0.value = true
            }
            <<< SwitchRow("Year Of School") {
                $0.title = "Year Of School"
                $0.value = true
            }
    }
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        print("Save button pressed")
        let result: [String: Any] = [
            "score" : (form.rowBy(tag: "score") as! StickySliderViewRow).value!.value
        ]
        print(result)
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        print("Cancel button ")
    }
    
}
