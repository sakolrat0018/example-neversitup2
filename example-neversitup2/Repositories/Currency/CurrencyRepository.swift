//
//  CurrencyRepositories.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/28/22.
//

import UIKit
import RxSwift

class CurrencyRepository: NSObject {
    
    func request<T: Decodable>(method: String, parameter:Any?, path: APIPathCurrency, type: T.Type) -> Observable<T> {
        return Observable.create{ (observer) -> Disposable in
            APIServices.request(method: method, parameter: parameter, path: path.path, type: type) {
                success,result,errors,statusCode in
                guard let results = result else {return}
                if success {
                    observer.onNext(results)
                }else{
                    observer.onError(errors as! Error)
                }
                
            }
            return Disposables.create()
        }
    }
    
    func callCurrencyPrice()-> Observable<CurrencyResponseModel.CurrencyPrice> {
        return self.request(method:"GET", parameter: nil, path: .price, type: CurrencyResponseModel.CurrencyPrice.self)
    }
}
