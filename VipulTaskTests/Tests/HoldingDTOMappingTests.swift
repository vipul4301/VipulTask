//
//  HoldingDTOMappingTests.swift
//  VipulTaskTests
//
//  Created by Vipul Kumar on 16/01/26.
//

import XCTest
@testable import VipulTask

final class HoldingDTOMappingTests: XCTestCase {

    func testHoldingDTO_toDomain_mapsAllFieldsCorrectly() {

        // Given
        let dto = HoldingDTO(
            symbol: "INFY",
            quantity: 10,
            ltp: 1500,
            avgPrice: 1400,
            close: 1450
        )

        // When
        let domain = dto.toDomain()

        // Then
        XCTAssertEqual(domain.symbol, "INFY")
        XCTAssertEqual(domain.quantity, 10)
        XCTAssertEqual(domain.ltp, 1500)
        XCTAssertEqual(domain.avgPrice, 1400)
        XCTAssertEqual(domain.close, 1450)
    }
}
