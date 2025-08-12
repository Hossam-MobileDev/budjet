//
//  StringExtensions.swift
//  Wallet budget - مصاريف
//
//  Created by test on 09/08/2025.
//

import SwiftUI

import Foundation

extension String {
    /// Converts Arabic-Indic numerals (٠١٢٣٤٥٦٧٨٩) to Western numerals (0123456789)
    func convertingArabicNumeralsToWestern() -> String {
        let arabicNumerals = ["٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4", "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"]
        var result = self
        
        for (arabic, western) in arabicNumerals {
            result = result.replacingOccurrences(of: arabic, with: western)
        }
        
        return result
    }
    
    /// Validates if the string is a valid number (supports both Arabic and Western numerals)
    var isValidNumber: Bool {
        let convertedString = self.convertingArabicNumeralsToWestern()
        return Double(convertedString) != nil && !convertedString.isEmpty
    }
    
    /// Converts to Double after handling Arabic numerals
    var doubleValue: Double? {
        return Double(self.convertingArabicNumeralsToWestern())
    }
}
