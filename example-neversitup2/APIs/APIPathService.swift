//
//  APIPathService.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/28/22.
//

import Foundation

protocol BaseAPIRequestPath {
    var path: String { get }
}

enum APIPathCurrency: BaseAPIRequestPath {
    
    case price
    case none
    
    var path: String {
        switch self {
        case .price:
            return "/v1/bpi/currentprice.json"
        case .none:
            return ""
        }
    }
}
