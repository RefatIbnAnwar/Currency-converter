//
//  APPConstant.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 15/06/2025.
//
import Foundation

struct AppConstant {
   
    static let baseUrl = "https://api.exchangeratesapi.io/v1"
    static let apiKey : String = "my_api_key"
    
    // Default values
    static let defaultBaseCurrency : String = "EUR"
    static let defaultConvertedCurrency : String = "MYR"
    
    // Path
    static let latestRates : String = "/latest"
}
