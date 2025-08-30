//
//  mainView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI



 

struct MainView: View {
    @StateObject private var viewModel = BudgetViewModel()
    @State private var selectedTab = 0
    @State private var showTransactionHistory = false
    @StateObject private var mainViewModel = MainViewModel()
    @State private var showCurrencyPicker = false
    @State private var selectedCurrency: String = AppSettings.shared.selectedCurrency
    @EnvironmentObject var premiumManager: SubscriptionManager // Add this line

    @StateObject private var languageManager = LanguageManager.shared
//    @EnvironmentObject var appOpenAdManager: AppOpenAdManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    HomeView(
                        onShowHistory: { showTransactionHistory = true },
                        incomeViewModel: mainViewModel.incomeViewModel,
                        outcomeViewModel: mainViewModel.outcomeViewModel,
                        selectedCurrency: $selectedCurrency
                    )
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text(languageManager.isArabic ? "الرئيسية" : "Home")
                    }
                    .tag(0)
                    
                    IncomeView(viewModel: mainViewModel.incomeViewModel)
                        .tabItem {
                            Image("incomeicon")
                                .renderingMode(.original)

                            Text(languageManager.isArabic ? "الدخل" : "Income")
                        }
                        .tag(1)
                    
                    OutcomeView(viewModel: mainViewModel.outcomeViewModel, selectedCurrency: $selectedCurrency)
                        .tabItem {
                            Image("outcomeicon")
                                .renderingMode(.original)

                            Text(languageManager.isArabic ? "المصروفات" : "Outcome")
                        }
                        .tag(2)
                }
                .tint(Color(red: 0.34, green: 0.65, blue: 0.56))
                
                // Bottom banner ad - positioned above tab bar
                BannerAdView()
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.1))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Empty toolbar item (as in your original)
                }
            }
            .sheet(isPresented: $showCurrencyPicker) {
                CurrencyPickerView(selectedCurrency: $selectedCurrency)
            }
            .onAppear {
                        // Load the saved currency when the view appears
                        selectedCurrency = AppSettings.shared.selectedCurrency
                        
                        // Update the view models with the loaded currency
                        mainViewModel.incomeViewModel.updateCurrencySymbol(selectedCurrency)
                        mainViewModel.outcomeViewModel.updateCurrencySymbol(selectedCurrency)
                    }
                    .onChange(of: selectedCurrency) { newCurrency in
                        // Save immediately when currency changes
                        AppSettings.shared.selectedCurrency = newCurrency
                        mainViewModel.incomeViewModel.updateCurrencySymbol(newCurrency)
                        mainViewModel.outcomeViewModel.updateCurrencySymbol(newCurrency)
                    }
