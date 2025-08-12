//
//  trannsactionView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI

//struct TransactionHistoryView: View {
//    @State private var selectedYear = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth: String
//    @ObservedObject var incomeViewModel: IncomeViewModel
//    @ObservedObject var outcomeViewModel: OutcomeViewModel
//    @Binding var selectedCurrency: String
//    @StateObject private var languageManager = LanguageManager.shared
//    
//    private let months = [
//        ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
//        ["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//    ]
//    
//    private let arabicMonths = [
//        ["يناير", "فبراير", "مارس", "إبريل", "مايو", "يونيو"],
//        ["يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"]
//    ]
//    
//    init(incomeViewModel: IncomeViewModel, outcomeViewModel: OutcomeViewModel, selectedCurrency: Binding<String>) {
//        self.incomeViewModel = incomeViewModel
//        self.outcomeViewModel = outcomeViewModel
//        self._selectedCurrency = selectedCurrency
//        
//        // Set initial month based on current month
//        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
//        let currentMonthName = LanguageManager.shared.isArabic ?
//            arabicMonths.flatMap { $0 }[currentMonthIndex] :
//            months.flatMap { $0 }[currentMonthIndex]
//        self._selectedMonth = State(initialValue: currentMonthName)
//    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Year Selection with proper RTL support
//            HStack {
//                Button(action: {
//                    if languageManager.isArabic {
//                        selectedYear += 1  // In RTL, left button increases
//                    } else {
//                        selectedYear -= 1
//                    }
//                }) {
//                    Image(systemName: languageManager.isArabic ? "chevron.right" : "chevron.left")
//                        .foregroundColor(.black)
//                        .padding()
//                }
//                
//                Text(String(selectedYear))
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .frame(width: 100)
//                
//                Button(action: {
//                    if languageManager.isArabic {
//                        selectedYear -= 1  // In RTL, right button decreases
//                    } else {
//                        selectedYear += 1
//                    }
//                }) {
//                    Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
//                        .foregroundColor(.black)
//                        .padding()
//                }
//            }
//            
//            // Months Grid with better sizing for Arabic
//            VStack(spacing: 12) {
//                ForEach(languageManager.isArabic ? arabicMonths : months, id: \.self) { row in
//                    HStack(spacing: languageManager.isArabic ? 8 : 12) {
//                        ForEach(row, id: \.self) { month in
//                            Button(action: { selectedMonth = month }) {
//                                Text(month)
//                                    .font(.system(size: languageManager.isArabic ? 13 : 17, weight: .semibold))
//                                    .foregroundColor(selectedMonth == month ? .white : .black)
//                                    .frame(
//                                        width: languageManager.isArabic ? 55 : 50,
//                                        height: 40
//                                    )
//                                    .background(
//                                        selectedMonth == month
//                                            ? Color.purple
//                                            : Color.gray.opacity(0.2)
//                                    )
//                                    .cornerRadius(20)
//                                    .lineLimit(1)
//                                    .minimumScaleFactor(0.8)
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal, languageManager.isArabic ? 16 : 24)
//            
//            // Recent Transactions
//            ScrollView {
//                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 16) {
//                    Text(languageManager.isArabic ? "المعاملات الأخيرة" : "Recent Transactions")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .padding(.horizontal)
//                    
//                    // Income transactions
//                    ForEach(incomeViewModel.incomes.filter { isInSelectedMonth($0.date) }) { income in
//                        TransactionHistoryRow(
//                            title: income.description,
//                            amount: income.amount,
//                            date: income.date,
//                            isIncome: true,
//                            currencySymbol: incomeViewModel.currencySymbol
//                        )
//                    }
//                    
//                    // Outcome transactions
//                    ForEach(outcomeViewModel.categories) { category in
//                        if let expenses = outcomeViewModel.expenses[category.id] {
//                            ForEach(expenses.filter { isInSelectedMonth($0.date) }) { expense in
//                                TransactionHistoryRow(
//                                    title: expense.description,
//                                    amount: expense.amount,
//                                    date: expense.date,
//                                    isIncome: false,
//                                    currencySymbol: outcomeViewModel.currencySymbol
//                                )
//                            }
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//            }
//        }
//        .padding(.top)
//        .navigationTitle(languageManager.isArabic ? "سجل المعاملات" : "Transaction History")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    // Add your back navigation logic here
//                    // For example: presentationMode.wrappedValue.dismiss()
//                }) {
//                    HStack(spacing: 4) {
//                        Image(systemName: languageManager.isArabic ? "chevron.right" : "chevron.left")
//                            .font(.system(size: 16, weight: .medium))
//                        Text(languageManager.isArabic ? "رجوع" : "Back")
//                            .font(.system(size: 17))
//                    }
//                    .foregroundColor(.blue)
//                }
//            }
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//    
//    private func isInSelectedMonth(_ date: Date) -> Bool {
//        let components = Calendar.current.dateComponents([.year, .month], from: date)
//        let monthIndex = components.month ?? 1
//        let currentMonths = languageManager.isArabic ? arabicMonths.flatMap { $0 } : months.flatMap { $0 }
//        let monthName = currentMonths[monthIndex - 1]
//        return components.year == selectedYear && monthName == selectedMonth
//    }
//}
//
//struct TransactionHistoryRow: View {
//    let title: String
//    let amount: Double
//    let date: Date
//    let isIncome: Bool
//    let currencySymbol: String
//    @StateObject private var languageManager = LanguageManager.shared
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(isIncome ? .blue : .red)
//                    .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
//                Text(formatDate(date))
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            Text("\(currencySymbol) \(String(format: "%.0f", amount))")
//                .font(.headline)
//                .foregroundColor(isIncome ? .blue : .red)
//        }
//        .padding()
//        .background(isIncome ? Color.blue.opacity(0.1) : Color.red.opacity(0.1))
//        .cornerRadius(12)
//        .padding(.horizontal)
//    }
//    
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
//        return formatter.string(from: date)
//    }
//}

