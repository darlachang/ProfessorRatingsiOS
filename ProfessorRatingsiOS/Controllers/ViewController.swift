//
//  ViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 9/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import GSMessages
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var SignInPressed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let userID = defaults.object(forKey: "user_id") as? String
        print(userID!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginUser(){
        // print("password is " + Utils.encrypt(passwordText.text!))
        let params:[String: Any] = [
            "email" : emailText.text!,
            // "password" : Utils.encrypt(passwordText.text!)
            "password" : passwordText.text!
        ]
        //show spinner
        Alamofire.request(Config.loginURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            guard response.result.error == nil else {
                //                print("Error while login")
                //                print(response.result.error)
                self.showMessage(response.result.error as! String, type: .error, options: [.textNumberOfLines(2)])
                return
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
                
                //read userID
                //                let defaults = UserDefaults.standard
                //                let userID = defaults.object(forKey: "user_id") as? String
                //hide spinner
            }
            
            self.nextPage()
        }
    }
    
    func nextPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviSearchController = storyboard.instantiateViewController(withIdentifier: "navisearch")
        self.present(naviSearchController, animated: true, completion: nil)
        //   self.navigationController?.pushViewController(naviSearchController, animated: true) //push是navi給到下一頁. popviewController是跳回上一頁
        
    }
    @IBAction func SignInPressed(_ sender: AnyObject) {
        loginUser()
        
    }
    
}
