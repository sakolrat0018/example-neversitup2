//
//  MainCurrencyViewModel.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/29/22.
//

import Foundation

class MainCurrencyViewModel: NSObject {
    
    var currencyPriceSuccessCallback: ((CurrencyResponseModel.CurrencyPrice) -> Void)?
    var currencyConvertSuccessCallback: ((String) -> Void)?
    
    let usecase = CurrencyPriceUsecase()
    
    
    func getCurrencyPrice () {
        usecase.getCurrencyPrice {  [weak self] response in
            guard let self = self else { return }
            self.currencyPriceSuccessCallback?(response)
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    func convertCurrency(quantity: Float, typeSelect: String ,priceSelect: Float) {
        let result = typeSelect != "" ?  String(format: "%f %@ = %f BTC",quantity,typeSelect, quantity/priceSelect) : ""
        currencyConvertSuccessCallback?(result)
    }
}
