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


class UserViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var gradYearPicker: UIPickerView!
    var majorPicker: UIPickerView!
    var gradYearToolBar = UIToolbar()
    var majorToolBar = UIToolbar()
    
    let EMAIL = 0
    let STUDENT_STATUS = 1
    let EXPECTED_YEAR_OF_GRADUATION = 2
    let MAJOR = 3
    let RESET_PASSWORD = 4
    let LOGOUT = 5
    
    var myPosts = [Comments]()
    var user:User!
    func editButtonClicked(_ sender: AnyObject?) {
        let position = sender?.convert(CGPoint.zero, to: self.tableView)
        var index = self.tableView.indexPathForRow(at: position!)!
        switch index.row {
        case STUDENT_STATUS:
            editStatus()
            break
        case MAJOR:
            editMajor()
            break
        case EXPECTED_YEAR_OF_GRADUATION:
            editYear()
            break
        default:
            break
        }
    }
    
    func editStatus() {
        let studStatusController = UIAlertController(title: "Your academic degree",message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        studStatusController.addAction(cancelAction)
        
        let bachelorAction: UIAlertAction = UIAlertAction(title: "Bachelor", style: .default) { action -> Void in
            self.user.status = "Bachelor"
            self.tableView.reloadData()
        }
        studStatusController.addAction(bachelorAction)
        
        let masterAction: UIAlertAction = UIAlertAction(title: "Master", style: .default) { action -> Void in
            self.user.status = "Master"
            self.tableView.reloadData()
        }
        studStatusController.addAction(masterAction)
        
        let doctorAction: UIAlertAction = UIAlertAction(title: "Doctor", style: .default) { action -> Void in
            self.user.status = "Doctor"
            self.tableView.reloadData()
        }
        studStatusController.addAction(doctorAction)
        
        
        self.present(studStatusController, animated: true, completion: nil)
    }
    
    func editMajor() {
        self.view.addSubview(majorPicker)
    }
    
    func editYear() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpPicker()
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
    
    func setUpPicker() {
        gradYearPicker = UIPickerView(frame: CGRect.init(x: 0, y: 200, width: view.frame.width, height: 300))
        
        gradYearPicker.backgroundColor = UIColor.white
        gradYearPicker.showsSelectionIndicator = true
        gradYearPicker.delegate = self
        gradYearPicker.dataSource = self
        gradYearToolBar.barStyle = UIBarStyle.default
        gradYearToolBar.isTranslucent = true
        gradYearToolBar.tintColor = PR_Colors.lightGreen
        gradYearToolBar.sizeToFit()
        
        majorPicker = UIPickerView(frame: CGRect.init(x: 0, y: 200, width: view.frame.width, height: 300))
        majorPicker.backgroundColor = UIColor.white
        majorPicker.showsSelectionIndicator = true
        majorPicker.delegate = self
        majorPicker.dataSource = self
        majorToolBar.barStyle = UIBarStyle.default
        majorToolBar.isTranslucent = true
        majorToolBar.tintColor = PR_Colors.lightGreen
        majorToolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(picked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(picked))
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(picked))
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(picked))
        
        
        gradYearToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        gradYearToolBar.isUserInteractionEnabled = true
//        gradYear.inputView = gradYearPicker
//        gradYear.inputAccessoryView = gradYearToolBar
        
        majorToolBar.setItems([cancelButton1, spaceButton1, doneButton1], animated: false)
        majorToolBar.isUserInteractionEnabled = true
//        major.inputView = majorPicker
//        major.inputAccessoryView = majorToolBar
    }
    
    
    func picked(){
        self.view.endEditing(true)
    }

}

extension UserViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
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

}

extension UserViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component:Int) -> Int {
        if(pickerView == gradYearPicker){
            return yearPickerData.count
        }
        else if(pickerView == majorPicker){
            return majorPickerData.count
        }
        return 1
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == gradYearPicker){
            return yearPickerData[row]
        }
        else if(pickerView == majorPicker){
            return majorPickerData[row]
        }
        return nil
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if(pickerView == gradYearPicker){
            user.yearOfGraduation = yearPickerData[row]
        }
        else if(pickerView == majorPicker){
            user.major = majorPickerData[row]
        }
        self.tableView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}


