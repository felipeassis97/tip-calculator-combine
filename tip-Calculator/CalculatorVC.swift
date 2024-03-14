//
//  ViewController.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit
import SnapKit
import Combine

class CalculatorVC: UIViewController {
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: Just(5).eraseToAnyPublisher())
        
        let output = vm.transform(input: input)
        output.updateViewPublisher.sink { result in
            print("..... \(result)")
        }.store(in: &cancellables)
    }
    
    
    private func layout() {
        view.backgroundColor = .background
        view.addSubview(vStackView)

        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}

#Preview {
    CalculatorVC()
}
