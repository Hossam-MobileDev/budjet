//
//  appsetting.swift
//  budgetWallet
//
//  Created by test on 31/01/2025.
//

import SwiftUI

//class AppSettings {
//    static let shared = AppSettings()
//    private let defaults = UserDefaults.standard
//    
//    private let currencyKey = "selectedCurrency"
//    
//    var selectedCurrency: String {
//        get {
//            return defaults.string(forKey: currencyKey) ?? "USD"
//        }
//        set {
//            defaults.set(newValue, forKey: currencyKey)
//        }
//    }
//}

class AppSettings {
    static let shared = AppSettings()
    private let defaults = UserDefaults.standard
    
    private let currencyKey = "selectedCurrency"
    
    var selectedCurrency: String {
        get {
            return defaults.string(forKey: currencyKey) ?? "USD"
        }
        set {
            defaults.set(newValue, forKey: currencyKey)
            defaults.synchronize() // Add this line to force immediate save
        }
    }
}
