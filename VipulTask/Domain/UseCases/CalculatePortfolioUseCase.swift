//
//  CalculatePortfolioUseCase.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

struct PortfolioSummary {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double
    let totalPNLPercentage: Double
}

final class CalculatePortfolioUseCase {
    
    func execute(holdings: [Holding]) -> PortfolioSummary {
        
        let currentValue = holdings.reduce(0) {
            $0 + ($1.ltp * Double($1.quantity))
        }
        
        let totalInvestment = holdings.reduce(0) {
            $0 + ($1.avgPrice * Double($1.quantity))
        }
        
        let totalPNL = currentValue - totalInvestment
        
        let totalPNLPercentage: Double
        if totalInvestment > 0 {
            totalPNLPercentage = (totalPNL / totalInvestment) * 100
        } else {
            totalPNLPercentage = 0
        }
        
        let todaysPNL = holdings.reduce(0) {
            $0 + (($1.close - $1.ltp) * Double($1.quantity))
        }
        
        return PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPNL: totalPNL,
            todaysPNL: todaysPNL,
            totalPNLPercentage: totalPNLPercentage
        )
    }
}
