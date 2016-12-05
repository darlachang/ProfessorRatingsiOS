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

protocol SortbyCellDelegate {
    func sortbyClicked(button: UIButton)
}

protocol WriteSuggestionDelegte {
    func toWriteSuggestionPage(textfield : UITextField)
}


class CourseProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SortbyCellDelegate, WriteSuggestionDelegte{
    
    
    
    var RatingsList:[String] = ["Overal Quality", "Workload", "Grading"]
    var courseInfo = Course()
    var commentInfo: [Comments] = []
    var suggestionsInfo: [Suggestions] = []
    
    var isSortedBy: String! = "Time"
    var refreshControl: UIRefreshControl!
    var timer: Timer!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    @IBOutlet weak var otherProfessorView: UIView!
    @IBOutlet weak var Review: UIButton!
    @IBOutlet weak var courseSegmentedControl: UISegmentedControl!
    @IBOutlet weak var profileTableView: UITableView!
    
    //var courseinfo = []
    let SCORE = 0
    let COMMENT = 1
    let SUGGESTION = 2
    
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0);     UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();     UIGraphicsEndImageContext();
        return image!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCommentInfo()
        getsuggestionInfo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getcourseinfo()
        // request method: http://mive.us/reviews?course_id=5807c8567ccbad2219679d50
        // http://mive.us/courses?course_id=5807c8567ccbad2219679d50
        
        self.title = courseInfo.id
        //        cidLabel.text = courseInfo.id
        //        cidLabel.textColor = PR_Colors.lightGreen
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
        setUpOtherProfessorsView()
        getCommentInfo()
        getsuggestionInfo()
        refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(doSomething(Sender:)), for: UIControlEvents.valueChanged)
        profileTableView.addSubview(refreshControl)
        
    }
    func doSomething(Sender:AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(CourseProfileViewController.endOfWork), userInfo: nil, repeats: true)
    }
    
    func endOfWork() {
        if courseSegmentedControl.selectedSegmentIndex == COMMENT{
            getCommentInfo()
        }
        else if courseSegmentedControl.selectedSegmentIndex == SUGGESTION{
            getsuggestionInfo()
        }
        refreshControl.endRefreshing()
        timer.invalidate()
        timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(courseSegmentedControl.selectedSegmentIndex)
        {
        case COMMENT:
            let sortBy = SortByHeader.init(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
            sortBy.sortbyTitle = isSortedBy
            sortBy.delegate = self
            sortBy.backgroundColor = UIColor.white
            return sortBy
            
        case SUGGESTION:
            let writeSuggestion = writeSuggestionHeader.init(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
            writeSuggestion.delegate = self
            return writeSuggestion
        default:
            break
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(courseSegmentedControl.selectedSegmentIndex)
        {
        case SCORE:
            return 0
        case COMMENT:
            return 50
        case SUGGESTION:
            return 70
        default: break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        var returnValue = 0
        switch(courseSegmentedControl.selectedSegmentIndex)
        {
        case SCORE:
            returnValue = 3
            break
        case COMMENT:
            returnValue = commentInfo.count
            break
        case SUGGESTION:
            returnValue = suggestionsInfo.count
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(courseSegmentedControl.selectedSegmentIndex){
            
        case SCORE:
            let cellIdentifier = "courseprofileCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseProfileTableViewCell
            cell.ratingObject = self.courseInfo
            switch indexPath.row {
            case 0:
                cell.ratingTitle.text = RatingsList[0] //overal quality
                cell.ratingNum.text = String(self.courseInfo.avgReview!.roundTo(places: 1))
                cell.ratingAmt.text = String(self.courseInfo.numOfReview!)  + " ratings"
                cell.selectRow = .overalQual
            case 1:
                cell.ratingTitle.text = RatingsList[1] //workload
                if let a = self.courseInfo.workloadString {
                    cell.ratingNum.text =  a
                }
                cell.selectRow = .workLoad
                //cell.ratingAmt.text = "\(RatingsAmount[1]) ratings"
                
            case 2:
                cell.ratingTitle.text = RatingsList[2] //grading
                if let b = self.courseInfo.gradingString{
                    cell.ratingNum.text = b
                }
                cell.selectRow = .grading
                cell.ratingNum.text = self.courseInfo.gradingString
                
                
            default:
                break
            }
            return cell
            
            
        case COMMENT:
            //            if indexPath.row == 0 {
            //                let cellIdentifier = "SortByCell"
            //                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SortbyCell
            //                cell.delegate = self
            //                return cell
            //            }
            let cellIdentifier = "commentsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseProfileCommentsTableViewCell
            cell.addBorder(edges: .top, colour: PR_Colors.lightGreen)
            // let comment = self.commentInfo[indexPath.row - 1]
            let comment = self.commentInfo[indexPath.row]
            cell.bindObject(comment)
            return cell
            
        case SUGGESTION:
            let cellIdentifier = "suggestionsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseProfileSuggestionsTableViewCell
            // cell.addBorder(edges: .top, colour: PR_Colors.lightGreen)
            let suggestion = self.suggestionsInfo[indexPath.row]
            cell.bindObject(suggestion)
            return cell
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
                let jsonObject = JSON(value)
                self.courseInfo.avgReview = jsonObject["average_review"].double!
                self.courseInfo.overalQualCnt = jsonObject["quality_count"].arrayObject as! [Int]? //use arrayObject[Any] cuz the type inside is not JSON
                self.courseInfo.workload = jsonObject["workload"].double!
                self.courseInfo.workloadCnt = jsonObject["workload_count"].arrayObject as! [Int]?
                self.courseInfo.grading = jsonObject["grading"].double!
                self.courseInfo.gradingCnt = jsonObject["grading_count"].arrayObject as! [Int]?
                self.courseInfo.numOfReview = jsonObject["number_of_reviews"].intValue
            }
            self.profileTableView.reloadData() //reload tableView
        }
    }
    
    func getCommentInfo() {
        let params:[String: Any] = [
            "course_id" : courseInfo.db_id
        ]
        Alamofire.request(Config.reviewURL, method: .get, parameters: params,encoding: URLEncoding.default).responseJSON {
            (response) in
            if let value = response.result.value {
                self.commentInfo = []
                let jsonObject = JSON(value)
                if let commentinfos = jsonObject.array{
                    for cominfo in commentinfos{
                        self.commentInfo.append(Comments.init(
                            commentID:cominfo["_id"].stringValue,
                            comment:cominfo["comment"].stringValue,
                            date:cominfo["date"].stringValue,
                            agree:cominfo["like_count"].int!,
                            disagree:cominfo["dislike_count"].int!,
                            stdRating:cominfo["rating"].int!,
                            stdMajor:cominfo["user"]["major"].stringValue,
                            stdYear:cominfo["user"]["year"].stringValue,
                            stdStatus:cominfo["user"]["status"].stringValue
                        ))
                    }
                }
                self.sortByPopularity()
            }
        }
        
    }
    
    func getsuggestionInfo(){
        let params:[String: Any] = [
            "course_id" : courseInfo.db_id
        ]
        Alamofire.request(Config.suggestionURL, method: .get, parameters: params,encoding: URLEncoding.default).responseJSON {
            (response) in
            if let value = response.result.value {
                self.suggestionsInfo = []
                let jsonObject = JSON(value)
                if let suggestioninfos = jsonObject.array{
                    for suginfo in suggestioninfos{
                        self.suggestionsInfo.append(Suggestions.init(
                            suggestionID:suginfo["_id"].stringValue,
                            suggestion:suginfo["content"].stringValue,
                            date:suginfo["date"].stringValue,
                            agree:suginfo["up_votes"].int!
                        ))
                    }
                }
                self.profileTableView.reloadData() //reload tableView
            }//(suggestionID: String, suggestion: String, date: String, agree:Int)
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
    
    func sortbyClicked(button: UIButton) {
        let sortListController = UIAlertController(title: "sort by",message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        sortListController.addAction(cancelAction)
        let timeAction: UIAlertAction = UIAlertAction(title: "Time", style: .default) { action -> Void in
            self.sortByTime()
        }
        sortListController.addAction(timeAction)
        let popularityAction: UIAlertAction = UIAlertAction(title: "Popularity", style: .default) { action -> Void in
            self.sortByPopularity()
        }
        sortListController.addAction(popularityAction)
        
        self.present(sortListController, animated: true, completion: nil)
    }
    
    func toWriteSuggestionPage(textfield: UITextField) {
        let storyboard = UIStoryboard(name: "CourseProfile", bundle: nil)
        let writeSuggestionViewController = storyboard.instantiateViewController(withIdentifier: "writeSuggestion") as! writeSuggestionViewController
        writeSuggestionViewController.courseID = courseInfo.db_id
        self.navigationController!.pushViewController(writeSuggestionViewController, animated: true)
    }
    
    func setUpOtherProfessorsView() {
        otherProfessorView.addBorder(edges: .top, colour: PR_Colors.lightGreen, thickness: 1.0)
        otherProfessorView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        otherProfessorView.addGestureRecognizer(tap)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchPage = storyboard.instantiateViewController(withIdentifier: "searchPage") as! SearchTableViewController
        searchPage.searchString = self.title
        searchPage.skipProfessorName = professorLabel.text!
        self.navigationController!.pushViewController(searchPage, animated: true)
    }
    
    func sortByTime() {
        self.commentInfo.sort(by: { $0.timestamp > $1.timestamp })
        self.isSortedBy = "Time"
        self.profileTableView.reloadData()
    }
    
    func sortByPopularity() {
        self.commentInfo.sort(by: { $0.compareToByPopularity($1) })
        self.isSortedBy = "Popularity"
        self.profileTableView.reloadData()
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

