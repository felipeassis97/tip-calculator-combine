//
//  ViewController.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        configure()
    }
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
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
    
    private func configure() {
        viewTapPublisher.sink { [unowned self ] _ in
            view.endEditing(true)
        }.store(in: &cancellables)
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoTapViewPublisher: logoViewTapPublisher)
        
        let output = vm.transform(input: input)
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configureValues(result: result)
        }.store(in: &cancellables)
        
        output.resultCalculatorPublisher.sink { [unowned self] _ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: 5.0,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.logoView.transform = .identity
                }
            }
            
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
