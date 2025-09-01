//
//  outcomeView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI
import CoreData
import Combine


public enum BudgetType {
    case income
    case outcome
}

public struct Categoryy: Identifiable, Hashable {
    public var id: UUID
    public var name: String
    public var budgetAmount: Double
    public var type: BudgetType
    public var isCategory: Bool
    public var date: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        budgetAmount: Double,
        type: BudgetType,
        isCategory: Bool = true,
        date: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.budgetAmount = budgetAmount
        self.type = type
        self.isCategory = isCategory
        self.date = date
    }
}

public struct Expensee: Identifiable, Hashable {
    public var id: UUID
    public var description: String
    public var amount: Double
    public var categoryId: UUID
    public var date: Date
    
    public init(
        id: UUID = UUID(),
        description: String,
        amount: Double,
        categoryId: UUID,
        date: Date = Date()
    ) {
        self.id = id
        self.description = description
        self.amount = amount
        self.categoryId = categoryId
        self.date = date
    }
}

class OutcomeViewModel: ObservableObject {
    @Published var categories: [Categoryy] = []
    @Published var expenses: [UUID: [Expensee]] = [:]
    @Published var currencySymbol: String = "$"
    private let persistenceController: CategoryExpensePersistenceController
    
    init(persistenceController: CategoryExpensePersistenceController = .shared) {
        self.persistenceController = persistenceController
        fetchCurrentMonthCategories()
    }
    
