//
//  SignUpViewController.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 9/26/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
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
    
}

