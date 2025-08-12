//
//  mainView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI



    
    // MARK: - Currency Management
//struct MainView: View {
//    @StateObject private var viewModel = BudgetViewModel()
//    @State private var selectedTab = 0
//    @State private var showTransactionHistory = false
//    @StateObject private var mainViewModel = MainViewModel()
//    @State private var showCurrencyPicker = false
//    @State private var selectedCurrency: String = AppSettings.shared.selectedCurrency
//    @StateObject private var languageManager = LanguageManager.shared
//    @EnvironmentObject var appOpenAdManager: AppOpenAdManager
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                TabView(selection: $selectedTab) {
//                    HomeView(
//                        onShowHistory: { showTransactionHistory = true },
//                        incomeViewModel: mainViewModel.incomeViewModel,
//                        outcomeViewModel: mainViewModel.outcomeViewModel,
//                        selectedCurrency: $selectedCurrency
//                    )
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                        Text(languageManager.isArabic ? "الرئيسية" : "Home")
//                    }
//                    .tag(0)
//                    
//                    IncomeView(viewModel: mainViewModel.incomeViewModel)
//                        .tabItem {
//                            Image(systemName: "plus.circle.fill")
//                                .renderingMode(.original)
//                            Text(languageManager.isArabic ? "الدخل" : "Income")
//                        }
//                        .tag(1)
//                    
//                    OutcomeView(viewModel: mainViewModel.outcomeViewModel, selectedCurrency: $selectedCurrency)
//                        .tabItem {
//                            Image(systemName: "minus.circle.fill")
//                                .renderingMode(.original)
//                            Text(languageManager.isArabic ? "المصروفات" : "Outcome")
//                        }
//                        .tag(2)
//                }
//                .tint(Color(red: 0.34, green: 0.65, blue: 0.56))
//                
//                // Bottom banner ad - positioned above tab bar
//                BannerAdView()
//                    .frame(height: 50)
//                    .background(Color.gray.opacity(0.1))
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    // Empty toolbar item (as in your original)
//                }
//            }
//            .sheet(isPresented: $showCurrencyPicker) {
//                CurrencyPickerView(selectedCurrency: $selectedCurrency)
//            }
//            .onChange(of: selectedCurrency) { newCurrency in
//                mainViewModel.incomeViewModel.updateCurrencySymbol(newCurrency)
//                mainViewModel.outcomeViewModel.updateCurrencySymbol(newCurrency)
//            }
//            .background(
//                NavigationLink(
//                    destination: TransactionHistoryView(
//                        incomeViewModel: mainViewModel.incomeViewModel,
//                        outcomeViewModel: mainViewModel.outcomeViewModel,
//                        selectedCurrency: $selectedCurrency
//                    ),
//                    isActive: $showTransactionHistory
//                ) {
//                    EmptyView()
//                }
//            )
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            // Show app open ad when returning from background
//            if appOpenAdManager.hasShownFirstAd {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    appOpenAdManager.showAdIfAvailable()
//                }
//            }
//        }
//    }
//}

struct MainView: View {
    @StateObject private var viewModel = BudgetViewModel()
    @State private var selectedTab = 0
    @State private var showTransactionHistory = false
    @StateObject private var mainViewModel = MainViewModel()
    @State private var showCurrencyPicker = false
    @State private var selectedCurrency: String = AppSettings.shared.selectedCurrency
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
            .onChange(of: selectedCurrency) { newCurrency in
                mainViewModel.incomeViewModel.updateCurrencySymbol(newCurrency)
                mainViewModel.outcomeViewModel.updateCurrencySymbol(newCurrency)
            }
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
                                    Text(currency)
                                        .font(.body)
                                    Spacer()
                                    if selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
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
                    // Header
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 16) {
                            // Settings Button
                            Button(action: { showSettings = true }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.purple.opacity(0.08))
                                        .frame(width: 48, height: 48)
                                    
                                    Image(systemName: "gear")
                                        .foregroundColor(.purple)
                                        .font(.system(size: 20, weight: .semibold))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // History Button
                            Button(action: onShowHistory) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.purple.opacity(0.08))
                                        .frame(width: 48, height: 48)
                                    
                                    Image(systemName: "clock.arrow.circlepath")
                                        .foregroundColor(.purple)
                                        .font(.system(size: 20, weight: .semibold))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    
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
                    
                    // Change Currency Button
                    Button(action: {
                        showCurrencyPicker = true
                    }) {
                        Text(languageManager.isArabic ? "تغيير العملة" : "Change Currency")
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

