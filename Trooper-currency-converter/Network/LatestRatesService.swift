//
//  LatestRatesService.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 16/06/2025.
//

import Foundation
import RxSwift


protocol LatestRatesServiceProtocol {
    func fetchlatestRates(base: String) -> Observable<LatestRateModel>
}

class LatestRatesService : LatestRatesServiceProtocol {
    private var networkService : NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchlatestRates(base: String) -> Observable<LatestRateModel> {
        let queryParameter = [
            "access_key" : AppConstant.apiKey,
            "base" : base
        ]
        let endpoint = APIEndpoint(path: AppConstant.latestRates,
                                          method: .get,
                                          headers: nil,
                                          queryParameters: queryParameter, body: nil)
        
        return networkService.performRequest(endpoint: endpoint, responseType: LatestRateModel.self)
    }
}
