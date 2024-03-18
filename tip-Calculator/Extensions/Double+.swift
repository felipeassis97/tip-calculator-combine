//
//  Double+.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 16/03/24.
//

import Foundation

extension Double {
    var toString: String {
        return String(self)
    }
    
    var toCurrency: String {
        var isWholeNumber: Bool {
            isZero ? true : !isNormal ? false : self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(for: self) ?? ""
    }
}
