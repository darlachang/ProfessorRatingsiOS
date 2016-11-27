//
//  SignUpViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 9/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import GSMessages
import Alamofire
import SwiftyJSON
import CryptoSwift

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var studStatus: UITextField!
    @IBOutlet weak var gradYear: UITextField!
    
    var gradYearToolBar = UIToolbar()
    
    var pickerData: [String] = ["2010","2011","2012","2013","2014","2015","2016","2017","2018", "2019", "2020"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studStatus.delegate = self
        
        let gradYearPicker = UIPickerView(frame: CGRect.init(x: 0, y: 200, width: view.frame.width, height: 300))
        gradYearPicker.backgroundColor = UIColor.white
        gradYearPicker.showsSelectionIndicator = true
        gradYearPicker.delegate = self
        gradYearPicker.dataSource = self
        gradYearToolBar.barStyle = UIBarStyle.default
        gradYearToolBar.isTranslucent = true
        gradYearToolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        gradYearToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SignUpViewController.picked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SignUpViewController.picked))
        
        gradYearToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        gradYearToolBar.isUserInteractionEnabled = true
        
        gradYear.inputView = gradYearPicker
        gradYear.inputAccessoryView = gradYearToolBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return candidate.hasSuffix(".edu") && NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    @IBAction func SignUpPressed(_ sender: AnyObject) {
        let verifyResult = verifyFields()
        if verifyResult == RegistrationVerificationResult.success {
            // TODO - jump to next page
            registerUser()
        } else {
            showMessage(verifyResult.rawValue, type: .error, options: [.textNumberOfLines(2)])
        }
    }
    
    func verifyFields() -> RegistrationVerificationResult {
        if let email = emailText.text {
            if !validateEmail(candidate: email) {
                return .invalidEmail
            }
        }
        if let password = passwordText.text {
            if password.contains(" ") {
                return .passwordContainsSpace
            }
            
            if password.characters.count < 6 {
                return .passwordTooShort
            }
            
            if let confirmPassword = confirmPasswordText.text {
                if confirmPassword != password {
                    return .passwordDoesNotConfirm
                }
            } else {
                return .emptyConfirmPassword
            }
        } else {
            return .emptyPassword
        }
        
        return .success
    }
    
    func registerUser() {
        let params:[String: Any] = [
            "name" : "",
            "email" : emailText.text!,
            "password" : passwordText.text!
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
                
                // Navigate to next page
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == studStatus{
            self.studentStatusSelected()
            return false
        }
        return true
    }
    
    func studentStatusSelected() {
        let studStatusController = UIAlertController(title: "your status",message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        studStatusController.addAction(cancelAction)
        
        let bachelorAction: UIAlertAction = UIAlertAction(title: "Bachelor", style: .default) { action -> Void in
            self.studStatus.text = "Bachelor"
        }
        studStatusController.addAction(bachelorAction)
        
        let masterAction: UIAlertAction = UIAlertAction(title: "Master", style: .default) { action -> Void in
            self.studStatus.text = "Master"
        }
        studStatusController.addAction(masterAction)
        
        let doctorAction: UIAlertAction = UIAlertAction(title: "Doctor", style: .default) { action -> Void in
            self.studStatus.text = "Doctor"
        }
        studStatusController.addAction(doctorAction)
 
        
        self.present(studStatusController, animated: true, completion: nil)
    }
    
    // The number of columns of data

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component:Int) -> Int {
        return pickerData.count
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        gradYear.text = pickerData[row]
    }
    
    func picked(){
        self.view.endEditing(true)
    }
}

enum RegistrationVerificationResult: String {
    case
    invalidEmail = "Invalid Email. \nPlease make sure to use your edu email",
    emptyPassword = "Empty Password",
    emptyConfirmPassword = "Empty Confirm Password",
    passwordContainsSpace = "Password Contains Space",
    passwordTooShort = "Password is too short",
    passwordDoesNotConfirm = "Make sure your password matches ",
    emailAlreadyExist = "Email Already Exit",
    success
}

