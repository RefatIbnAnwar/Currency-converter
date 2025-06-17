//
//  HistoticalRateModel.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//

struct HistoricalRateModel: Codable {
    let success: Bool
    let timestamp: Int
    let historical: Bool
    let base, date: String
    let rates: [String: Double]
}


//{
//    "success": true,
//    "timestamp": 1387929599,
//    "historical": true,
//    "base": "EUR",
//    "date": "2013-12-24",
//    "rates": {
//        "USD": 1.367761,
//        "CAD": 1.453867,
//        "MYR": 4.505809
//    }
//}
