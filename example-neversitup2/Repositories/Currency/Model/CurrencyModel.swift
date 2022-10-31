//
//  CurrencyModel.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/28/22.
//

import Foundation

struct TimeUpdated : Codable {
    var updated: String
    var updatedISO: String
    var updateduk: String
}

struct BpiModel : Codable {
    var usd: CoinDetail
    var gbp: CoinDetail
    var eur: CoinDetail
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

struct CoinDetail : Codable {
    var code: String
    var symbol: String
    var rate: String
    var description: String
    var rateFloat: Float
    
    enum CodingKeys: String, CodingKey {
        case code
        case symbol,rate,description
        case rateFloat = "rate_float"
    }
}
