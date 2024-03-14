//
//  CalculatorVM.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 12/03/24.
//

import Foundation
import Combine

class CalculatorVM {
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
       
    }
    struct Output {
        let updateViewPublisher: AnyPublisher<ResultTip, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        input.tipPublisher.sink { tip in
            print("TIP VM: \(tip)")
        }.store(in: &cancellables)
        
        let result = ResultTip(
            amountPerPerson: 500,
            totalBill: 1000,
            totalTip: 50.0)
        
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
    
    
}
