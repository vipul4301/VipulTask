//
//  Endpoint.swift
//  VipulTask
//
//  Created by Vipul Kumar on 15/01/26.
//

import Foundation

enum Endpoint {
    case holdings
    
    var url: URL {
        switch self {
        case .holdings:
            return URL(
                string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
            )!
        }
    }
}
