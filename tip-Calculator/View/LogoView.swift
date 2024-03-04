//
//  LogoView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit

class LogoView: UIView {
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .icCalculatorBW)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .onBackground
        let text = NSMutableAttributedString(
            string: "Mr TIP",
            attributes: [.font: ThemeFont.demiBold(offSize: 16)])
        text.addAttributes([.font: ThemeFont.bold(offSize: 24)], range: NSMakeRange(3,3))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Calculator"
        label.textColor = .onBackground
        label.font = ThemeFont.bold(offSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let view =  UIStackView(arrangedSubviews: [
            topLabel,
            bottomLabel
        ])
        
        view.axis = .vertical
        view.spacing = 1
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let view =  UIStackView(arrangedSubviews: [
            imageView,
            vStackView
        ])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
}

#Preview {
    LogoView()
}