//            .onChange(of: selectedCurrency) { newCurrency in
//                mainViewModel.incomeViewModel.updateCurrencySymbol(newCurrency)
//                mainViewModel.outcomeViewModel.updateCurrencySymbol(newCurrency)
            
            .background(
                NavigationLink(
                    destination: TransactionHistoryView(
                        incomeViewModel: mainViewModel.incomeViewModel,
                        outcomeViewModel: mainViewModel.outcomeViewModel,
                        selectedCurrency: $selectedCurrency
                    ),
                    isActive: $showTransactionHistory
                ) {
                    EmptyView()
                }
            )
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
       
    }
    
   
}
    // MARK: - Currency Picker View
    struct CurrencyPickerView: View {
        @Binding var selectedCurrency: String
        @Environment(\.presentationMode) var presentationMode
        @StateObject private var languageManager = LanguageManager.shared
        
        private let currencies = [
            "USD", "EUR", "GBP", "SAR", "AED", "JPY", "KWD", "BHD", "OMR", "QAR",
            "CAD", "AUD", "NZD", "CHF", "CNY", "INR", "SGD", "HKD", "EGP", "JOD",
            "LBP", "TRY", "IQD", "YER", "MAD", "DZD", "TND", "LYD"
        ]
        
      
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(languageManager.isArabic ? "اختر العملة" : "Select Currency")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        ForEach(currencies, id: \.self) { currency in
                            Button(action: {
                                selectedCurrency = currency
                                AppSettings.shared.selectedCurrency = currency
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(getCurrencyName(currency, isArabic: languageManager.isArabic))
                                            .font(.body)
                                        if languageManager.isArabic {
                                            Text(currency)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    if selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                            }
                            .foregroundColor(.primary)
                        }
//
//                        ForEach(currencies, id: \.self) { currency in
//                            Button(action: {
//                                selectedCurrency = currency
//                                AppSettings.shared.selectedCurrency = currency
//                                presentationMode.wrappedValue.dismiss()
//                            }) {
//                                HStack {
//                                    Text(currency)
//                                        .font(.body)
//                                    Spacer()
//                                    if selectedCurrency == currency {
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.blue)
//                                    }
//                                }
//                            }
//                        }
                    }
                    .padding()
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(languageManager.isArabic ? "إلغاء" : "Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        }
    }

    

struct HomeView: View {
    let onShowHistory: () -> Void
    @ObservedObject var incomeViewModel: IncomeViewModel
    @ObservedObject var outcomeViewModel: OutcomeViewModel
    @Binding var selectedCurrency: String
    @State private var showCurrencyPicker = false
    @State private var showSettings = false
    @StateObject private var languageManager = LanguageManager.shared
    @State private var showUpgrade = false
    @EnvironmentObject var premiumManager: SubscriptionManager // Add this line

    init(
        onShowHistory: @escaping () -> Void,
        incomeViewModel: IncomeViewModel,
        outcomeViewModel: OutcomeViewModel,
        selectedCurrency: Binding<String>
    ) {
        self.onShowHistory = onShowHistory
        self.incomeViewModel = incomeViewModel
        self.outcomeViewModel = outcomeViewModel
        self._selectedCurrency = selectedCurrency
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Button(action: {
                                        if !premiumManager.isPremiumUser {
                                            showUpgrade = true
                                        }
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: premiumManager.isPremiumUser ? "checkmark.circle.fill" : "crown.fill")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            Text(premiumManager.isPremiumUser ?
                                                 (languageManager.isArabic ? "أنت مشترك" : "Subscribed") :
                                                 (languageManager.isArabic ? "ترقية" : "Upgrade")
                                            )
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(
                                            LinearGradient(
                                                colors: premiumManager.isPremiumUser ?
                                                    [Color.green, Color.green.opacity(0.8)] :
                                                    [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(20)
                                        .shadow(color: (premiumManager.isPremiumUser ? Color.green : Color(red: 1.0, green: 0.84, blue: 0.0)).opacity(0.3), radius: 4, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .disabled(premiumManager.isPremiumUser) // Disable button when subscribed
                                    
                    // Upgrade Button (Left side)
//                    Button(action: { showUpgrade = true }) {
//                        HStack(spacing: 6) {
//                            Image(systemName: "crown.fill")
//                                .font(.system(size: 16, weight: .bold))
//                                .foregroundColor(.white)
//                            
//                            Text(languageManager.isArabic ? "ترقية" : "Upgrade")
//                                .font(.system(size: 14, weight: .bold))
//                                .foregroundColor(.white)
//                        }
//                        .padding(.horizontal, 14)
//                        .padding(.vertical, 10)
//                        .background(
//                            LinearGradient(
//                                colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .cornerRadius(20)
//                        .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.3), radius: 4, x: 0, y: 2)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        // Settings Button with Label
                        Button(action: { showSettings = true }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.08))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "gear")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                
                                if languageManager.isArabic {
                                    Text("الإعدادات")
                                        .font(.custom("AlmaraiBold", size: 11))
                                        .foregroundColor(.blue)
                                        .lineLimit(1)
                                } else {
                                    VStack(spacing: 0) {
                                        Text("Settings")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // History Button with Label
                        Button(action: onShowHistory) {
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.08))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "clock.arrow.circlepath")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                
                                if languageManager.isArabic {
                                    Text("السجل")
                                        .font(.custom("AlmaraiBold", size: 11))
                                        .foregroundColor(.blue)
                                        .lineLimit(1)
                                } else {
                                    VStack(spacing: 0) {
                                        Text("History")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                
                // Summary Cards with EQUAL SIZING
                HStack(spacing: 12) {
                    // Income Card - FIXED SIZING
                    VStack(alignment: .leading, spacing: 8) {
                        Text(languageManager.isArabic ? "إجمالي الدخل" : "Total Income")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        let currentYear = Calendar.current.component(.year, from: Date())
                        let currentMonth = Calendar.current.component(.month, from: Date())
                        let totalIncome = incomeViewModel.getTotalIncomeForMonth(year: currentYear, month: currentMonth)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(incomeViewModel.currencySymbol)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(formatFullNumber(totalIncome))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    }
                    .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
                    .padding(12)
                    .background(Color(red: 0.298, green: 0.686, blue: 0.314))
                    .cornerRadius(12)
                    
                    // Month/Year Display - FIXED SIZING
                    VStack(spacing: 4) {
                        Text(getCurrentMonthName())
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Text(getCurrentYear())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(minWidth: 80, maxWidth: 80, minHeight: 90, maxHeight: 90)
                    
                    // Outcome Card - FIXED SIZING
                    VStack(alignment: .leading, spacing: 8) {
                        Text(languageManager.isArabic ? "إجمالي المصروفات" : "Total Outcome")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        let currentYear = Calendar.current.component(.year, from: Date())
                        let currentMonth = Calendar.current.component(.month, from: Date())
                        let totalOutcome = getCurrentMonthOutcome(year: currentYear, month: currentMonth)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(outcomeViewModel.currencySymbol)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(formatFullNumber(totalOutcome))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    }
                    .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
                    .padding(12)
                    .background(Color(red: 0.898, green: 0.451, blue: 0.451))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button(action: {
                    showCurrencyPicker = true
                }) {
                    Text(languageManager.isArabic ?
                         "تغيير العملة (\(getCurrencyName(selectedCurrency, isArabic: true)))" :
                         "Change Currency (\(selectedCurrency))")
                        .foregroundColor(.blue)
                        .underline()
                }
                
                // Chart
                TransactionChartView(
                    incomeViewModel: incomeViewModel,
                    outcomeViewModel: outcomeViewModel,
                    selectedCurrency: $selectedCurrency
                )
                .frame(height: 250)
                
                Text(languageManager.isArabic ? "الميزانية" : "Budget")
                    .font(.title3)
                    .foregroundColor(.black)
                
                // Recent Transactions Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(languageManager.isArabic ? "المعاملات الأخيرة" : "Recent Transactions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    let currentYear = Calendar.current.component(.year, from: Date())
                    let currentMonth = Calendar.current.component(.month, from: Date())
                    let currentMonthIncomes = incomeViewModel.getIncomesForMonth(year: currentYear, month: currentMonth)
                    
                    if currentMonthIncomes.isEmpty {
                        Text(languageManager.isArabic ? "لا توجد معاملات حديثة" : "No recent transactions")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(currentMonthIncomes) { income in
                            RecentTransactionRow(
                                title: income.description,
                                amount: income.amount,
                                date: income.date,
                                currencySymbol: incomeViewModel.currencySymbol
                            )
                        }
                    }
                }
                
                // Expenses Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(languageManager.isArabic ? "المصروفات" : "Expenses")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    let currentYear = Calendar.current.component(.year, from: Date())
                    let currentMonth = Calendar.current.component(.month, from: Date())
                    let currentMonthExpenses = outcomeViewModel.getExpensesForMonth(year: currentYear, month: currentMonth)
                    
                    if currentMonthExpenses.isEmpty {
                        Text(languageManager.isArabic ? "لا توجد مصروفات" : "No expenses")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(currentMonthExpenses) { expense in
                            CategoryRow(
                                name: expense.description,
                                amount: expense.amount,
                                date: formatDate(expense.date),
                                currencySymbol: outcomeViewModel.currencySymbol
                            )
                        }
                    }
                }
                
                // Add padding at bottom to account for banner ad
                Spacer()
                    .frame(height: 60)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showCurrencyPicker) {
            CurrencyPickerView(selectedCurrency: $selectedCurrency)
        }
        .sheet(isPresented: $showSettings) {
            SettinappView(togglefullscreen: $showSettings)
        }
        .sheet(isPresented: $showUpgrade) {
            SubscriptionView()
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        .onAppear {
            incomeViewModel.checkAndUpdateMonth()
        }
    }


        // MARK: - Helper Functions
        private func getCurrentMonthOutcome(year: Int, month: Int) -> Double {
            let currentMonthExpenses = outcomeViewModel.getExpensesForMonth(year: year, month: month)
            return currentMonthExpenses.reduce(0) { $0 + $1.amount }
        }
        
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
            return formatter.string(from: date)
        }
        
        private func getCurrentMonthName() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
            return formatter.string(from: Date())
        }
        
        private func getCurrentYear() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: Date())
        }
    }
    
    // MARK: - Category Row View
    struct CategoryRow: View {
        let name: String
        let amount: Double
        let date: String
        let currencySymbol: String
        @StateObject private var languageManager = LanguageManager.shared
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .foregroundColor(.red)
                        .font(.headline)
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(currencySymbol) \(formatFullNumber(amount))")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Recent Transaction Row View
    struct RecentTransactionRow: View {
        let title: String
        let amount: Double
        let date: Date
        let currencySymbol: String
        @StateObject private var languageManager = LanguageManager.shared
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.blue)
                        .font(.headline)
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(currencySymbol) \(formatFullNumber(amount))")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if languageManager.isArabic {
                formatter.locale = Locale(identifier: "ar")
            } else {
                formatter.locale = Locale(identifier: "en")
            }
            return formatter.string(from: date)
        }
    }

private func getCurrencyName(_ code: String, isArabic: Bool) -> String {
    if !isArabic {
        return code
    }
    
    let arabicCurrencies: [String: String] = [
        "USD": "دولار أمريكي",
        "EUR": "يورو",
        "GBP": "جنيه إسترليني",
        "SAR": "ريال سعودي",
        "AED": "درهم إماراتي",
        "JPY": "ين ياباني",
        "KWD": "دينار كويتي",
        "BHD": "دينار بحريني",
        "OMR": "ريال عماني",
        "QAR": "ريال قطري",
        "CAD": "دولار كندي",
        "AUD": "دولار أسترالي",
        "EGP": "جنيه مصري",
        "JOD": "دينار أردني",
        "TRY": "ليرة تركية"
    ]
    
    return arabicCurrencies[code] ?? code
}
