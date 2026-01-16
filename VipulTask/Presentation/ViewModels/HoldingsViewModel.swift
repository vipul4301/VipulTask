//
//  HoldingsViewModel.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

final class HoldingsViewModel {

    private let service: PortfolioServiceProtocol
    private let calculator = CalculatePortfolioUseCase()

    private(set) var holdings: [Holding] = []
    private(set) var summary: PortfolioSummary?

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    init(service: PortfolioServiceProtocol = PortfolioService()) {
        self.service = service
    }

    func load() {
        service.fetchHoldings { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                            case .success(let holdings):
                                self.holdings = holdings
                                self.summary = self.calculator.execute(holdings: holdings)
                                self.onUpdate?()

                            case .failure:
                                self.onError?("Failed to load holdings")
                }
            }
        }
    }
}

