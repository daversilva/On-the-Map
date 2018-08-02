//
//  CommonAttributeButton.swift
//  On the Map
//
//  Created by David Rodrigues on 02/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class CommonAttributeButton: UIButton {
    
    var button: UIColor? { get { return UIColor(named: "main-color") } }
    var shadow: UIColor? { get { return UIColor(named: "main-color-shadow") } }
    
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 44.0
    let borderedButtonCornerRadius: CGFloat = 4.0
    let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
 
}
