//
//  settinngView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI

// Currency Manager to handle currency-related operations
class CurrencyManager {
    static let shared = CurrencyManager()
    
    static let currencies = [
        "USD", "EUR", "GBP", "SAR", "AED",
        "JPY", "CNY", "KWD", "BHD", "QAR",
        "OMR", "EGP", "JOD", "TRY", "MAD",
        "DZD", "TND", "LBP", "IQD", "CAD"
    ]
    
    static let currencyNames = [
        "دولار أمريكي", "يورو", "جنيه إسترليني", "ريال سعودي", "درهم إماراتي",
        "ين ياباني", "يوان صيني", "دينار كويتي", "دينار بحريني", "ريال قطري",
        "ريال عماني", "جنيه مصري", "دينار أردني", "ليرة تركية", "درهم مغربي",
        "دينار جزائري", "دينار تونسي", "ليرة لبنانية", "دينار عراقي", "دولار كندي"
    ]
    
    static let currencySymbolsAR: [String: String] = [
        "USD": "$", "EUR": "€", "GBP": "£", "SAR": "ر.س", "AED": "د.إ",
        "JPY": "¥", "CNY": "¥", "KWD": "د.ك", "BHD": "د.ب", "QAR": "ر.ق",
        "OMR": "ر.ع", "EGP": "ج.م", "JOD": "د.أ", "TRY": "₺", "MAD": "د.م",
        "DZD": "د.ج", "TND": "د.ت", "LBP": "ل.ل", "IQD": "د.ع", "CAD": "C$"
    ]
    
    static let currencySymbolsEN: [String: String] = [
        "USD": "$", "EUR": "€", "GBP": "£", "SAR": "SAR", "AED": "AED",
        "JPY": "¥", "CNY": "¥", "KWD": "KWD", "BHD": "BHD", "QAR": "QAR",
        "OMR": "OMR", "EGP": "EGP", "JOD": "JOD", "TRY": "₺", "MAD": "MAD",
        "DZD": "DZD", "TND": "TND", "LBP": "LBP", "IQD": "IQD", "CAD": "C$"
    ]
    
    static func getStoredCurrency(_ context: Any) -> String {
        return UserDefaults.standard.string(forKey: "selected_currency") ?? "USD"
    }
    
    static func storeCurrency(_ context: Any, _ currency: String) {
        UserDefaults.standard.set(currency, forKey: "selected_currency")
    }
    
    static func getCurrencyNamesAndSymbols(_ context: Any) -> ([String], [String]) {
        let isArabic = Locale.current.language.languageCode?.identifier == "ar"
        return (currencies, isArabic ? currencyNames : currencyNames)
    }
}

// Language and Currency Settings View
struct SettingsView: View {
    @State private var selectedCurrency: String = CurrencyManager.getStoredCurrency(())
    @State private var selectedLanguage: String = UserDefaults.standard.string(forKey: "selected_language") ?? "en"
    @State private var isEmailDialogPresented = false
    @State private var isShareDialogPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    headerView
                    
                    settingsSection
                    
                    communicationSection
                    
