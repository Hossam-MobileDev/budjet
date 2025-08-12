//
//  languageManager.swift
//  budgetWallet
//
//  Created by test on 01/02/2025.
//

import SwiftUI

//class LanguageManager: ObservableObject {
//    static let shared = LanguageManager()
//    @Published var isArabic: Bool {
//        didSet {
//            UserDefaults.standard.set(isArabic, forKey: "isArabic")
//        }
//    }
//    
//    init() {
//        self.isArabic = UserDefaults.standard.bool(forKey: "isArabic")
//    }
//}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    @Published var isArabic: Bool {
        didSet {
            UserDefaults.standard.set(isArabic, forKey: "isArabic")
        }
    }
    
    init() {
        self.isArabic = UserDefaults.standard.bool(forKey: "isArabic")
    }
    
    func localizedString(arabic: String, english: String) -> String {
        return isArabic ? arabic : english
    }
    
    var supportedNumeralsErrorMessage: String {
        let supportedNumerals = isArabic ? "٠١٢٣٤٥٦٧٨٩ أو 0123456789" : "0123456789 or ٠١٢٣٤٥٦٧٨٩"
        return isArabic ?
            "يرجى استخدام أرقام صحيحة: \(supportedNumerals)" :
            "Please use valid numbers: \(supportedNumerals)"
    }
    
    func validationMessage(for field: String) -> String {
        return isArabic ? "الرجاء إدخال \(field)" : "Please enter \(field)"
    }
}
