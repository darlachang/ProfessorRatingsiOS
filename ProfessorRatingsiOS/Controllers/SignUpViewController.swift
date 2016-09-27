//
//  SignUpViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 9/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import GSMessages

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
        if verifyResult.success {
            // TODO - jump to next page
        } else {
            showMessage(verifyResult.error.rawValue, type: .error, options: [.textNumberOfLines(2)])
        }
    }
    
    func verifyFields() -> (success: Bool, error:RegistrationError) {
        if let email = emailText.text {
            if !validateEmail(candidate: email) {
                return (false, .InvalidEmail)
            }
        }
        if let password = passwordText.text {
            if password.contains(" ") {
                return (false, .PasswordContainsSpace)
            }
            
            if password.characters.count < 6 {
                return (false, .PasswordTooShort)
            }
            
            if let confirmPassword = confirmPasswordText.text {
                if confirmPassword != password {
                    return (false, .PasswordDoesNotConfirm)
                }
            } else {
                return (false, .EmptyConfirmPassword)
            }
        } else {
          return (false, .EmptyPassword)
        }
        
        // POST users on another thread
        return (true, .None)
    }
}

enum RegistrationError: String {
    case
    InvalidEmail = "Invalid Email. \nPlease make sure to use your edu email",
    EmptyPassword = "Empty Password",
    EmptyConfirmPassword = "Empty Confirm Password",
    PasswordContainsSpace = "Password Contains Space",
    PasswordTooShort = "Password is too short",
    PasswordDoesNotConfirm = "Make sure your password matches ",
    EmailAlreadyExist = "Email Already Exit",
    None
}

