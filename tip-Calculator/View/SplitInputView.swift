//
//  SplitInputView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    private let splitSubjetc: CurrentValueSubject<Int, Never> = .init(1)
    private var cancellables = Set<AnyCancellable>()
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubjetc.removeDuplicates().eraseToAnyPublisher()
    }
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headerView: HeaderView = {
        return HeaderView(
            topText: "Split",
            bottomText: "the total")
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildSplitButton(
            text: "-",
            corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        
        button.tapPublisher.flatMap {[unowned self] _ in
            Just(splitSubjetc.value == 1 ? 1 : splitSubjetc.value - 1)
        }
        .assign(to: \.value, on: splitSubjetc)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildSplitButton(
            text: "+",
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.tapPublisher.flatMap {[unowned self] _ in
            Just(splitSubjetc.value + 1)
        }
        .assign(to: \.value, on: splitSubjetc)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = ThemeFont.bold(offSize: 20)
        label.textColor = .onBackground
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private func layout() {
        [headerView, hStackView].forEach(addSubview(_:))
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(hStackView.snp.centerY)
            make.trailing.equalTo(hStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
    private func observe() {
        splitSubjetc.sink { [unowned self] quantity in
            quantityLabel.text = quantity.toString
        }.store(in: &cancellables)
    }
    
    private func buildSplitButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(offSize: 20)
        button.addRoundedCorners(corners: corners, radius: 8.0)
        button.backgroundColor = .customPrimary
        return button
    }
    
    func reset() {
        splitSubjetc.send(1)
    }
}
