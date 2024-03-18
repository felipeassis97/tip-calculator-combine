//
//  CalculatorVM.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 12/03/24.
//

import Foundation
import Combine
import CombineCocoa

class CalculatorVM {
    private let audioPlayerService: AudioPlayerService
    
    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoTapViewPublisher: AnyPublisher<Void, Never>
       
    }
    struct Output {
        let updateViewPublisher: AnyPublisher<ResultTip, Never>
        let resultCalculatorPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / split.toDouble
                let result = ResultTip(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resetCalculatorPublisher = input
            .logoTapViewPublisher
            .handleEvents(receiveOutput: { [unowned self] in
            audioPlayerService.playSound()
        }).flatMap {
            return Just($0)
        }.eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher,
                      resultCalculatorPublisher: resetCalculatorPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
           return bill * 0.1
        case .fiftenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return value.toDouble
        }
    }
}
