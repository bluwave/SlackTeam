//
//  UIViewExtensions.swift
//  SlackTeam
//
//  Created by Garrett Richards on 11/14/16.
//  Copyright © 2016 Acme. All rights reserved.
//

import UIKit

extension UIView {
    func makeCircular() {
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
}
