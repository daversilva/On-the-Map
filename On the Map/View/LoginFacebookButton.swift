//
//  LoginButtonFacebook.swift
//  On the Map
//
//  Created by David Rodrigues on 25/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginFacebookButton: UIButton {

    // MARK: Properties
    
    // constants for styling and configuration
    let button = UIColor(red: 64.0/255.0, green: 102.0/255.0, blue: 175.0/255, alpha: 1.0)
    let shadow = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 44.0
    let borderedButtonCornerRadius: CGFloat = 4.0
    let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeBorderedButton()
    }
    
    private func themeBorderedButton() {
        layer.masksToBounds = true
        layer.cornerRadius = borderedButtonCornerRadius
        highlightedBackingColor = shadow
        backingColor = button
        backgroundColor = button
        setTitleColor(.white, for: UIControlState())
        titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
    }
    
    // MARK: Setters
    
    private func setBackingColor(_ newBackingColor: UIColor) {
        if let _ = backingColor {
            backingColor = newBackingColor
            backgroundColor = newBackingColor
        }
    }
    
    private func setHighlightedBackingColor(_ newBackinglightedBackingColor: UIColor) {
        highlightedBackingColor = newBackinglightedBackingColor
        backingColor = highlightedBackingColor
    }
    
    // MARK: Tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTracking(with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    // MARK: Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let extraButtonPadding: CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSize.zero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
    }
    
}
