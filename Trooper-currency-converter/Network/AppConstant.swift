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
    static let symbols = "USD,CAD,MYR,AED,CNY,SGD"
   
    // Path
    static let latestRates : String = "/latest"
    static func getDate() -> String {
        let today = Date()
        // Subtract 1 day
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = formatter.string(from: yesterday)
            print("Yesterday: \(formattedDate)")
            return formattedDate
        }
        return "2025-03-23"
    }
}
