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
    
    var baseCurrencyRelay : BehaviorRelay<String> = BehaviorRelay(value: AppConstant.defaultBaseCurrency)
    var convertedCurrencyRelay: BehaviorRelay<String> = BehaviorRelay(value: AppConstant.defaultConvertedCurrency)
    
    var conversionRate: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    
    var latestRatesService = LatestRatesService()
    
    var isInternetAvailable: Bool = false
    
    init() {
        self.observebaseCurrencyChanges()
    }
    
    func observebaseCurrencyChanges() {
        convertedCurrencyRelay
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] newRate in
                self?.calculateConversionRate()
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    
    func fetchLatestRates(base: String, isInternetAvailable: Bool) {
        if isInternetAvailable {
            latestRatesService.fetchlatestRates(base: base)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] data in
                        print("Data received from API: \(data)")
                        self?.latestRates.accept(data)
                        self?.calculateConversionRate()
                        // delete Previous entry
                        CoreDataManager.shared.deleteAllRates()
                        // save in coredata
                        CoreDataManager.shared.saveLatestRate(data)
                        self?.isLoading.accept(false)
                        
                    }) { [weak self] error in
                        self?.error.accept(error.localizedDescription)
                        self?.isLoading.accept(false)
                    }
                    .disposed(by: disposeBag)
        } else {
            // fetch from code data
            guard let latestRate = CoreDataManager.shared.fetchLatestRate() else {
                return
            }
            self.latestRates.accept(latestRate)
            self.calculateConversionRate()
            self.isLoading.accept(false)
        }
        
    }
    
    func calculateConversionRate() {
        let currentBase = baseCurrencyRelay.value
        let convertedBase = convertedCurrencyRelay.value
        
        let latestRates = self.latestRates.value
        
        if let lr = latestRates {
            if currentBase == lr.base {
                self.conversionRate.accept(lr.rates[convertedBase] ?? 1.0)
            }
        }
    }
    
    func convert(to newBase: String) {
        guard let existingRateModel = self.latestRates.value else {
            print("no model found")
            return
        }
        guard let newBaseRate = existingRateModel.rates[newBase] else {
            print("Invalid base currency: \(newBase)")
            return
        }
        
        var convertedRates: [String: Double] = [:]
        
        
        for (currency, rate) in existingRateModel.rates {
            convertedRates[currency] = rate / newBaseRate
        }
        
        let newLatestRateModel = LatestRateModel(
            success: existingRateModel.success,
            timestamp: existingRateModel.timestamp,
            base: newBase,
            date: existingRateModel.date,
            rates: convertedRates
        )
        self.latestRates.accept(newLatestRateModel)
        self.baseCurrencyRelay.accept(newLatestRateModel.base)
        calculateConversionRate()
    }
    
}

