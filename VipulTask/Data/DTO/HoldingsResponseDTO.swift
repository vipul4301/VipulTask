//
//  HoldingsResponseDTO.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

struct HoldingsResponseDTO: Decodable {
    let data: HoldingsDataDTO
}

struct HoldingsDataDTO: Decodable {
    let userHolding: [HoldingDTO]
}
