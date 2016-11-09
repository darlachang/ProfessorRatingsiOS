//
//  sortbyCell.swift
//  ProfessorRatingsiOS
//
//  Created by Darla Chang on 11/7/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import UIKit

class SortbyCell: UITableViewCell {
    
    var toggleView: ToggleMenu!
    var delegate: SortbyCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        var sortStr = ["time", "popular"]
        
        var buttons = [UIButton]()
        for i in 0..<2{
            let button = UIButton()
            // button.setImage(UIImage(named: "menuButton"), for: .normal)
            
            button.setTitle(sortStr[i], for: .normal)
            button.setTitleColor(UIColor.green, for: .normal)
            buttons.append(button)
            button.addTarget(self, action: #selector(sortbyClicked(button:)), for: .touchUpInside)
            //button.addTarget(self, action: #selector(darkMenuButtonPressed), forControlEvents: .TouchUpInside)
        }
        
        toggleView = ToggleMenu.init(frame: CGRect.init(x: 20, y: 20, width: 100, height: 30), defaultTitle: "time", menuButtons: buttons)
        
        self.contentView.addSubview(toggleView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func sortbyClicked(button: UIButton){
        delegate?.sortbyClicked(button: button)
        toggleView.animateUnToggle()
        toggleView.toggleButton.setTitle(button.titleLabel!.text, for: .normal)
    }
}
