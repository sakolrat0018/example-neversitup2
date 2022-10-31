//
//  CurrencyResponseModel.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/28/22.
//

import UIKit

class CurrencyResponseModel: NSObject {
    
    struct CurrencyPrice : Codable {
        var time: TimeUpdated
        var disclaimer: String
        var chartName: String
        var bpi: BpiModel
    }

}


