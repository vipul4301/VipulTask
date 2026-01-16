//
//  PortfolioService.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

protocol PortfolioServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void)
}

final class PortfolioService: PortfolioServiceProtocol {
    
    private let client: APIClientProtocol
    private let cache: HoldingsCacheProtocol
    
    init(
        client: APIClientProtocol = APIClient(),
        cache: HoldingsCacheProtocol = HoldingsCache()
    ) {
        self.client = client
        self.cache = cache
    }
    
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void) {
        
        client.get(url: Endpoint.holdings.url) { (result: Result<HoldingsResponseDTO, Error>) in
            switch result {
            case .success(let response):
                let holdings = response.data.userHolding.map { $0.toDomain() }
                self.cache.save(holdings)
                completion(.success(holdings))
                
            case .failure(let error):
                let cached = self.cache.load()
                cached.isEmpty
                ? completion(.failure(error))
                : completion(.success(cached))
            }
        }
        
    }
}