    // MARK: - Date Helpers
    private func isCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month], from: Date())
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        return currentComponents.year == dateComponents.year &&
               currentComponents.month == dateComponents.month
    }
    
    // MARK: - Current Month Data
    private func fetchCurrentMonthCategories() {
        let fetchedCategories = persistenceController.fetchCategories()
        
        categories = fetchedCategories
            .map { entity in
                Categoryy(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    budgetAmount: entity.budgetAmount,
                    type: entity.type == "income" ? .income : .outcome,
                    isCategory: entity.isCategory,
                    date: entity.date ?? Date()
                )
            }
            .filter { isCurrentMonth($0.date) }
        
        categories.forEach { category in
            guard let categoryEntity = fetchedCategories.first(where: { $0.id == category.id }) else { return }
            let categoryExpenses = persistenceController.fetchExpenses(for: categoryEntity)
            expenses[category.id] = categoryExpenses
                .map { createExpense(from: $0, categoryId: category.id) }
                .filter { isCurrentMonth($0.date) }
        }
    }
    
    // MARK: - Historical Data
    func getAllExpenses() -> [Expensee] {
        let fetchedCategories = persistenceController.fetchCategories()
        var allExpenses: [Expensee] = []
        
        for category in fetchedCategories {
            let categoryExpenses = persistenceController.fetchExpenses(for: category)
            allExpenses += categoryExpenses.map { createExpense(from: $0, categoryId: category.id ?? UUID()) }
        }
        
        return allExpenses
    }
    
    func getExpensesForMonth(year: Int, month: Int) -> [Expensee] {
        return getAllExpenses().filter { expense in
            let components = Calendar.current.dateComponents([.year, .month], from: expense.date)
            return components.year == year && components.month == month
        }
    }
    
    func getCategoriesForMonth(year: Int, month: Int) -> [Categoryy] {
        let fetchedCategories = persistenceController.fetchCategories()
        return fetchedCategories
            .map { entity in
                Categoryy(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    budgetAmount: entity.budgetAmount,
                    type: entity.type == "income" ? .income : .outcome,
                    isCategory: entity.isCategory,
                    date: entity.date ?? Date()
                )
            }
            .filter { category in
                let components = Calendar.current.dateComponents([.year, .month], from: category.date)
                return components.year == year && components.month == month
            }
    }
    
    // MARK: - Helper Methods
    private func createExpense(from entity: ExpenseEntity, categoryId: UUID) -> Expensee {
        return Expensee(
            id: entity.id ?? UUID(),
            description: entity.expenseDescription ?? "",
            amount: entity.amount,
            categoryId: categoryId,
            date: entity.date ?? Date()
        )
    }
    
    // MARK: - Data Management
    func addCategory(_ category: Categoryy) {
        guard isCurrentMonth(category.date) else {
            print("Cannot add category for past/future months")
            return
        }
        
        let _ = persistenceController.createCategory(
            name: category.name,
            budgetAmount: category.budgetAmount,
            type: category.type
        )
        
        fetchCurrentMonthCategories()
    }
    
    func updateCategory(_ category: Categoryy) {
        guard isCurrentMonth(category.date) else {
            print("Cannot update category from past/future months")
            return
        }
        
        guard let categoryEntity = persistenceController.fetchCategories()
            .first(where: { $0.id == category.id }) else { return }
        
        persistenceController.updateCategory(
            category: categoryEntity,
            name: category.name,
            budgetAmount: category.budgetAmount
        )
        
        fetchCurrentMonthCategories()
    }
    
    func deleteCategory(_ category: Categoryy) {
        guard let categoryEntity = persistenceController.fetchCategories()
            .first(where: { $0.id == category.id }) else { return }
        
        persistenceController.deleteCategory(categoryEntity)
        fetchCurrentMonthCategories()
    }
    
    func addExpense(_ expense: Expensee) {
        guard isCurrentMonth(expense.date) else {
            print("Cannot add expense for past/future months")
            return
        }
        
        guard let category = persistenceController.fetchCategories()
            .first(where: { $0.id == expense.categoryId }) else { return }
        
        let _ = persistenceController.createExpense(
            description: expense.description,
            amount: expense.amount,
            category: category
        )
        
        fetchCurrentMonthCategories()
    }
    
    func checkAndUpdateMonth() {
        fetchCurrentMonthCategories()
    }
    
    func updateCurrencySymbol(_ currency: String) {
        switch currency {
        case "USD":
            currencySymbol = "$"
        case "EUR":
            currencySymbol = "€"
        case "GBP":
            currencySymbol = "£"
        case "SAR":
            currencySymbol = "SAR"
        case "AED":
            currencySymbol = "AED"
        case "JPY":
            currencySymbol = "¥"
        case "KWD":
            currencySymbol = "KWD"
        case "BHD":
            currencySymbol = "BHD"
        case "OMR":
            currencySymbol = "OMR"
        case "QAR":
            currencySymbol = "QAR"
        case "CAD":
            currencySymbol = "CAD"
        case "AUD":
            currencySymbol = "AUD"
        case "NZD":
            currencySymbol = "NZD"
        case "CHF":
            currencySymbol = "CHF"
        case "CNY":
            currencySymbol = "CNY"
        case "INR":
            currencySymbol = "₹"
        case "SGD":
            currencySymbol = "SGD"
        case "HKD":
            currencySymbol = "HKD"
        case "EGP":
            currencySymbol = "EGP"
        case "JOD":
            currencySymbol = "JOD"
        case "LBP":
            currencySymbol = "LBP"
        case "TRY":
            currencySymbol = "TRY"
        case "IQD":
            currencySymbol = "IQD"
        case "YER":
            currencySymbol = "YER"
        case "MAD":
            currencySymbol = "MAD"
        case "DZD":
            currencySymbol = "DZD"
        case "TND":
            currencySymbol = "TND"
        case "LYD":
            currencySymbol = "LYD"
        default:
            currencySymbol = currency
        }
    }

}





struct CategoryCardView: View {
    // Properties
    let category: Categoryy
    let currencySymbol: String
    let expenses: [Expensee]
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onAddExpense: (Expensee) -> Void
    let onUpdateExpense: (Expensee) -> Void
    let onDeleteExpense: (Expensee) -> Void
    @ObservedObject private var languageManager = LanguageManager.shared
    
    // FIXED: Better state management for dialogs
    @State private var isExpanded = false
    @State private var showAddExpenseDialog = false
    @State private var selectedExpenseForEdit: Expensee?
    @State private var expenseToDelete: Expensee?
    
    // FIXED: Color constants
    private struct CardColors {
        static let primary = Color(red: 0.9, green: 0.29, blue: 0.1)
        static let expense = Color(red: 0.83, green: 0.18, blue: 0.18)
        static let success = Color(red: 0.22, green: 0.56, blue: 0.24)
        static let text = Color(red: 0.46, green: 0.46, blue: 0.46)
        static let background = Color(red: 0.98, green: 0.91, blue: 0.91)
    }
    
    // FIXED: Dimension constants
    private struct Dimensions {
        static let iconSize: CGFloat = 24
        static let progressBarWidth: CGFloat = 100
        static let progressBarHeight: CGFloat = 4
        static let cardPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
    }
    
