//
//  SearchTableViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/2/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var course:[Course] = [
        Course(name: "Obj-Oriented Prog & Data Struc", cid: "CS 2110", professor: "Gries", department: "Computer Science", avgReview: 3.6, numOfReview: 233),
       Course(name: "Intro of Database Sys", cid: "CS 5320", professor: "Demers", department: "Computer Science", avgReview: 3.6, numOfReview: 150)
    ]
    var searchController:UISearchController!
    var searchResults:[Course] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("my course is", course)
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self

        Alamofire.request(Config.searchURL, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            if let value = response.result.value {
                self.course = []
                let jsonObject = JSON(value)
                //print("the course's avg review is ", jsonObject["results"][0]["average_review"])
               // print("the course's avg review is ", jsonObject)
                if let professors = jsonObject["results"].array { //.array is the usage of swiftyjson's library.
                    for professor in professors {
                        if let courses = professor["courses"].array{
                            for course in courses {
                                self.course.append(Course.init(name: course["course_name"].stringValue, cid: course["course_id"].stringValue, professor: professor["professor_name"].stringValue, department: professor["department"].stringValue, avgReview: professor["average_review"].doubleValue, numOfReview: professor["number_of_reviews"].intValue))
                            }
                        }
                    }
                }
                
                self.tableView.reloadData() //reload tableView
            }
            
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive{
            return searchResults.count
        } else {
            return course.count
        }
     }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("this is cell")
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        let course = (searchController.isActive) ? searchResults[indexPath.row] : self.course[indexPath.row]
        
        //set cell
        cell.nameLabel.text = course.name
        cell.cidLabel.text = course.cid
        cell.professorLabel.text = course.professor
        cell.avgReviewLabel.text = String(course.avgReview)
        
//        if let isVisited = course.isVisited? .boolValue {
//            cell.accessoryType = isVisited ? .checkmark : .none
//        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String){
        searchResults = course.filter({ (course:Course) -> Bool in
            let nameMatch = course.name.range(of:searchText, options: NSString.CompareOptions.caseInsensitive)
            let cidMatch = course.cid!.range(of:searchText, options: NSString.CompareOptions.caseInsensitive)
            let profMatch = course.professor.range(of:searchText, options: NSString.CompareOptions.caseInsensitive)
            return nameMatch != nil || cidMatch != nil || profMatch != nil
        })
    }

}