//
//  ErrorModel.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//

struct Welcome: Codable {
    let error: ErrorMessage
}

// MARK: - Error
struct ErrorMessage: Codable {
    let code, message: String
}
