//
//  writeSuggestionViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/29/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class writeSuggestionViewController: UIViewController {
    
    @IBOutlet weak var writeSuggestionTextField: UITextView!
    @IBOutlet weak var writeSugSubmit: UIButton!
    
    var courseID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        writeSuggestionTextField.layer.borderColor = UIColor.lightGray.cgColor
        writeSuggestionTextField.layer.borderWidth = 1.0
        writeSuggestionTextField.layer.cornerRadius = 10
        writeSugSubmit.layer.borderColor = PR_Colors.brightOrange.cgColor
        writeSugSubmit.layer.borderWidth = 1.0
        writeSugSubmit.layer.cornerRadius = 10
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func writeSugSubmitPressed(_ sender: AnyObject) {
        submitSuggestion()
    }
    
    func submitSuggestion(){
        suggestionCommit()
        self.previousPage()
    }
    func suggestionCommit(){
        let defaults = UserDefaults.standard
        let params:[String: Any] = [
            "course":courseID,
            "content":writeSuggestionTextField.text,
            "user_id": defaults.string(forKey: "user_id")!
        ]
        
        Alamofire.request(Config.suggestionURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response) in
            guard response.result.error == nil else {
                print("Error in submitting suggestion")
                print(response.result.error)
                return
            }
        }

        
    }
    func previousPage(){
        self.navigationController!.popViewController(animated: true)
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
