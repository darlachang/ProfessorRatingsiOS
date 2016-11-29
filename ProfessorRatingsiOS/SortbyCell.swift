//
//  sortbyCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/7/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class SortbyCell: UITableViewCell {
    
    var toggleButton: UIButton!
    var delegate: SortbyCellDelegate?
    var sortStr = ["time", "popularity"]
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none

        toggleButton = UIButton()
        toggleButton.setTitle("time", for: .normal)
        toggleButton.setTitleColor(PR_Colors.lightGreen, for: .normal)
        toggleButton.layer.borderColor = PR_Colors.lightGreen.cgColor
        toggleButton.layer.borderWidth = 1
        toggleButton.frame = CGRect.init(x: 300, y: 3, width: 100, height: 30)
        self.contentView.addSubview(toggleButton)
        toggleButton.addTarget(self, action: #selector(sortbyClicked), for: .touchDown)

    //var toggleView: ToggleMenu!
//    var delegate: SortbyCellDelegate?
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        self.selectionStyle = .none
//        var sortStr = ["time", "popularity"]
//        
//        var buttons = [UIButton]()
//        for i in 0..<sortStr.count{
//            let button = UIButton()
//            button.setTitle(sortStr[i], for: .normal)
//            button.setTitleColor(PR_Colors.lightGreen, for: .normal)
//            buttons.append(button)
//            button.addTarget(self, action: #selector(sortbyClicked(button:)), for: .touchUpInside)
//        }
//
//        toggleView = ToggleMenu.init(frame: CGRect.init(x: 20, y: 20, width: 100, height: 30), defaultTitle: "time", menuButtons: buttons)
//        toggleView.tintColor = PR_Colors.lightGreen
//        
//        self.contentView.addSubview(toggleView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func sortbyClicked(button: UIButton){
        delegate?.sortbyClicked(button: button)
//        toggleView.animateUnToggle()
//        toggleView.toggleButton.setTitle(button.titleLabel!.text, for: .normal)
    }
}
