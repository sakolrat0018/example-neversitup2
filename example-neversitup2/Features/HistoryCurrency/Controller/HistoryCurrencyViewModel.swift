//
//  HistoryCurrencyViewModel.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/30/22.
//

import RealmSwift

class HistoryCurrencyViewModel: NSObject {
    
    var historyDataSuccessCallback: ((Results<Currency>) -> Void)?
    
    let currencyDatabase = CurrencyDataBase()
    
    
    func getHistoryCurrency() {
        currencyDatabase.getCurrency() { [weak self] response in
            guard let self = self else { return }
            self.historyDataSuccessCallback?(response)
        }
    }
}
