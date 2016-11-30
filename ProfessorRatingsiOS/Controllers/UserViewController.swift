//
//  UserViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 11/28/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let EMAIL = 0
    let STUDENT_STATUS = 1
    let EXPECTED_YEAR_OF_GRADUATION = 2
    let MAJOR = 3
    let RESET_PASSWORD = 4
    let LOGOUT = 5
    
    var myPosts = [Comments]()
    var user:User!
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isUnderProfile() ? 6 : myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String
        if isUnderProfile() {
            if indexPath.row == LOGOUT {
                identifier = "logOutCell"
                return tableView.dequeueReusableCell(withIdentifier: identifier) as! LogOutTableViewCell
            } else {
                identifier = "profileCell"
            }
        } else {
            identifier = "postsCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! UserProfileTableViewCell
        
        switch indexPath.row {
        case EMAIL:
                cell.bindContent(titleText: "Logged In As", contentText: user.email, showEditButton: false)
        case STUDENT_STATUS:
            cell.bindContent(titleText: "Student Status", contentText: user.status, showEditButton: true)
        case EXPECTED_YEAR_OF_GRADUATION:
            cell.bindContent(titleText: "Expected Year of Graduation", contentText: user.yearOfGraduation, showEditButton: true)
        case MAJOR:
            cell.bindContent(titleText: "Major & Minor", contentText: user.major, showEditButton: true)
        case RESET_PASSWORD:
            cell.bindContent(titleText: "Reset Password", contentText: nil, showEditButton: false)
        case LOGOUT: break
        default: break
            
        }
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        user = User()
        user.id = Utils.currentUserId()
        getUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
    }
    
    func isUnderProfile() -> Bool {
        return segmentControl.selectedSegmentIndex == 0
    }
    
    func getUserInfo() {
        Alamofire.request(Config.registrationURL+"/"+Utils.currentUserId(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            guard response.result.error == nil else {
                print("Error while retrieving user info")
                print(response.result.error)
                return
            }
            if let value = response.result.value {
                let jsonObject = JSON(value)
                self.user.major = jsonObject["major"].stringValue
                self.user.email = jsonObject["email"].stringValue
                self.user.yearOfGraduation = jsonObject["year"].stringValue
                self.tableView.reloadData()
                print("data reloaded")
                // Navigate to next page
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

}


