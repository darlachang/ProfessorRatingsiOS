//
//  ViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 9/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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


}

