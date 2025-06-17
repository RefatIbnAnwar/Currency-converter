//
//  HistoricalRatesViewModel.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//


import Foundation
import RxSwift
import RxRelay

class HistoricalRatesViewModel {
    var historicalRates : BehaviorRelay<HistoricalRateModel?> = BehaviorRelay(value: nil)
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let error = PublishRelay<String>()
    

    
    var historicalRatesService = HistoricalRatesService()
    
    var isInternetAvailable: Bool = false
    private let disposeBag = DisposeBag()
    
    init() {
        
    }

    func fetchHistoticalRates(base: String, isInternetAvailable: Bool) {
        if isInternetAvailable {
            historicalRatesService.fetchHistoricalRates(base: base)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] data in
                        print("Data received from API: \(data)")
                        self?.historicalRates.accept(data)
                        self?.isLoading.accept(false)
                        
                    }) { [weak self] error in
                        self?.error.accept(error.localizedDescription)
                        self?.isLoading.accept(false)
                    }
                    .disposed(by: disposeBag)
        }
        
    }
}