    // Computed properties
    private var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    // FIXED: Status color computed property
    private var statusColor: Color {
        totalExpenses > category.budgetAmount ? CardColors.expense : CardColors.success
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return "\(currencySymbol) \(amount)"  // Remove the String(format: "%.0f", amount)
    }
    
  
    
    // FIXED: Computed binding for delete alert
    private var showDeleteAlert: Binding<Bool> {
        Binding(
            get: { expenseToDelete != nil },
            set: { if !$0 { expenseToDelete = nil } }
        )
    }
    
    // FIXED: Date formatters as computed properties (can be optimized further with @State)
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
        return formatter
    }
    
    private var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack(alignment: .top) {
                    // Left side with expand button and category info
                    HStack(spacing: 8) {
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(CardColors.primary)
                                .frame(width: Dimensions.iconSize, height: Dimensions.iconSize)
                        }
                        
                        VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                            Text(category.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(CardColors.expense)
                            Text(dateFormatter.string(from: category.date))
                                .font(.caption)
                                .foregroundColor(CardColors.text)
                        }
                    }
                    
                    Spacer()
                    
                    // Right side with amount and actions
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(formatCurrency(totalExpenses)) / \(formatCurrency(category.budgetAmount))")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(statusColor)
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: languageManager.isArabic ? .trailing : .leading) {
                                Rectangle()
                                    .frame(width: geometry.size.width, height: Dimensions.progressBarHeight)
                                    .opacity(0.2)
                                    .foregroundColor(.gray)
                                
                                Rectangle()
                                    .frame(width: min(CGFloat(totalExpenses / category.budgetAmount) * geometry.size.width, geometry.size.width), height: Dimensions.progressBarHeight)
                                    .foregroundColor(statusColor)
                            }
                            .cornerRadius(2)
                        }
                        .frame(width: Dimensions.progressBarWidth, height: Dimensions.progressBarHeight)
                        .padding(.vertical, 4)
                        
                        // Action Buttons
                        HStack(spacing: 8) {
                            Button(action: onEdit) {
                                Image(systemName: "pencil")
                                    .foregroundColor(CardColors.primary)
                                    .frame(width: 20, height: 20)
                            }
                            
                            Button(action: onDelete) {
                                Image(systemName: "trash")
                                    .foregroundColor(CardColors.expense)
                                    .frame(width: 20, height: 20)
                            }
                            
                            Button(action: { showAddExpenseDialog = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: Dimensions.iconSize, height: Dimensions.iconSize)
                                    .background(CardColors.primary)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                
                // Expandable Expenses List with Edit/Delete
                if !expenses.isEmpty && isExpanded {
                    VStack(spacing: 8) {
                        ForEach(expenses) { expense in
                            HStack {
                                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 2) {
                                    Text(expense.description)
                                        .font(.subheadline)
                                        .foregroundColor(CardColors.expense)
                                    Text(shortDateFormatter.string(from: expense.date))
                                        .font(.caption)
                                        .foregroundColor(CardColors.text)
                                }
                                
                                Spacer()
                                
                                Text(formatCurrency(expense.amount))
                                    .font(.subheadline)
                                    .foregroundColor(CardColors.expense)
                                
                                // FIXED: Expense Action Buttons
                                HStack(spacing: 4) {
                                    Button(action: {
                                        selectedExpenseForEdit = expense
                                    }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .foregroundColor(Color.blue.opacity(0.7))
                                            .font(.system(size: 18))
                                    }
                                    
                                    Button(action: {
                                        expenseToDelete = expense
                                    }) {
                                        Image(systemName: "trash.circle.fill")
                                            .foregroundColor(Color.red.opacity(0.7))
                                            .font(.system(size: 18))
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.leading, languageManager.isArabic ? 0 : 32)
                    .padding(.trailing, languageManager.isArabic ? 32 : 0)
                }
            }
            .padding(Dimensions.cardPadding)
        }
        .background(CardColors.background)
        .cornerRadius(Dimensions.cornerRadius)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, Dimensions.cardPadding)
        
        // FIXED: Add expense dialog
        .sheet(isPresented: $showAddExpenseDialog) {
            AddExpenseDialog(
                categoryName: category.name,
                currencySymbol: currencySymbol
            ) { description, amount in
                let expense = Expensee(
                    description: description,
                    amount: amount,
                    categoryId: category.id
                )
                onAddExpense(expense)
                isExpanded = true
            }
        }
        
        // FIXED: Edit expense dialog with proper item-based binding
        .sheet(item: $selectedExpenseForEdit) { expense in
            EditExpenseDialog(
                expense: expense,
                categoryName: category.name,
                currencySymbol: currencySymbol
            ) { updatedDescription, updatedAmount in
                var updatedExpense = expense
                updatedExpense.description = updatedDescription
                updatedExpense.amount = updatedAmount
                onUpdateExpense(updatedExpense)
            }
        }
        
        // FIXED: Delete alert with computed binding
        .alert(languageManager.localizedString(arabic: "حذف المصروف", english: "Delete Expense"),
               isPresented: showDeleteAlert) {
            Button(languageManager.localizedString(arabic: "حذف", english: "Delete"), role: .destructive) {
                if let expense = expenseToDelete {
                    onDeleteExpense(expense)
                }
            }
            Button(languageManager.localizedString(arabic: "إلغاء", english: "Cancel"), role: .cancel) {
                // expenseToDelete will be automatically set to nil by the binding
            }
        } message: {
            Text(languageManager.localizedString(
                arabic: "هل أنت متأكد أنك تريد حذف هذا المصروف؟",
                english: "Are you sure you want to delete this expense?"
            ))
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

public struct AddCategoryDialog: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var languageManager = LanguageManager.shared
    let currencySymbol: String
    var initialCategory: Categoryy?
    let onSave: (String, Double) -> Void
    
    @State private var categoryName: String = ""
    @State private var budgetAmount: String = ""
    @State private var showNameError = false
    @State private var showAmountError = false
    @State private var amountErrorMessage = ""
    @State private var selectedPredefinedCategory: String?
    
    private var predefinedCategories: [(arabic: String, english: String)] = [
        ("البقالة", "Groceries"),
        ("الإيجار", "Rent"),
        ("المرافق", "Utilities"),
        ("المواصلات", "Transportation"),
        ("الترفيه", "Entertainment"),
        ("الرعاية الصحية", "Healthcare"),
        ("التسوق", "Shopping"),
        ("أخرى", "Other")
    ]
    
    public init(currencySymbol: String, initialCategory: Categoryy? = nil, onSave: @escaping (String, Double) -> Void) {
        self.currencySymbol = currencySymbol
        self.initialCategory = initialCategory
        self.onSave = onSave
        
        if let category = initialCategory {
            _categoryName = State(initialValue: category.name)
            _budgetAmount = State(initialValue: String(category.budgetAmount))  // Remove format: "%.2f"
        }
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(predefinedCategories, id: \.english) { category in
                            let categoryText = languageManager.isArabic ? category.arabic : category.english
                            Button(action: {
                                selectedPredefinedCategory = categoryText
                                categoryName = categoryText
                                showNameError = false
                            }) {
                                Text(categoryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedPredefinedCategory == categoryText
                                            ? Color.blue.opacity(0.2)
                                            : Color.gray.opacity(0.1)
                                    )
                                    .foregroundColor(
                                        selectedPredefinedCategory == categoryText
                                            ? .blue
                                            : .primary
                                    )
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
                    VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                        TextField(languageManager.localizedString(arabic: "اسم الفئة", english: "Category Name"), text: $categoryName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: categoryName) { _ in
                                showNameError = false
                            }
                        
                        if showNameError {
                            Text(languageManager.localizedString(arabic: "الرجاء إدخال اسم الفئة", english: "Please enter a category name"))
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                        HStack {
                            Text(currencySymbol)
                                .foregroundColor(.gray)
                            TextField(languageManager.localizedString(arabic: "مبلغ الميزانية", english: "Budget Amount"), text: $budgetAmount)
                                .keyboardType(.decimalPad) // CHANGED from .decimalPad
                                .onChange(of: budgetAmount) { newValue in
                                    // UPDATED VALIDATION WITH ARABIC NUMERALS SUPPORT
                                    if newValue.isEmpty {
                                        showAmountError = true
                                        amountErrorMessage = languageManager.validationMessage(for: languageManager.localizedString(arabic: "مبلغ الميزانية", english: "budget amount"))
                                    } else if newValue.isValidNumber {
                                        if let value = newValue.doubleValue, value > 0 {
                                            showAmountError = false
                                            amountErrorMessage = ""
                                        } else {
                                            showAmountError = true
                                            amountErrorMessage = languageManager.localizedString(arabic: "يجب أن يكون المبلغ أكبر من صفر", english: "Amount must be greater than zero")
                                        }
                                    } else {
                                        showAmountError = true
                                        amountErrorMessage = languageManager.supportedNumeralsErrorMessage
                                    }
                                }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if showAmountError {
                            Text(amountErrorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle(initialCategory == nil ?
                           languageManager.localizedString(arabic: "إضافة فئة", english: "Add Category") :
                           languageManager.localizedString(arabic: "تعديل الفئة", english: "Edit Category"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(languageManager.localizedString(arabic: "إلغاء", english: "Cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(initialCategory == nil ?
                          languageManager.localizedString(arabic: "إضافة", english: "Add") :
                          languageManager.localizedString(arabic: "حفظ", english: "Save")) {
                        validate()
                    }
                }
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    private func validate() {
        showNameError = categoryName.trimmingCharacters(in: .whitespaces).isEmpty
        
        // UPDATED VALIDATION WITH ARABIC NUMERALS SUPPORT
        if budgetAmount.isEmpty {
            showAmountError = true
            amountErrorMessage = languageManager.validationMessage(for: languageManager.localizedString(arabic: "مبلغ الميزانية", english: "budget amount"))
        } else if !budgetAmount.isValidNumber {
            showAmountError = true
            amountErrorMessage = languageManager.supportedNumeralsErrorMessage
        } else if let amount = budgetAmount.doubleValue, amount <= 0 {
            showAmountError = true
            amountErrorMessage = languageManager.localizedString(arabic: "يجب أن يكون المبلغ أكبر من صفر", english: "Amount must be greater than zero")
        } else {
            showAmountError = false
            amountErrorMessage = ""
        }
        
        // UPDATED TO USE doubleValue instead of Double()
        if !showNameError && !showAmountError,
           let amount = budgetAmount.doubleValue {
            onSave(categoryName, amount)
            dismiss()
        }
    }
}


struct AddExpenseDialog: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var languageManager = LanguageManager.shared
    let categoryName: String
    let currencySymbol: String
    let onSave: (String, Double) -> Void
    
    @State private var description = ""
    @State private var amount = ""
    @State private var showDescriptionError = false
    @State private var showAmountError = false
    @State private var amountErrorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                        TextField("", text: $description)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(showDescriptionError ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .overlay(
                                Text(languageManager.localizedString(arabic: "الوصف", english: "Description"))
                                    .font(.caption)
                                    .foregroundColor(showDescriptionError ? .red : .gray)
                                    .padding(.horizontal, 4)
                                    .background(Color.white)
                                    .offset(x: 8, y: -8),
                                alignment: .topLeading
                            )
                            .onChange(of: description) { _ in
                                showDescriptionError = description.trimmingCharacters(in: .whitespaces).isEmpty
                            }
                        
                        if showDescriptionError {
                            Text(languageManager.localizedString(arabic: "الرجاء إدخال وصف", english: "Please enter a description"))
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.leading, 8)
                        }
                    }
                    
                    VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                        HStack {
                            Text(currencySymbol)
                                .foregroundColor(.gray)
                            TextField("", text: $amount)
                                .keyboardType(.decimalPad) // CHANGED from .decimalPad
                                .onChange(of: amount) { newValue in
                                    // UPDATED VALIDATION WITH ARABIC NUMERALS SUPPORT
                                    if newValue.isEmpty {
                                        showAmountError = true
                                        amountErrorMessage = languageManager.validationMessage(for: languageManager.localizedString(arabic: "المبلغ", english: "amount"))
                                    } else if newValue.isValidNumber {
                                        if let value = newValue.doubleValue, value > 0 {
                                            showAmountError = false
                                            amountErrorMessage = ""
                                        } else {
                                            showAmountError = true
                                            amountErrorMessage = languageManager.localizedString(arabic: "يجب أن يكون المبلغ أكبر من صفر", english: "Amount must be greater than zero")
                                        }
                                    } else {
                                        showAmountError = true
                                        amountErrorMessage = languageManager.supportedNumeralsErrorMessage
                                    }
                                }
                        }
                        .padding(8)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(showAmountError ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .overlay(
                            Text(languageManager.localizedString(arabic: "المبلغ", english: "Amount"))
                                .font(.caption)
                                .foregroundColor(showAmountError ? .red : .gray)
                                .padding(.horizontal, 4)
                                .background(Color.white)
                                .offset(x: 8, y: -8),
                            alignment: .topLeading
                        )
                        
                        if showAmountError {
                            Text(amountErrorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.leading, 8)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle(languageManager.localizedString(
                arabic: "إضافة مصروف إلى \(categoryName)",
                english: "Add Expense to \(categoryName)"
            ))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(languageManager.localizedString(arabic: "إلغاء", english: "Cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(languageManager.localizedString(arabic: "إضافة", english: "Add")) {
                        validate()
                    }
                }
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        .presentationDetents([.height(280)])
    }
    
    private func validate() {
        showDescriptionError = description.trimmingCharacters(in: .whitespaces).isEmpty
        
        // UPDATED VALIDATION WITH ARABIC NUMERALS SUPPORT
        if amount.isEmpty {
            showAmountError = true
            amountErrorMessage = languageManager.validationMessage(for: languageManager.localizedString(arabic: "المبلغ", english: "amount"))
        } else if !amount.isValidNumber {
            showAmountError = true
            amountErrorMessage = languageManager.supportedNumeralsErrorMessage
        } else if let amountValue = amount.doubleValue, amountValue <= 0 {
            showAmountError = true
            amountErrorMessage = languageManager.localizedString(arabic: "يجب أن يكون المبلغ أكبر من صفر", english: "Amount must be greater than zero")
        } else {
            showAmountError = false
            amountErrorMessage = ""
        }
        
        // UPDATED TO USE doubleValue instead of Double()
        if !showDescriptionError && !showAmountError,
           let amountValue = amount.doubleValue {
            onSave(description, amountValue)
            dismiss()
        }
    }
}
struct FABB: View {
    let systemImage: String
    let backgroundColor: Color
    let action: () -> Void
    
    init(
        systemImage: String = "plus",
        backgroundColor: Color = Color(red: 0.9, green: 0.29, blue: 0.1),
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.white)
                .padding(18)
                .background(backgroundColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(FABButtonStylee()) // FIXED: Using correct style name
        .accessibilityLabel("Add Category")
    }
}


struct FABButtonStylee: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.1 : 0)
    }
}



struct OutcomeView: View {
    @ObservedObject var viewModel: OutcomeViewModel
    @Binding var selectedCurrency: String
    @ObservedObject private var languageManager = LanguageManager.shared
    @Environment(\.scenePhase) private var scenePhase

    @State private var showAddDialog = false
    // FIXED: Use single item-based state for category editing
    @State private var selectedCategoryForEdit: Categoryy?
    @State private var showDeleteConfirmationDialog = false
    @State private var categoryToDelete: Categoryy?
    @State private var showWrongMonthAlert = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
        return formatter
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack {
                            Text(dateFormatter.string(from: Date()).uppercased())
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding()
                        
                        // Categories
                        if viewModel.categories.isEmpty {
                            VStack {
                                Text(languageManager.isArabic ? "لا توجد فئات لهذا الشهر" : "No Categories for this month")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                Text(languageManager.isArabic ? "انقر فوق + لإضافة فئات" : "Click + to Add Categories")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        } else {
                            ForEach(viewModel.categories.filter { $0.isCategory }, id: \.self) { category in
                                CategoryCardView(
                                    category: category,
                                    currencySymbol: viewModel.currencySymbol,
                                    expenses: viewModel.expenses[category.id] ?? [],
                                    onEdit: {
                                        // FIXED: Direct assignment to trigger sheet
                                        selectedCategoryForEdit = category
                                    },
                                    onDelete: {
                                        categoryToDelete = category
                                        showDeleteConfirmationDialog = true
                                    },
                                    onAddExpense: { expense in
                                        viewModel.addExpense(expense)
                                    },
                                    onUpdateExpense: { expense in
                                        viewModel.updateExpense(expense)
                                    },
                                    onDeleteExpense: { expense in
                                        viewModel.deleteExpense(expense)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 80)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FABB(action: {
                            showAddDialog = true
                        })
                        .padding(16)
                    }
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.checkAndUpdateMonth()
            }
        }
        .onAppear {
            viewModel.checkAndUpdateMonth()
        }
        
        // Add category dialog
        .sheet(isPresented: $showAddDialog) {
            AddCategoryDialog(
                currencySymbol: viewModel.currencySymbol
            ) { name, amount in
                let newCategory = Categoryy(
                    name: name,
                    budgetAmount: amount,
                    type: .outcome
                )
                viewModel.addCategory(newCategory)
            }
        }
        
        // FIXED: Edit category dialog with item-based binding
        .sheet(item: $selectedCategoryForEdit) { category in
            AddCategoryDialog(
                currencySymbol: viewModel.currencySymbol,
                initialCategory: category
            ) { name, amount in
                var updatedCategory = category
                updatedCategory.name = name
                updatedCategory.budgetAmount = amount
                viewModel.updateCategory(updatedCategory)
            }
        }
        
        .alert(languageManager.isArabic ? "حذف الفئة" : "Delete Category",
               isPresented: $showDeleteConfirmationDialog) {
            Button(languageManager.isArabic ? "حذف" : "Delete", role: .destructive) {
                if let category = categoryToDelete {
                    viewModel.deleteCategory(category)
                    categoryToDelete = nil
                }
            }
            Button(languageManager.isArabic ? "إلغاء" : "Cancel", role: .cancel) {
                categoryToDelete = nil
            }
        } message: {
            Text(languageManager.isArabic ?
                 "هل أنت متأكد أنك تريد حذف هذه الفئة \(categoryToDelete?.name ?? "")؟" :
                 "Are you sure you want to delete this category \(categoryToDelete?.name ?? "")?")
        }
        .alert(languageManager.isArabic ? "تنبيه" : "Alert", isPresented: $showWrongMonthAlert) {
            Button(languageManager.isArabic ? "حسناً" : "OK", role: .cancel) { }
        } message: {
            Text(languageManager.isArabic ?
                 "يمكنك فقط إضافة أو تعديل النفقات للشهر الحالي" :
                 "You can only add or modify expenses for the current month")
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}



extension OutcomeViewModel {
    
    func updateExpense(_ expense: Expensee) {
        guard isCurrentMonth(expense.date) else {
            print("Cannot update expense from past/future months")
            return
        }
        
        guard let categoryEntity = persistenceController.fetchCategories()
            .first(where: { $0.id == expense.categoryId }),
              let expenseEntity = persistenceController.fetchExpenses(for: categoryEntity)
            .first(where: { $0.id == expense.id }) else { return }
        
        // Using your existing method signature
        persistenceController.updateExpense(
            expense: expenseEntity,
            description: expense.description,
            amount: expense.amount
        )
        
        fetchCurrentMonthCategories()
    }
    
    func deleteExpense(_ expense: Expensee) {
        guard let categoryEntity = persistenceController.fetchCategories()
            .first(where: { $0.id == expense.categoryId }),
              let expenseEntity = persistenceController.fetchExpenses(for: categoryEntity)
            .first(where: { $0.id == expense.id }) else { return }
        
        persistenceController.deleteExpense(expenseEntity)
        fetchCurrentMonthCategories()
    }
}



extension CategoryExpensePersistenceController {
    // These methods use the correct parameter names to match your existing methods
    func updateExpenseWithNewSignature(
        expense: ExpenseEntity,
        description: String,
        amount: Double
    ) {
        updateExpense(expense: expense, description: description, amount: amount)
    }
    
    func updateCategoryWithNewSignature(
        category: CategoryEntity,
        name: String,
        budgetAmount: Double
    ) {
        updateCategory(category: category, name: name, budgetAmount: budgetAmount)
    }
    
    // Add viewContext property for easier access
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}

struct EditExpenseDialog: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var languageManager = LanguageManager.shared
    let expense: Expensee
    let categoryName: String
    let currencySymbol: String
    let onSave: (String, Double) -> Void
    
    @State private var description: String
    @State private var amount: String
    @State private var showDescriptionError = false
    @State private var showAmountError = false
    @State private var amountErrorMessage = ""
    
    // FIXED: Proper initialization with format control
    init(expense: Expensee, categoryName: String, currencySymbol: String, onSave: @escaping (String, Double) -> Void) {
        self.expense = expense
        self.categoryName = categoryName
        self.currencySymbol = currencySymbol
        self.onSave = onSave
        
        // FIXED: Initialize with original values, avoid .2f for whole numbers
        self._description = State(initialValue: expense.description)
        let formattedAmount = expense.amount.truncatingRemainder(dividingBy: 1) == 0 ?
            String(format: "%.0f", expense.amount) :
            String(format: "%.2f", expense.amount)
        self._amount = State(initialValue: String(expense.amount))  // Remove the formatting logic
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // FIXED: Better spacing and layout
                VStack(spacing: 16) {
                    // Description Field
                    VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 8) {
                        Text(languageManager.localizedString(arabic: "الوصف", english: "Description"))
                            .font(.headline)
                            .foregroundColor(showDescriptionError ? .red : .primary)
                        
                        TextField(languageManager.localizedString(arabic: "أدخل الوصف", english: "Enter description"), text: $description)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(showDescriptionError ? Color.red : Color.clear, lineWidth: 1)
                            )
                            .onChange(of: description) { _ in
                                showDescriptionError = description.trimmingCharacters(in: .whitespaces).isEmpty
                            }
                        
                        if showDescriptionError {
                            Text(languageManager.localizedString(arabic: "الرجاء إدخال وصف", english: "Please enter a description"))
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Amount Field
                    VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 8) {
                        Text(languageManager.localizedString(arabic: "المبلغ", english: "Amount"))
                            .font(.headline)
                            .foregroundColor(showAmountError ? .red : .primary)
                        
                        HStack {
                            Text(currencySymbol)
                                .foregroundColor(.secondary)
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField(languageManager.localizedString(arabic: "أدخل المبلغ", english: "Enter amount"), text: $amount)
                                .keyboardType(.decimalPad)
                                .onChange(of: amount) { newValue in
                                    validateAmount(newValue)
                                }
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(showAmountError ? Color.red : Color.clear, lineWidth: 1)
                        )
                        .cornerRadius(8)
                        
                        if showAmountError {
                            Text(amountErrorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle(languageManager.localizedString(arabic: "تعديل المصروف", english: "Edit Expense"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(languageManager.localizedString(arabic: "إلغاء", english: "Cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(languageManager.localizedString(arabic: "حفظ", english: "Save")) {
                        saveExpense()
                    }
                    .disabled(showDescriptionError || showAmountError || description.isEmpty || amount.isEmpty)
                }
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        .presentationDetents([.height(400)]) // FIXED: Increased height
    }
    
    // FIXED: Separated validation logic
    private func validateAmount(_ newValue: String) {
        if newValue.isEmpty {
            showAmountError = true
            amountErrorMessage = languageManager.localizedString(arabic: "الرجاء إدخال مبلغ", english: "Please enter an amount")
            return
        }
        
        // Handle both Arabic and English numerals
        let cleanValue = newValue.replacingOccurrences(of: "٫", with: ".")
            .replacingOccurrences(of: "٠", with: "0")
            .replacingOccurrences(of: "١", with: "1")
            .replacingOccurrences(of: "٢", with: "2")
            .replacingOccurrences(of: "٣", with: "3")
            .replacingOccurrences(of: "٤", with: "4")
            .replacingOccurrences(of: "٥", with: "5")
            .replacingOccurrences(of: "٦", with: "6")
            .replacingOccurrences(of: "٧", with: "7")
            .replacingOccurrences(of: "٨", with: "8")
            .replacingOccurrences(of: "٩", with: "9")
        
        if let value = Double(cleanValue), value > 0 {
            showAmountError = false
            amountErrorMessage = ""
        } else {
            showAmountError = true
            amountErrorMessage = languageManager.localizedString(arabic: "يجب أن يكون المبلغ أكبر من صفر", english: "Amount must be greater than zero")
        }
    }
    
    // FIXED: Improved save logic
    private func saveExpense() {
        let trimmedDescription = description.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedDescription.isEmpty else {
            showDescriptionError = true
            return
        }
        
        let cleanAmount = amount.replacingOccurrences(of: "٫", with: ".")
            .replacingOccurrences(of: "٠", with: "0")
            .replacingOccurrences(of: "١", with: "1")
            .replacingOccurrences(of: "٢", with: "2")
            .replacingOccurrences(of: "٣", with: "3")
            .replacingOccurrences(of: "٤", with: "4")
            .replacingOccurrences(of: "٥", with: "5")
            .replacingOccurrences(of: "٦", with: "6")
            .replacingOccurrences(of: "٧", with: "7")
            .replacingOccurrences(of: "٨", with: "8")
            .replacingOccurrences(of: "٩", with: "9")
        
        guard let amountValue = Double(cleanAmount), amountValue > 0 else {
            showAmountError = true
            amountErrorMessage = languageManager.localizedString(arabic: "مبلغ غير صحيح", english: "Invalid amount")
            return
        }
        
        onSave(trimmedDescription, amountValue)
        dismiss()
    }
}
