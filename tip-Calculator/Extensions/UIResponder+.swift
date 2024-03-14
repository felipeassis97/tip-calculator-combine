//
//  UIResponder+.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 14/03/24.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
