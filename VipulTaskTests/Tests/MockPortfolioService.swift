//
//  MockPortfolioService.swift
//  VipulTaskTests
//
//  Created by Vipul Kumar on 16/01/26.
//

@testable import VipulTask

final class MockPortfolioService: PortfolioServiceProtocol {

    var result: Result<[Holding], Error>!

    func fetchHoldings(
        completion: @escaping (Result<[Holding], Error>) -> Void
    ) {
        completion(result)
    }
}
