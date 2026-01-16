//
//  HoldingsViewModelTests.swift
//  VipulTaskTests
//
//  Created by Vipul Kumar on 15/01/26.
//

import XCTest
@testable import VipulTask

final class HoldingsViewModelTests: XCTestCase {

    private var viewModel: HoldingsViewModel!
    private var mockService: MockPortfolioService!

    override func setUp() {
        super.setUp()
        mockService = MockPortfolioService()
        viewModel = HoldingsViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoad_whenServiceReturnsHoldings_updatesHoldingsAndSummary() {

        // Given
        mockService.result = .success([
            Holding(
                symbol: "A",
                quantity: 10,
                ltp: 100,
                avgPrice: 90,
                close: 95
            )
        ])

        let expectation = expectation(description: "onUpdate called")

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        // When
        viewModel.load()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(viewModel.holdings.count, 1)
        XCTAssertNotNil(viewModel.summary)
    }

    func testLoad_whenServiceFails_callsOnError() {

        // Given
        mockService.result = .failure(
            NSError(domain: "test.network", code: -1)
        )

        let expectation = expectation(description: "onError called")

        viewModel.onError = { (_: String) in
            expectation.fulfill()
        }

        // When
        viewModel.load()

        // Then
        waitForExpectations(timeout: 1)
    }
}
