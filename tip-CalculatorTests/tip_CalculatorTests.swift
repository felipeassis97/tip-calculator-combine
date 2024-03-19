//
//  tip_CalculatorTests.swift
//  tip-CalculatorTests
//
//  Created by Felipe Assis on 03/03/24.
//

import XCTest
import Combine
@testable import tip_Calculator

class MockAudioPlayerService: AudioPlayerService {
    func playSound() {}
}

final class tip_CalculatorTests: XCTestCase {
    ///sut -> System Under Test
    private var sut: CalculatorVM!
    private var cancellables: Set<AnyCancellable>!
    private let logoViewSubject = PassthroughSubject<Void, Never>()
    
    ///Start test
    override func setUp() {
        sut = .init(audioPlayerService: DefaultAudioPlayer())
        cancellables = .init()
        super.setUp()
    }
    
    /// End test
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func testResultWithoutTipFor1Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithTenPercentTipFor2Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipFor4Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 100)
        let split: Int = 4
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 200)
            XCTAssertEqual(result.totalTip, 100)
        }.store(in: &cancellables)
    }
    
    func testSoundPlayedAndCalculatorResetOnLogoViewTap() {
        //given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "reset calculator called")
        //then
        output.resultCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellables)
        //when
        logoViewSubject.send()
        wait(for: [expectation1], timeout: 1.0)

    }

    //MARK: Private utils functions
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorVM.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoTapViewPublisher: logoViewSubject.eraseToAnyPublisher()
        )
    }
}
