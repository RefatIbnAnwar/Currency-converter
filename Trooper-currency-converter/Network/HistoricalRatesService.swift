//
//  HistoricalRatesService.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//

import Foundation
import RxSwift


protocol HistoricalRatesServiceProtocol {
    func fetchHistoricalRates(base: String) -> Observable<HistoricalRateModel>
}

class HistoricalRatesService : HistoricalRatesServiceProtocol {
    private var networkService : NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchHistoricalRates(base: String) -> Observable<HistoricalRateModel> {
        let queryParameter = [
            "access_key" : AppConstant.apiKey,
            "base" : base,
            "symbols" : AppConstant.symbols
        ]
        let endpoint = APIEndpoint(path: "/\(AppConstant.getDate())",
                                          method: .get,
                                          headers: nil,
                                          queryParameters: queryParameter, body: nil)
        
        return networkService.performRequest(endpoint: endpoint, responseType: HistoricalRateModel.self)
    }
}
