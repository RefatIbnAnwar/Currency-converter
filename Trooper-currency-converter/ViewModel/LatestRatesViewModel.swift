//
//  LatestRatesViewModel.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 16/06/2025.
//

import Foundation
import RxSwift
import RxRelay

class LatestRatesViewModel {
    var latestRates : BehaviorRelay<LatestRateModel?> = BehaviorRelay(value: nil)
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let error = PublishRelay<String>()
    
    var latestRatesService = LatestRatesService()
    
    
    private let disposeBag = DisposeBag()
    
    
    func fetchLatestRates(base: String) {
        latestRatesService.fetchlatestRates(base: base)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] data in
                    print("Data received from API: \(data)")
                    self?.latestRates.accept(data)
                    self?.isLoading.accept(false)
                    
                }) { [weak self] error in
                    self?.error.accept(error.localizedDescription)
                    self?.isLoading.accept(false)
                }
                .disposed(by: disposeBag)
    }
    
}

