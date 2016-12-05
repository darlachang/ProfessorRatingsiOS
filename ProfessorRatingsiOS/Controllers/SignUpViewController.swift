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
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var studStatus: UITextField!
    @IBOutlet weak var gradYear: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var cancel: UIButton!
    var gradYearPicker: UIPickerView!
    var majorPicker: UIPickerView!
    var gradYearToolBar = UIToolbar()
    var majorToolBar = UIToolbar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.layer.borderColor = PR_Colors.brightOrange.cgColor
        signUp.layer.borderWidth = 1.0
        signUp.layer.cornerRadius = 10
        studStatus.delegate = self
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
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SignUpViewController.picked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SignUpViewController.picked))
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SignUpViewController.picked))
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SignUpViewController.picked))
        
        
        gradYearToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        gradYearToolBar.isUserInteractionEnabled = true
        gradYear.inputView = gradYearPicker
        gradYear.inputAccessoryView = gradYearToolBar
        
        majorToolBar.setItems([cancelButton1, spaceButton1, doneButton1], animated: false)
        majorToolBar.isUserInteractionEnabled = true
        major.inputView = majorPicker
        major.inputAccessoryView = majorToolBar

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.endEditing))
        self.view.addGestureRecognizer(gesture)
    }
    
    func endEditing(){
        self.view.endEditing(true)
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
            registerUser()
            nextPage()
        } else {
            showMessage(verifyResult.rawValue, type: .error, options: [.textNumberOfLines(2)])
        }
    }
    @IBAction func cancelPressed(_ sender: AnyObject) {
        nextPage()
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
            "password" : passwordText.text!,
            "year" : gradYear.text!,
            "major" : major.text!,
            "status" : studStatus.text!
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
    func nextPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let enterPage = storyboard.instantiateViewController(withIdentifier: "enterPage")
        self.present(enterPage, animated: true, completion: nil)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == studStatus{
            self.studentStatusSelected()
            return false
        }
        return true
    }
    
    func studentStatusSelected() {
        let studStatusController = UIAlertController(title: "Your academic degree",message: nil, preferredStyle: .actionSheet)
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
            gradYear.text = yearPickerData[row]
        }
        else if(pickerView == majorPicker){
            major.text = majorPickerData[row]
        }
        
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

