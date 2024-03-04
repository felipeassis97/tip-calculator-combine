//
//  AmontView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 04/03/24.
//

import UIKit

class AmountView: UIView {
    private let title: String
    private let textAlignment: NSTextAlignment
    
    init(title: String, textAlignment: NSTextAlignment) {
        self.title = title
        self.textAlignment = textAlignment
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.title
        label.font = ThemeFont.regular(offSize: 18)
        label.textColor = .onBackground
        label.textAlignment = self.textAlignment
        return label
    }()
    
    private lazy var amountlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = self.textAlignment
        label.textColor = .customPrimary
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [.font: ThemeFont.bold(offSize: 24)])
        text.addAttribute(
            .font, value: ThemeFont.bold(offSize: 16),
            range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            amountlabel
        ])
        stackView.axis = .vertical
        return stackView
    }()

    private func layout() {
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
