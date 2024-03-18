//
//  BillInputView.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit
import Combine
import CombineCocoa

class BillInputView: UIView {
    private var billSubject: PassthroughSubject<Double, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    var valuePublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    init() {
        super.init(frame: .zero)
        layout()
        obeserve()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headerView: HeaderView = {
        return HeaderView(
            topText: "Enter",
            bottomText: "your bill")
    }()
    
    private lazy var textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorderRadius(radius: 8.0)
        return view
    }()
    
    private lazy var currencyDenominationLabel: UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textColor = .onBackground
        label.font = ThemeFont.bold(offSize: 24)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = ThemeFont.demiBold(offSize: 28)
        field.keyboardType = .decimalPad
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.tintColor = .onBackground
        field.textColor = .onBackground
        //Add toolbar
        let toolbar = UIToolbar(frame: CGRect(
            x: 0, y: 0,
            width: frame.size.width,
            height: 36))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped))
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil),
            doneButton
        ]
        toolbar.isUserInteractionEnabled = true
        field.inputAccessoryView = toolbar
        return field
    }()
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
    
    private func layout() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDenominationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    private func obeserve() {
        textField.textPublisher.sink { [unowned self] text in
            self.billSubject.send(text?.toDouble ?? 0)
        }.store(in: &cancellables)
    }
    
    func reset() {
        textField.text = nil
        billSubject.send(0)
    }
}

