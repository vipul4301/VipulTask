//
//  HoldingsCache.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

protocol HoldingsCacheProtocol {
    func save(_ holdings: [Holding])
    func load() -> [Holding]
}

final class HoldingsCache: HoldingsCacheProtocol {
    
    private let key = "holdings_cache"
    
    func save(_ holdings: [Holding]) {
        let data = holdings.map {
            [
                "symbol": $0.symbol,
                "quantity": $0.quantity,
                "ltp": $0.ltp,
                "avgPrice": $0.avgPrice,
                "close": $0.close
            ]
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load() -> [Holding] {
        guard let raw = UserDefaults.standard.array(forKey: key) as? [[String: Any]]
        else { return [] }
        
        return raw.compactMap {
            guard
                let symbol = $0["symbol"] as? String,
                let quantity = $0["quantity"] as? Int,
                let ltp = $0["ltp"] as? Double,
                let avgPrice = $0["avgPrice"] as? Double,
                let close = $0["close"] as? Double
            else { return nil }
            
            return Holding(
                symbol: symbol,
                quantity: quantity,
                ltp: ltp,
                avgPrice: avgPrice,
                close: close
            )
        }
    }
}
