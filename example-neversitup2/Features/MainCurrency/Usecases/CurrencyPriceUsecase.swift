//
//  CurrencyPriceUsecase.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/30/22.
//

import RxSwift

class CurrencyPriceUsecase: NSObject {
    
    let disposeBag: DisposeBag = DisposeBag()
    let repository = CurrencyRepository()
    let currencyDatabase = CurrencyDataBase()
    
    func getCurrencyPrice(completion: @escaping ((_ response: CurrencyResponseModel.CurrencyPrice) -> Void),
                          failure: @escaping ((_ error: Error) -> Void)) {
        self.repository.callCurrencyPrice()
            .subscribe{ [weak self] response in
                guard let self = self else { return }
                self.currencyDatabase.saveCurrency(data: response) { () in
                    print("Complete Save Database!")
                } failure: { error in
                    print(error.localizedDescription)
                }
                completion(response)
            } onError: { (error) in
                failure(error)
            }.disposed(by:self.disposeBag)
    }
}
