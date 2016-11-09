//
//  ToggleMenu.swift
//
//  Created by Brage Staven on 06.05.2016.
//  Copyright © 2016 Stav1. All rights reserved.
//

import UIKit

class ToggleMenu: UIView {
    
    private var hasAddedButtonsToView = false
    private var originalHeight: CGFloat!
    private var hasLayedOutView = false
    let toggleButton = UIButton()
    var menuButtons = [UIButton]()
    var buttonSize: CGSize!
    var toggled = false
    private let padding: CGFloat = 0
    
    init(frame: CGRect, defaultTitle: String, menuButtons: [UIButton]) {
        self.menuButtons = menuButtons
        toggleButton.setTitle(defaultTitle, for: .normal)
        toggleButton.setTitleColor(PR_Colors.lightGreen, for: .normal)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMenu()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    /**
     Toggles or untoggles the menu. Use this to manually toggle/untoggle the view
     */
    func togglePressed(){
        if toggled{
            animateUnToggle()
            self.toggled = false
        }else{
            animateToggle()
            self.toggled = true
        }
    }
    
    /**
     Adds the toggle button and the effect view background. Default is UIBlurEffectStyle.Dark. Also removing constraints if view is set in storyboard/XIB
     */
    private func layoutMenu(){
        if !hasLayedOutView{
            hasLayedOutView = true
            self.backgroundColor = UIColor.clear
            toggleButton.frame = CGRect.init(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
            toggleButton.layer.borderColor = PR_Colors.lightGreen.cgColor
            toggleButton.layer.borderWidth = 1
            toggleButton.addTarget(self, action: #selector(togglePressed), for: .touchUpInside)
            self.addSubview(toggleButton)
            self.buttonSize = CGSize.init(width: toggleButton.bounds.width, height: toggleButton.bounds.height)
        }
    }
    
    /**
     Untoggles the menu
     */
    
    func animateUnToggle(){
        
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect.init(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.originalHeight)
            self.layoutIfNeeded()
        }
        
        for i in 0..<self.menuButtons.count{
            let currentButton = self.menuButtons[i]
            UIView.animate(withDuration: 0.1) {
                currentButton.alpha = 0.0
                currentButton.center = self.toggleButton.center
            }
        }
        
    }
    
    /**
     Toggles the menu
     */
    private func animateToggle(){
        
        if !hasAddedButtonsToView{
            addButtonsToView()
        }
        
        let paddingBetweenitems: CGFloat = 0
        let menuHeight = CGFloat(self.menuButtons.count + 1) * (buttonSize.height + 2 * padding + paddingBetweenitems)
        
        UIView.animate(withDuration: 0.2) {
            self.frame = CGRect.init(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: menuHeight)
            self.layoutIfNeeded()
        }
        
        for i in 0..<self.menuButtons.count {
            let currentButton = self.menuButtons[i]
            let yPosition = self.toggleButton.frame.midY + CGFloat(i + 1) * (buttonSize.height + 2 * padding + paddingBetweenitems)
            UIView.animate(withDuration: 0.5) {
                currentButton.center = CGPoint.init(x: self.toggleButton.frame.midX, y: yPosition) 
                currentButton.alpha = 1.0
            }
        }
        
    }
    
    private func addButtonsToView(){
        self.hasAddedButtonsToView = true
        self.originalHeight = self.bounds.height
        for i in 0..<self.menuButtons.count{
            let currentButton = self.menuButtons[i]
            currentButton.frame = CGRect.init(x: 0, y: 0, width: self.buttonSize.width, height: self.buttonSize.height)
            currentButton.center = CGPoint.init(x: self.toggleButton.frame.midX, y: 0)
            currentButton.alpha = 0.0
            currentButton.layer.borderColor = PR_Colors.lightGreen.cgColor
            currentButton.layer.borderWidth = 1
            self.addSubview(currentButton)
        }
    }
    
}
