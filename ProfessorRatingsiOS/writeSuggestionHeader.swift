//
//  writeSuggestionHeader.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/29/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class writeSuggestionHeader: UIView, UITextFieldDelegate {
    var delegate: WriteSuggestionDelegte?
    var writeSuggestionTextField: UITextField!
    override init(frame: CGRect) {
        super.init(frame: frame)
        writeSuggestionTextField = UITextField()
        writeSuggestionTextField.delegate = self
        writeSuggestionTextField.frame = CGRect.init(x: 10, y: 10, width: 385, height: 50)
        //writeSuggestionTextField.textAlignment = NSTextAlignment.center
        writeSuggestionTextField.placeholder = "  Do you have a suggestion for the course?"
        writeSuggestionTextField.layer.borderColor = UIColor.lightGray.cgColor
        writeSuggestionTextField.layer.borderWidth = 1
        writeSuggestionTextField.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.white
        addSubview(writeSuggestionTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            goToWriteSuggestionPage()
            return false
    }
    func goToWriteSuggestionPage(){
        print("write the suggestion ")
        delegate?.toWriteSuggestionPage(textfield: writeSuggestionTextField)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
