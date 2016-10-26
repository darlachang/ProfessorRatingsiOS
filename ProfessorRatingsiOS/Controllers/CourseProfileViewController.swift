//
//  CourseProfileViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/17/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CourseProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var RatingsList:[String] = ["Overal Quality", "Workload", "Grading"]
    var RatingsNum:[String] = ["3.7", "4.2", "2.8"]
    var RatingsAmount:[Int] = [382, 380, 260]
    var CommentsDate:[String] = ["12/24/2016","12/8/2016","11/23/2016", "", "",""]
    var CommentsList:[String] = ["This course is really intersting", "The professor is a brilliant, the assignments were challenging though", "This course is aweful"]
    var CommentsStudent:[String] = ["Freshman, History major, Graded received: B+","Sophomore, Mechanical major, Graded received: A-","Senior, Animation major, Graded received: C+"]
    var CommentsRating:[String] = ["5", "4", "1"]
    var CommentsAgree:[Int] = [23, 25, 0]
    var CommentsDisagree:[Int] = [7, 5, 10]
    var QuotesList:[String] = ["Finish before deadline is impossible", "If you take the practicum"]
    
    var courseInfo: Course!
    var commentInfo: [Comments] = []
    
    @IBOutlet var cidLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    
    @IBOutlet weak var otherProfessorView: UIView!
    @IBOutlet weak var right_arrow: UIButton!
    
    @IBOutlet weak var Review: UIButton!
    
    @IBOutlet weak var courseSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var profileTableView: UITableView!
    //    var state:cellstate = .rating
    //
    //    @IBOutlet weak var ratings: UIButton!
    //    @IBOutlet weak var comments: UIButton!
    //
    //    @IBAction func ratingact(_ sender: AnyObject) {
    //        comments.isSelected = false
    //        ratings.isSelected = true
    //    }
    //    @IBAction func commentsact(_ sender: AnyObject) {
    //
    //        state = .comments
    //    }
    
    //var courseinfo = []
    
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0);     UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();     UIGraphicsEndImageContext();
        return image!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("name of course is", courseInfo.name, "and its id is ", courseInfo.id, "the whole courseinfo is", courseInfo)
        getcourseinfo()
        // request method: http://mive.us/reviews?course_id=5807c8567ccbad2219679d50
        // http://mive.us/courses?course_id=5807c8567ccbad2219679d50
        
        cidLabel.text = courseInfo.id
        cidLabel.textColor = PR_Colors.lightGreen
        nameLabel.text = courseInfo.name
        professorLabel.text = courseInfo.professor.name
        
        Review.layer.borderColor = PR_Colors.brightOrange.cgColor
        Review.layer.borderWidth = 1.0
        Review.layer.cornerRadius = 10
        
        
        
        
        //        let courseSegmentControl = UISegmentedControl (items: ["Ratings & Tag", "Comments", "Quotes"])
        //        courseSegmentControl.frame = CGRect.init(x: 10, y: 150, width: 300, height: 30)
        courseSegmentedControl.selectedSegmentIndex = 0
        courseSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        courseSegmentedControl.tintColor = PR_Colors.lightGreen
        //        courseSegmentedControl.backgroundColor = PR_Colors.lightGreen
        
        //        ratings.setTitleColor(UIColor.green, for: .normal)
        //        ratings.setTitleColor(UIColor.blue, for: .selected)
        //        ratings.setBackgroundImage(self.imageWithColor(UIColor.gray), for: .selected)
        
        
        // ratings.isSelected  //is a boolean
        otherProfessorView.addBorder(edges: .top, colour: PR_Colors.lightGreen, thickness: 1.0)
        getCommentInfo()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        var returnValue = 0
        switch(courseSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = 3
            break
        case 1:
            print("count of commentInfo = ", commentInfo.count)
            returnValue = 3 //commentInfo.count
            break
        case 2:
            returnValue = 3
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch(courseSegmentedControl.selectedSegmentIndex){
            
        case 0:
            let cellIdentifier = "courseprofileCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseProfileTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.ratingTitle.text = RatingsList[0] //overal quality
                cell.ratingNum.text = String(self.courseInfo.avgReview!)
                cell.ratingAmt.text = String(self.courseInfo.numOfReview!)  + " ratings"
                
            case 1:
                cell.ratingTitle.text = RatingsList[1] //workload
                if let a = self.courseInfo.workloadString {
                    cell.ratingNum.text =  a
                    
                }
                //cell.ratingAmt.text = "\(RatingsAmount[1]) ratings"
                
            case 2:
                cell.ratingTitle.text = RatingsList[2] //grading
                if let b = self.courseInfo.gradingString{
                    cell.ratingNum.text = b
                }
                cell.ratingNum.text = self.courseInfo.gradingString
                //cell.ratingAmt.text = "\(RatingsAmount[2]) ratings"
                
            default:
                break
            }
            return cell
            
            
        case 1:
            let cellIdentifier = "commentsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseProfileCommentsTableViewCell
            cell.addBorder(edges: .top, colour: PR_Colors.lightGreen)
            
            //            let comment = self.commentInfo[indexPath.row]
            // cell.comment.text = self.commentInfo[indexPath.row].comment
            //            cell.setStarCount(count: comment.stdRating)
            cell.student.text = "student A"
            cell.date.text = "12/16/2016"
            cell.starCount = 3
            cell.displayStars()
            return cell
            
        case 2:
            //            let cellIdentifier = "courseprofileCell"
            //            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            //            cell.textLabel!.text = QuotesList[indexPath.row]
            //            return cell
            return UITableViewCell()
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func SegmentedValueChanged(_ sender: AnyObject) {
        profileTableView.reloadData()
    }
    
    
    func getcourseinfo() {
        let params:[String: Any] = [
            "courseID" : courseInfo.db_id
        ]
        Alamofire.request(Config.courseURL, method: .get, parameters: params,encoding: URLEncoding.default).responseJSON {
            (response) in
            if let value = response.result.value {
                print("getcourseinfo")
                let jsonObject = JSON(value)
                self.courseInfo.overalQual = jsonObject["quality"].double!
                self.courseInfo.overalQualCnt = jsonObject["quality_count"].arrayObject as! [Int]? //use arrayObject[Any] cuz the type inside is not JSON
                self.courseInfo.workload = jsonObject["workload"].double!
                self.courseInfo.workloadCnt = jsonObject["workload_count"].arrayObject as! [Int]?
                self.courseInfo.grading = jsonObject["grading"].double!
                self.courseInfo.gradingCnt = jsonObject["grading_count"].arrayObject as! [Int]?
            }
            self.profileTableView.reloadData() //reload tableView
            
        }
    }
    
    func getCommentInfo() {
        let params:[String: Any] = [
            "courseID" : courseInfo.db_id
        ]
        Alamofire.request(Config.reviewURL, method: .get, parameters: params,encoding: URLEncoding.default).responseJSON {
            (response) in
            if let value = response.result.value {
                print("get comment info")
                self.commentInfo = []
                let jsonObject = JSON(value)
                if let commentinfos = jsonObject.array{
                    for cominfo in commentinfos{
                        self.commentInfo.append(Comments.init(
                            comment:cominfo["comment"].stringValue,
                            student:"",
                            date:"",
                            agree:cominfo["like_count"].int!,
                            disagree:cominfo["dislike_count"].int!,
                            stdRating:cominfo["rating"].int!
                        ))
                    }
                }
                self.profileTableView.reloadData() //reload tableView
            }
        }
    }
    
    func submitReview(){
        let storyboard = UIStoryboard(name: "submitReview", bundle: nil)
        let submitReviewController = storyboard.instantiateViewController(withIdentifier: "SubmitReviewViewController") as! SubmitReviewViewController
        submitReviewController.professor = courseInfo.professor
        submitReviewController.course = courseInfo
        self.navigationController?.pushViewController(submitReviewController, animated: true)
    }
    
    
    @IBAction func ReviewPressed(_ sender: AnyObject) {
        self.submitReview()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

