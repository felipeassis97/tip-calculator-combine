//
//  HeaderView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 05/03/24.
//

import UIKit

class HeaderView: UIView {
    
    private var topLabelText: String
    private var bottomLabelText: String
    
    init(topText: String, bottomText: String) {
        self.topLabelText = topText
        self.bottomLabelText = bottomText
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .onBackground
        label.font = ThemeFont.bold(offSize: 18)
        label.text = self.topLabelText
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .onBackground
        label.font = ThemeFont.regular(offSize: 18)
        label.text = self.bottomLabelText
        return label
    }()
    
    private let topSpacerView = UIView()
    private let bottomSpacerView = UIView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topSpacerView,
            topLabel,
            bottomLabel,
            bottomSpacerView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = -4
        return stackView
    }()

    private func layout() {
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topSpacerView.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacerView)
        }
    }
}
