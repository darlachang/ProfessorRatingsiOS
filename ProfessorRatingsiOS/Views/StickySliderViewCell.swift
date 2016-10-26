////
////  DifficultyCell.swift
////  ProfessorRatingsiOS
////
////  Created by Hongfei Li on 10/5/16.
////  Copyright © 2016 Hongfei Li. All rights reserved.
////
//
import Foundation
import Eureka

final class StickySliderViewRow: Row<StickySliderViewCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<StickySliderViewCell>(nibName: "StickySliderViewCell")
    }
}

class StickySliderViewCell: Cell<StickySliderContent>, CellType {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var valueIndicator: UILabel!
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let newStep = roundf(sender.value / Float(self.row.value!.step))
        sender.value = newStep * self.row.value!.step
        row.value?.value = sender.value
        valueIndicator.text = String(Int(slider.value))

    }
    
    override public func setup() {
        super.setup()
        if let content = row.value {
            title.text = content.title
            leftLabel.text = content.leftText
            rightLabel.text = content.rightText
            slider.minimumValue = Float(content.lowerValue)
            slider.maximumValue = Float(content.higherValue)
        }
        height = {return 130}
    }
    
    override public func update() {
        super.update()
        slider.value = (row.value?.value)!
        valueIndicator.text = String(Int(slider.value))
    }
}

struct StickySliderContent:Equatable {
    var leftText:String
    var rightText:String
    var title:String
    var step:Float
    var lowerValue:Int
    var higherValue:Int
    var value:Float = 2
}

func ==(lhs: StickySliderContent, rhs: StickySliderContent) -> Bool {
    return lhs.title == rhs.title
}
