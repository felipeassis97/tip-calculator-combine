//
//  SplitInputView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit

class SplitInputView: UIView {

    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .orange
    }


}
