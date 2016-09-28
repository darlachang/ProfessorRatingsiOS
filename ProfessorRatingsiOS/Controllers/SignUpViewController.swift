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

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            "password" : encrypt(password: passwordText.text!)
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
    
    func encrypt(password:String) -> String {
        let encryptedPW: String = try! password.encrypt(cipher: AES(key: Config.encryptionKey, iv: Config.iv))
        return encryptedPW
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

