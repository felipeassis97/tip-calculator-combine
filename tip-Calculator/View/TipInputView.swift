//
//  TipInputView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    private var cancellables = Set<AnyCancellable>()
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
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
            topText: "Choose",
            bottomText: "your tip")
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(offSize: 20)
        button.backgroundColor = .customPrimary
        button.tintColor = .white
        button.addCorderRadius(radius: 8.0)
        button.tapPublisher.sink { _ in
            self.handleCustomTipButton()
        }
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher.flatMap ({
            Just(Tip.tenPercent)
        })
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var fiftenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fiftenPercent)
        button.tapPublisher.flatMap ({
            Just(Tip.fiftenPercent)
        })
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap ({
            Just(Tip.twentyPercent)
        })
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fiftenPercentTipButton,
            twentyPercentTipButton
        ])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .customPrimary
        button.addCorderRadius(radius: 8.0)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(offSize: 20),
                .foregroundColor: UIColor.white
            ])
        text.addAttributes([
            .font: ThemeFont.demiBold(offSize: 14)
        ], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
    private func layout() {
        [headerView, buttonVStackView].forEach(addSubview(_:))
        
        buttonVStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
    private func observe() {
        tipSubject.sink { [unowned self ] tip in
            resetView()
            switch tip {
            case .none:
                break
            case .tenPercent:
                tenPercentTipButton.backgroundColor = .customSecondary
            case .fiftenPercent:
                fiftenPercentTipButton.backgroundColor = .customSecondary
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = .customSecondary
            case .custom(let value):
                customTipButton.backgroundColor = .customSecondary
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [.font: ThemeFont.bold(offSize: 20)])
                text.addAttributes([
                    .font: ThemeFont.bold(offSize: 14)
                ], range: NSMakeRange(0,1))
                customTipButton.setAttributedTitle(text, for: .normal)
                
            }
        }.store(in: &cancellables)
        
    }
    
    private func resetView() {
        [tenPercentTipButton,
         twentyPercentTipButton,
         fiftenPercentTipButton,
         customTipButton].forEach {
            $0.backgroundColor = .customPrimary
        }
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(offSize: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    private func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            
            controller.addTextField { textField in
                textField.placeholder = "Make it generous!"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            
            let cancellAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    guard let text = controller.textFields?.first?.text, let value = Int(text) else {
                        return
                    }
                    self?.tipSubject.send(.custom(value: value))
                }
            
            [okAction, cancellAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
    func reset() {
        tipSubject.send(.none)
    }
}


