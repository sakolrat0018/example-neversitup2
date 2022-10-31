//
//  CurrencyDataBase.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/30/22.
//

import RealmSwift

class Currency: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var timestamp: String = ""
    @Persisted var data = List<Detail_Currency>()
    
    convenience init(timestamp : String,data : List<Detail_Currency>) {
        self.init()
            self.timestamp = timestamp
            self.data      = data
    }
}

class Detail_Currency: Object {
    @Persisted var code: String     = ""
    @Persisted var symbol: String   = ""
    @Persisted var rate: String     = ""
    @Persisted var desc: String     = ""
    @Persisted var rateFloat: Float = 0.0
    
    convenience init(code: String, symbol: String, rate: String, desc: String, rateFloat: Float) {
        self.init()
            self.code      = code
            self.symbol    = symbol
            self.rate      = rate
            self.desc      = desc
            self.rateFloat = rateFloat
    }
}

class CurrencyDataBase: NSObject {
    func saveCurrency(data: CurrencyResponseModel.CurrencyPrice,
                      completion: @escaping () -> Void,
                      failure: @escaping ((_ error: Error) -> Void)) {
        let mirror   = Mirror(reflecting: data.bpi)
        let listCoin = List<Detail_Currency>()
        for child in mirror.children {
            let coinItem: CoinDetail = child.value as! CoinDetail
            let detail = Detail_Currency(code: coinItem.code, symbol: coinItem.symbol, rate: coinItem.rate, desc: coinItem.description, rateFloat: coinItem.rateFloat)
            listCoin.append(detail)
        }
        
        let currencyItem = Currency(timestamp: data.time.updated, data: listCoin)
       
        do {
            let realm = try? Realm()
            guard let realm = realm else { return }
            try realm.write {
                realm.add(currencyItem)
                completion()
            }
        }catch {
            failure(error)
        }
        
    }

    func getCurrency(completion: @escaping (Results<Currency>) -> Void){
        let realm = try? Realm()
        guard let realm = realm else { return }
        let historyItem = realm.objects(Currency.self)
        completion(historyItem)
    }
}
