//
//  UIFontExtensions.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/14/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import UIKit

extension UIFont {
    static func body(size: CGFloat = 12) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
    static func boldBody(size: CGFloat = 12) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
}
