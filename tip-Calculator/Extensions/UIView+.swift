//
//  UIView+.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 04/03/24.
//

import UIKit

extension UIView {
    func addBorderShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCgColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCgColor
    }
    
    func addCorderRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