struct TransactionHistoryView: View {
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: String
    @ObservedObject var incomeViewModel: IncomeViewModel
    @ObservedObject var outcomeViewModel: OutcomeViewModel
    @Binding var selectedCurrency: String
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    private let months = [
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
        ["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    ]
    
    private let arabicMonths = [
        ["يناير", "فبراير", "مارس", "إبريل", "مايو", "يونيو"],
        ["يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"]
    ]
    
    init(incomeViewModel: IncomeViewModel, outcomeViewModel: OutcomeViewModel, selectedCurrency: Binding<String>) {
        self.incomeViewModel = incomeViewModel
        self.outcomeViewModel = outcomeViewModel
        self._selectedCurrency = selectedCurrency
        
        // Set initial month based on current month
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        let currentMonthName = LanguageManager.shared.isArabic ?
            arabicMonths.flatMap { $0 }[currentMonthIndex] :
            months.flatMap { $0 }[currentMonthIndex]
        self._selectedMonth = State(initialValue: currentMonthName)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Year Selection with proper RTL support
            HStack {
                Button(action: {
                    if languageManager.isArabic {
                        selectedYear += 1  // In RTL, left button increases
                    } else {
                        selectedYear -= 1
                    }
                }) {
                    Image(systemName: languageManager.isArabic ? "chevron.right" : "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Text(String(selectedYear))
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 100)
                
                Button(action: {
                    if languageManager.isArabic {
                        selectedYear -= 1  // In RTL, right button decreases
                    } else {
                        selectedYear += 1
                    }
                }) {
                    Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
            // Months Grid with better sizing for Arabic
            VStack(spacing: 12) {
                ForEach(languageManager.isArabic ? arabicMonths : months, id: \.self) { row in
                    HStack(spacing: languageManager.isArabic ? 8 : 12) {
                        ForEach(row, id: \.self) { month in
                            Button(action: { selectedMonth = month }) {
                                Text(month)
                                    .font(.system(size: languageManager.isArabic ? 13 : 17, weight: .semibold))
                                    .foregroundColor(selectedMonth == month ? .white : .black)
                                    .frame(
                                        width: languageManager.isArabic ? 55 : 50,
                                        height: 40
                                    )
                                    .background(
                                        selectedMonth == month
                                            ? Color.purple
                                            : Color.gray.opacity(0.2)
                                    )
                                    .cornerRadius(20)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, languageManager.isArabic ? 16 : 24)
            
            // Recent Transactions
            ScrollView {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 16) {
                    Text(languageManager.isArabic ? "المعاملات الأخيرة" : "Recent Transactions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Income transactions
                    ForEach(incomeViewModel.incomes.filter { isInSelectedMonth($0.date) }) { income in
                        TransactionHistoryRow(
                            title: income.description,
                            amount: income.amount,
                            date: income.date,
                            isIncome: true,
                            currencySymbol: incomeViewModel.currencySymbol
                        )
                    }
                    
                    // Outcome transactions
                    ForEach(outcomeViewModel.categories) { category in
                        if let expenses = outcomeViewModel.expenses[category.id] {
                            ForEach(expenses.filter { isInSelectedMonth($0.date) }) { expense in
                                TransactionHistoryRow(
                                    title: expense.description,
                                    amount: expense.amount,
                                    date: expense.date,
                                    isIncome: false,
                                    currencySymbol: outcomeViewModel.currencySymbol
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.top)
        .navigationTitle(languageManager.isArabic ? "سجل المعاملات" : "Transaction History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: languageManager.isArabic ? "chevron.right" : "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text(languageManager.isArabic ? "رجوع" : "Back")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    private func isInSelectedMonth(_ date: Date) -> Bool {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let monthIndex = components.month ?? 1
        let currentMonths = languageManager.isArabic ? arabicMonths.flatMap { $0 } : months.flatMap { $0 }
        let monthName = currentMonths[monthIndex - 1]
        return components.year == selectedYear && monthName == selectedMonth
    }
}

struct TransactionHistoryRow: View {
    let title: String
    let amount: Double
    let date: Date
    let isIncome: Bool
    let currencySymbol: String
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isIncome ? .blue : .red)
                    .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
                Text(formatDate(date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(currencySymbol) \(String(format: "%.0f", amount))")
                .font(.headline)
                .foregroundColor(isIncome ? .blue : .red)
        }
        .padding()
        .background(isIncome ? Color.blue.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
        return formatter.string(from: date)
    }
}
