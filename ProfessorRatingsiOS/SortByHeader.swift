//
//  SortByHeader.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/28/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class SortByHeader: UIView {
    
    var toggleButton: UIButton!
    var sortStr = ["time", "popularity"]
    var delegate: SortbyCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        toggleButton = UIButton()
        toggleButton.setTitle("time", for: .normal)
        toggleButton.setTitleColor(PR_Colors.lightGreen, for: .normal)
        toggleButton.layer.borderColor = PR_Colors.lightGreen.cgColor
        toggleButton.layer.borderWidth = 1
        toggleButton.frame = CGRect.init(x: 300, y: 3, width: 100, height: 30)
        toggleButton.addTarget(self, action: #selector(sortbyClicked), for: .touchDown)
        addSubview(toggleButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func sortbyClicked(button: UIButton){
        print("Button pressed 👍")
        delegate?.sortbyClicked(button: button)
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
