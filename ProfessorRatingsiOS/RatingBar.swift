//
//  RatingBar.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/30/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//
import Foundation
import UIKit

class RatingBar: UIView {
    
    init(values: [Int], color: UIColor, space: CGFloat, frame: CGRect) {
        super.init(frame: frame)
        
        let width = frame.size.width
        let height = frame.size.height
        
        let fullHeight = (height - (CGFloat(values.count) + 1) * space) / CGFloat(values.count)
        let fullWidth = width - 2 * 5 - 15
        
        //var total: Int = 0
        var largest: Int = 0
        for value in values {
            //total = total + value
            largest = (value > largest) ? value : largest
        }
        
        var yOffset = space
        for i in 0..<values.count {
            
            let percentage = CGFloat(largest) == 0 ? 0 : CGFloat(values[i]) / CGFloat(largest)
            let view = UIView()
            view.backgroundColor = color
            view.frame = CGRect.init(origin: CGPoint.init(x: 20, y: yOffset), size: CGSize.init(width: fullWidth * percentage, height: fullHeight))
            self.addSubview(view)
            
            let label = UILabel()
            label.text = "\(values.count - i)"
            label.textColor = PR_Colors.lightGreen
            label.font = UIFont.systemFont(ofSize: 14)
            label.sizeToFit()
            label.center = CGPoint.init(x: label.frame.size.height / 2, y: view.center.y)
            self.addSubview(label)
            
            yOffset = yOffset + fullHeight + space
        }
        
        let line = UIView()
        line.frame = CGRect.init(x: 20, y: 0, width: 1, height: height)
        line.backgroundColor = PR_Colors.lightGreen
        self.addSubview(line)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
