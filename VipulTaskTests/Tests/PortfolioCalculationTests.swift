//
//  PortfolioCalculationTests.swift
//  VipulTaskTests
//
//  Created by Vipul Kumar on 15/01/26.
//

import XCTest
@testable import VipulTask

final class PortfolioCalculationTests: XCTestCase {

    private var sut: CalculatePortfolioUseCase!

    override func setUp() {
        super.setUp()
        sut = CalculatePortfolioUseCase()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testPortfolioCalculation_whenHoldingsExist_returnsCorrectValues() {

        // Given
        let holdings = [
            Holding(symbol: "A", quantity: 10, ltp: 100, avgPrice: 90, close: 95),
            Holding(symbol: "B", quantity: 5, ltp: 200, avgPrice: 180, close: 190)
        ]

        // When
        let summary = sut.execute(holdings: holdings)

        // Then
        XCTAssertEqual(summary.currentValue, 10*100 + 5*200)
        XCTAssertEqual(summary.totalInvestment, 10*90 + 5*180)
        XCTAssertEqual(summary.totalPNL, summary.currentValue - summary.totalInvestment)
        XCTAssertEqual(
            summary.todaysPNL,
            (95-100)*10 + (190-200)*5
        )
    }

    func testPortfolioCalculation_whenNoHoldings_returnsZeroes() {

        // When
        let summary = sut.execute(holdings: [])

        // Then
        XCTAssertEqual(summary.currentValue, 0)
        XCTAssertEqual(summary.totalInvestment, 0)
        XCTAssertEqual(summary.totalPNL, 0)
        XCTAssertEqual(summary.todaysPNL, 0)
    }
}

