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
    var CommentsList:[String] = ["you should take this course", "Better to save your time", "the professor is awesome"]
    var CommentsRating:[String] = ["2", "3", "5"]
    var CommentsTag:[String] = ["endless assignments", "knowledgable", "practical"]
    var QuotesList:[String] = ["Finish before deadline is impossible", "If you take the practicum"]



    var courseinfo: Course!
    
    @IBOutlet var cidLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    

    
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
        print("courseprofile is", courseinfo.name)
        
        cidLabel.text = courseinfo.id
        nameLabel.text = courseinfo.name
        professorLabel.text = courseinfo.professor
        
//        let courseSegmentControl = UISegmentedControl (items: ["Ratings & Tag", "Comments", "Quotes"])
//        courseSegmentControl.frame = CGRect.init(x: 10, y: 150, width: 300, height: 30)
        courseSegmentedControl.selectedSegmentIndex = 0
//        courseSegmentedControl.tintColor = UIColor.white
//        courseSegmentedControl.backgroundColor = UIColor.green
        
//        ratings.setTitleColor(UIColor.green, for: .normal)
//        ratings.setTitleColor(UIColor.blue, for: .selected)
//        ratings.setBackgroundImage(self.imageWithColor(UIColor.gray), for: .selected)
        
        
       // ratings.isSelected  //is a boolean


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
            returnValue = 3
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
                cell.ratingTitle.text = RatingsList[0]
                cell.ratingNum.text = RatingsNum[0]
                cell.ratingAmt.text = "\(RatingsAmount[0]) ratings"
                
            case 1:
                cell.ratingTitle.text = RatingsList[1]
                cell.ratingNum.text = RatingsNum[1]
                cell.ratingAmt.text = "\(RatingsAmount[1]) ratings"
                
            case 2:
                cell.ratingTitle.text = RatingsList[2]
                cell.ratingNum.text = RatingsNum[2]
                cell.ratingAmt.text = "\(RatingsAmount[2]) ratings"
            
            default:
                break
            }
            return cell
            
        
        case 1:
            let cellIdentifier = "commentsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseProfileCommentsTableViewCell
            switch indexPath.row {
                
            case 0:
                cell.comment.text = CommentsList[0]
                cell.rating.text = CommentsRating[0]
                cell.tags.text = CommentsTag[0]
                
            case 1:
                cell.comment.text = CommentsList[1]
                cell.rating.text = CommentsRating[1]
                cell.tags.text = CommentsTag[1]
                
            case 2:
                cell.comment.text = CommentsList[2]
                cell.rating.text = CommentsRating[2]
                cell.tags.text = CommentsTag[2]
                
            default:
                break

            }
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
    
    @IBAction func SegmentedValueChanged(_ sender: AnyObject) {
        profileTableView.reloadData()
    }


    func getcomments() {
        let params:[String: Any] = [
            "_id" : courseinfo.id
        ]
        Alamofire.request(Config.registrationURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            guard response.result.error == nil else {
                print("Error while registering")
                print(response.result.error)
                
                return
                
                // TODO Handle registration fail
            }
            if let value = response.result.value {
                let jsonObject = JSON(value)
                if !jsonObject["success"].bool!{
                    self.showMessage(jsonObject["message"].string!, type: .error)
                    return
                }
                
                // Save user id && access token locally
                let defaults = UserDefaults.standard
                defaults.set(jsonObject["user_id"].stringValue, forKey: "user_id")
                
                //read the data
                let userID = defaults.object(forKey: "user_id") as? String
                print(userID!)
                // Navigate to next page
            }
        }
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