                    otherAppsSection
                }
                .padding()
            }
            .navigationTitle("Settings")
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Image(systemName: "gear")
            }
            Button(action: showTransactionHistory) {
                Image(systemName: "clock.arrow.circlepath")
            }
        }
    }
    private var settingsSection: some View {
        VStack(spacing: 16) {
            
            // Currency Selection
            currencySettingsRow
            
            // Language Selection
            languageSettingsRow
            
            // Rate App
            Button(action: rateApp) {
                HStack {
                    Image(systemName: "star")
                        .foregroundColor(.blue)
                    Text(selectedLanguage == "ar" ? "قيّم التطبيق" : "Rate App")
                    Spacer()
                    Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    private var currencySettingsRow: some View {
        Button(action: showCurrencySelection) {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(.blue)
                Text(selectedLanguage == "ar" ? "اختر العملة" : "Select Currency")
                Spacer()
                Text(selectedCurrency)
                    .foregroundColor(.secondary)
                Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }

    private var languageSettingsRow: some View {
        Button(action: showLanguageSelection) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.blue)
                Text(selectedLanguage == "ar" ? "اختر اللغة" : "Select Language")
                Spacer()
                Text(selectedLanguage == "ar" ? "العربية" : "English")
                    .foregroundColor(.secondary)
                Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
//    private var settingsSection: some View {
//        VStack(spacing: 16) {
//            // Currency Selection
//            Button(action: showCurrencySelection) {
//                HStack {
//                    Image(systemName: "dollarsign.circle")
//                    Text("Select Currency")
//                    Spacer()
//                    Text(selectedCurrency)
//                }
//            }
//            
//            // Language Selection
//            Button(action: showLanguageSelection) {
//                HStack {
//                    Image(systemName: "globe")
//                    Text("Select Language")
//                    Spacer()
//                    Text(selectedLanguage == "ar" ? "العربية" : "English")
//                }
//            }
//            
//            // Rate App
//            Button(action: rateApp) {
//                HStack {
//                    Image(systemName: "star")
//                    Text("Rate App")
//                    Spacer()
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 2)
//    }
    private var communicationSection: some View {
        VStack(spacing: 16) {
            Text("Help us to improve our app")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            communicationButton(
                icon: "star.fill",
                text: selectedLanguage == "ar" ? "قيّمنا" : "Rate Us",
                action: rateApp
            )
            
            communicationButton(
                icon: "envelope.fill",
                text: selectedLanguage == "ar" ? "شارك اقتراحك" : "Share Your Feedback",
                action: sendEmail
            )
            
            communicationButton(
                icon: "exclamationmark.triangle.fill",
                text: selectedLanguage == "ar" ? "هل تواجه مشكلة؟" : "Having Issues?",
                action: sendFeedbackEmail
            )
            
            communicationButton(
                icon: "heart.slash.fill",
                text: selectedLanguage == "ar" ? "لا تستمتع بالتطبيق؟" : "Not Enjoying the App?",
                action: sendFeedbackEmail
            )
            
            communicationButton(
                icon: "square.and.arrow.up",
                text: selectedLanguage == "ar" ? "شارك التطبيق مع الأصدقاء" : "Share App with Friends",
                action: shareApp
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    private func communicationButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(text)
                Spacer()
                Image(systemName: selectedLanguage == "ar" ? "chevron.left" : "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
//    private var communicationSection: some View {
//        VStack(spacing: 16) {
//            // Send Suggestion
//            Button(action: sendEmail) {
//                HStack {
//                    Image(systemName: "envelope")
//                    Text("Share Your Suggestion")
//                    Spacer()
//                }
//            }
//            
//            // Not Enjoying App
//            Button(action: sendFeedbackEmail) {
//                HStack {
//                    Image(systemName: "heart.slash")
//                    Text("Not Enjoying the App?")
//                    Spacer()
//                }
//            }
//            
//            // Share App
//            Button(action: shareApp) {
//                HStack {
//                    Image(systemName: "square.and.arrow.up")
//                    Text("Share App with Friends")
//                    Spacer()
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 2)
//    }
    
    private var otherAppsSection: some View {
        VStack(spacing: 16) {
            Text("Check Out Our Other Apps")
                .font(.headline)
            
            otherAppButton(
                imageName: "book",
                title: "Kitaba",
                packageName: "com.kitaba"
            )
            
            otherAppButton(
                imageName: "currency.exchange",
                title: "Currency Converter",
                packageName: "com.rabapp.currency.converter"
            )
            
            otherAppButton(
                imageName: "paintbrush",
                title: "Zaghrafa",
                packageName: "com.rabapp.zakhrapha"
            )
            
            otherAppButton(
                imageName: "figure.walk",
                title: "Khatawat",
                packageName: "com.rabapp.stepcounter"
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func otherAppButton(imageName: String, title: String, packageName: String) -> some View {
        Button(action: { openAppStore(packageName: packageName) }) {
            HStack {
                Image(systemName: imageName)
                Text(title)
                Spacer()
            }
        }
    }
    
    private func showCurrencySelection() {
        let (currencies, names) = CurrencyManager.getCurrencyNamesAndSymbols(())
        
        let alertController = UIAlertController(
            title: "اختر العملة",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        currencies.enumerated().forEach { (index, currency) in
            alertController.addAction(UIAlertAction(
                title: names[index],
                style: .default
            ) { _ in
                selectedCurrency = currency
                CurrencyManager.storeCurrency((), currency)
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert controller
        UIApplication.shared.windows.first?.rootViewController?.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
    
    private func showLanguageSelection() {
        let alertController = UIAlertController(
            title: "اختر اللغة / Select Language",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let languages = [
            ("English", "en"),
            ("العربية", "ar")
        ]
        
        languages.forEach { (name, code) in
            alertController.addAction(UIAlertAction(
                title: name,
                style: .default
            ) { _ in
                selectedLanguage = code
                UserDefaults.standard.set(code, forKey: "selected_language")
                // TODO: Implement language change logic
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert controller
        UIApplication.shared.windows.first?.rootViewController?.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
    
    private func showTransactionHistory() {
        // Implement transaction history navigation
    }
    
    private func rateApp() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6741729309?action=write-review") {
 
            UIApplication.shared.open(url)
        }
    }
    
    private func sendEmail() {
        // TODO: Implement email sending
    }
    
    private func sendFeedbackEmail() {
        // TODO: Implement feedback email sending
    }
    
//    private func shareApp() {
//        let appUrl = "https://apps.apple.com/app/id_your_app_id"
//        let activityViewController = UIActivityViewController(
//            activityItems: [appUrl],
//            applicationActivities: nil
//        )
//        
//        UIApplication.shared.windows.first?.rootViewController?.present(
//            activityViewController,
//            animated: true,
//            completion: nil
//        )
//    }
    private func shareApp() {
        let appUrl = "https://apps.apple.com/app/id6741729309"
        let activityViewController = UIActivityViewController(
            activityItems: [appUrl],
            applicationActivities: nil
        )
        UIApplication.shared.windows.first?.rootViewController?.present(
            activityViewController,
            animated: true
        )
    }
    private func openAppStore(packageName: String) {
        let urlString = "https://apps.apple.com/app/\(packageName)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
