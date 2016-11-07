//
//  SubmitReviewViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 10/4/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON
import GSMessages

class SubmitReviewViewController: FormViewController {

    var professor:Professor!
    var course:Course!

    enum fields:String {
        case
        prof_id = "prof_id",
        course_id = "course_id",
        comment = "comment",
        grading_difficulty = "grading_difficulty",
        grade_received = "grade_received",
        rating = "rating",
        tags = "tags",
        work_load = "work_load",
        show_major = "show_major",
        show_year = "show_year"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTitle()
        buildForm()
        
    }
    
    func setUpTitle() {
        // TODO make sure these are set in prepare for segue
        navigationItem.title = "\(course.id!) by \(professor.name!)"
    }
    
    func buildForm() {
        form +++ Section()
            <<< StickySliderViewRow(fields.rating.rawValue){
                $0.value = StickySliderContent(
                    leftText: "1",
                    rightText: "5",
                    title: "Rate Your Professor",
                    step: 1,
                    lowerValue: 1,
                    higherValue: 5,
                    value: 3,
                    showValue: true)
            }
            <<< StickySliderViewRow(fields.work_load.rawValue){
                $0.value = StickySliderContent(
                    leftText: "Lighter", rightText: "Heavier", title: "Workload compare to other classes", step: 1, lowerValue: 1, higherValue: 5, value: 3, showValue: false)
            }
            <<< StickySliderViewRow(fields.grading_difficulty.rawValue){
                $0.value = StickySliderContent(
                    leftText: "Easy", rightText: "Difficult", title: "Grading", step: 1, lowerValue: 1, higherValue: 5, value: 3, showValue: false)
            }
            +++ Section("What would you like to tell somebody who wants to take this test?")
            <<< TextAreaRow(fields.comment.rawValue) {row in
                row.value = ""
            }
            +++ Section()
            <<< AlertRow<String>(fields.grade_received.rawValue){ row in
                row.title = "Grade Received"
                row.value = ""
                row.options = ["A","B","C","D","E","F"]
            }
            
            +++ Section("Show my rater information")
            <<< SwitchRow(fields.show_major.rawValue) {
                $0.title = "Major"
                $0.value = true
            }
            <<< SwitchRow(fields.show_year.rawValue) {
                $0.title = "Year Of School"
                $0.value = true
            }
            <<< ButtonRow() { row in
                row.title = "SAVE"
                row.onCellSelection({ (buttonCell, buttonRow) in
                    self.save()
                })
            }.cellSetup({ (cell, row) in
                let bgColorView = UIView()
                bgColorView.backgroundColor = PR_Colors.lightGreen
                cell.selectedBackgroundView = bgColorView
                cell.tintColor = PR_Colors.lightGreen
            })
    }
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        save()
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func save(){
        var params: [String: Any] = [
            fields.course_id.rawValue : course.db_id!,
            fields.rating.rawValue : (form.rowBy(tag: fields.rating.rawValue) as! StickySliderViewRow).value!.value,
            fields.work_load.rawValue : (form.rowBy(tag: fields.work_load.rawValue) as! StickySliderViewRow).value!.value,
            fields.grading_difficulty.rawValue : (form.rowBy(tag: fields.grading_difficulty.rawValue) as! StickySliderViewRow).value!.value,
            fields.comment.rawValue : (form.rowBy(tag: fields.comment.rawValue) as! TextAreaRow).value!,
            fields.grade_received.rawValue : (form.rowBy(tag: fields.grade_received.rawValue) as! AlertRow<String>).value!,
            fields.tags.rawValue : [],
            fields.show_major.rawValue : (form.rowBy(tag: fields.show_major.rawValue) as! SwitchRow).value!,
            fields.show_year.rawValue : (form.rowBy(tag: fields.show_year.rawValue) as! SwitchRow).value!,
        ]
        
        Alamofire.request(Config.reviewURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            guard response.result.error == nil else {
                print("Error while submitting review")
                print(response.result.error)
                return
            }
            if let value = response.result.value {
                let jsonObject = JSON(value)
                if let success = jsonObject["success"].bool {
                    if !success {
                        self.showMessage(jsonObject["message"].string!, type: .error)
                        return
                    } else {
                        self.navigationController!.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
}
