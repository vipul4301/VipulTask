//
//  HoldingDTO.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

struct HoldingDTO: Decodable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

extension HoldingDTO {
    func toDomain() -> Holding {
        Holding(
            symbol: symbol,
            quantity: quantity,
            ltp: ltp,
            avgPrice: avgPrice,
            close: close
        )
    }
}
