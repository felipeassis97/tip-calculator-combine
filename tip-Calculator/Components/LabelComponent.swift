//
//  LabelFactoryComponent.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit

struct LabelComponent {
    static func create(
        text: String?,
        font: UIFont,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .onBackground,
        textAlignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.font = font
            label.backgroundColor = backgroundColor
            label.textColor = textColor
            label.textAlignment = textAlignment
            return label
        }
}
