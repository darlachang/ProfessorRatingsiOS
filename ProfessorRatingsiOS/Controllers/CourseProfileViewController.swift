//
//  CourseProfileViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 10/17/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class CourseProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum cellstate{
        case rating
        case comments
        case quotes
    }
    
    var state:cellstate = .rating
    
    @IBOutlet weak var ratings: UIButton!
    @IBOutlet weak var comments: UIButton!
    
    @IBAction func ratingact(_ sender: AnyObject) {
        comments.isSelected = false
        ratings.isSelected = true
    }
    @IBAction func commentsact(_ sender: AnyObject) {
        
        state = .comments
    }
    
    //var courseinfo = []
    var courseinfo: Course!
    
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
        ratings.setTitleColor(UIColor.green, for: .normal)
        ratings.setTitleColor(UIColor.blue, for: .selected)
        ratings.setBackgroundImage(self.imageWithColor(UIColor.gray), for: .selected)
        
        
       // ratings.isSelected  //is a boolean


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        switch state {
        case .rating:
            return 0
        case .comments:
            return 0
        case .quotes:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "courseprofileCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = ""
        
        return cell
    }
    
//    func loginUser(){
//        let params:[String: Any] = [
//            "courseid" : courseinfo.name!
//        ]
//        //TODO: show spinner
//        
//        Alamofire.request(Config.loginURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
//            (response) in
//            guard response.result.error == nil else {
//                self.showMessage(response.result.error.debugDescription, type: .error, options: [.textNumberOfLines(2)])
//                return
//            }
//            if let value = response.result.value {
//                let jsonObject = JSON(value)
//                if !jsonObject["success"].bool!{
//                    self.showMessage(jsonObject["message"].string!, type: .error)
//                    return
//                }
//                
//                // Save user id && access token locally
//                let defaults = UserDefaults.standard
//                defaults.set(jsonObject["user_id"].stringValue, forKey: "user_id")
//            }
//            
//            self.nextPage()
//        }
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
