//
//  incomeView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//
import CoreData
import SwiftUI

// MARK: - Transaction Card View

struct FinancialIncome: Identifiable {
    let id: UUID
    let amount: Double
    let date: Date
    let description: String

    // Convenience initializer for Core Data entity
    init(entity: FinancialIncomeEntity) {
        self.id = entity.id ?? UUID()
        self.amount = entity.amount
        self.date = entity.date ?? Date()
        self.description = entity.descriptionText ?? ""
    }

    // Convenience initializer for creating new income
    init(amount: Double, date: Date, description: String) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.description = description
    }
    init(id: UUID, amount: Double, date: Date, description: String) {
          self.id = id
          self.amount = amount
          self.date = date
          self.description = description
      }
}

// MARK: - ViewModel
class IncomeViewModel: ObservableObject {
    @Published var incomes: [FinancialIncome] = []
    @Published var currencySymbol: String = "$"
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchCurrentMonthIncomes()
    }
    
    // MARK: - Currency Management
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
    
    // MARK: - Date Management
    private func isCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month], from: Date())
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        return currentComponents.year == dateComponents.year &&
               currentComponents.month == dateComponents.month
    }
    
    // MARK: - Data Fetching
    private func fetchCurrentMonthIncomes() {
        let fetchRequest = FinancialIncomeEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FinancialIncomeEntity.date, ascending: false)]
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            self.incomes = results
                .map { FinancialIncome(entity: $0) }
                //.filter { isCurrentMonth($0.date) }
        } catch {
            print("Error fetching current month incomes: \(error)")
        }
    }
    
    func getAllIncomes() -> [FinancialIncome] {
        let fetchRequest = FinancialIncomeEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FinancialIncomeEntity.date, ascending: false)]
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results.map { FinancialIncome(entity: $0) }
        } catch {
            print("Error fetching all incomes: \(error)")
            return []
        }
    }
    
    // MARK: - Data Management
    func addIncome(_ income: FinancialIncome) {
//        guard isCurrentMonth(income.date) else {
//            print("Cannot add income for past/future months")
//            return
//        }
        
        let newEntity = FinancialIncomeEntity(context: viewContext)
        newEntity.id = income.id
        newEntity.amount = income.amount
        newEntity.date = income.date
        newEntity.descriptionText = income.description
        
        do {
            try viewContext.save()
            fetchCurrentMonthIncomes()
        } catch {
            print("Error saving income: \(error)")
        }
    }
    
    func deleteIncome(_ income: FinancialIncome) {
        let fetchRequest = FinancialIncomeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", income.id as CVarArg)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let entityToDelete = results.first {
                viewContext.delete(entityToDelete)
                try viewContext.save()
                fetchCurrentMonthIncomes()
            }
        } catch {
            print("Error deleting income: \(error)")
        }
    }
    
    func updateIncome(_ income: FinancialIncome) {
        guard isCurrentMonth(income.date) else {
            print("Cannot update income from past/future months")
            return
        }
        
        let fetchRequest = FinancialIncomeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", income.id as CVarArg)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let entityToUpdate = results.first {
                entityToUpdate.amount = income.amount
                entityToUpdate.date = income.date
                entityToUpdate.descriptionText = income.description
                try viewContext.save()
                fetchCurrentMonthIncomes()
            }
        } catch {
            print("Error updating income: \(error)")
        }
    }
    
    // MARK: - Month Management
    private func archiveOldIncomes() {
        // Instead of archiving, we'll just keep the data
        fetchCurrentMonthIncomes()
    }
    
    func checkAndUpdateMonth() {
        archiveOldIncomes()
        fetchCurrentMonthIncomes()
    }
    
    // MARK: - Historical Data
    func getIncomesForMonth(year: Int, month: Int) -> [FinancialIncome] {
        let fetchRequest = FinancialIncomeEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FinancialIncomeEntity.date, ascending: false)]
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
                .map { FinancialIncome(entity: $0) }
                .filter { income in
                    let components = Calendar.current.dateComponents([.year, .month], from: income.date)
                    return components.year == year && components.month == month
                }
        } catch {
            print("Error fetching incomes for specific month: \(error)")
            return []
        }
    }
    
    func getTotalIncomeForMonth(year: Int, month: Int) -> Double {
        return getIncomesForMonth(year: year, month: month)
            .reduce(0) { $0 + $1.amount }
    }

}



// MARK: - Income Card View
struct IncomeCard: View {
    let incomeName: String
    let amount: Double
    let currencySymbol: String
    let onEdit: () -> Void
    let onDelete: () -> Void
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        HStack {
            if !languageManager.isArabic {
                // Income name (LTR)
                nameView
                Spacer()
                amountView
                actionButtons
            } else {
                // Income name (RTL)
                actionButtons
                amountView
                Spacer()
                nameView
            }
        }
        .padding(16)
        .background(Color(red: 0.39, green: 0.79, blue: 0.55))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
    
    private var nameView: some View {
        Text(incomeName)
            .font(.headline)
            .foregroundColor(.white)
            .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
    }
    
    private var amountView: some View {
        Text("\(currencySymbol) \(String(format: "%.0f", amount))")
            .font(.headline)
            .foregroundColor(.white)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 8) {
            if !languageManager.isArabic {
                editButton
                deleteButton
            } else {
                deleteButton
                editButton
            }
        }
    }
    
    private var editButton: some View {
        Button(action: onEdit) {
            Image(systemName: "pencil")
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
        }
    }
    
    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "trash")
                .foregroundColor(Color(.systemPink).opacity(0.9))
                .frame(width: 20, height: 20)
        }
    }
}





//struct AddIncomeDialog: View {
//    let viewModel: IncomeViewModel  // Remove @ObservedObject - just use let
//    @Binding var isPresented: Bool
//    let currencySymbol: String
//    var initialIncome: FinancialIncome?
//    @StateObject private var languageManager = LanguageManager.shared
//    
//    @State private var incomeName: String
//    @State private var incomeAmount: String
//    @State private var showNameError: Bool = false
//    @State private var showAmountError: Bool = false
//    @State private var amountErrorMessage: String = ""
//    
//    init(viewModel: IncomeViewModel,
//         isPresented: Binding<Bool>,
//         currencySymbol: String,
//         initialIncome: FinancialIncome? = nil) {
//        self.viewModel = viewModel
//        self._isPresented = isPresented
//        self.currencySymbol = currencySymbol
//        self.initialIncome = initialIncome
//        
//        // Initialize @State properties properly
//        if let income = initialIncome {
//            self._incomeName = State(initialValue: income.description)
//            self._incomeAmount = State(initialValue: String(format: "%.2f", income.amount))
//        } else {
//            self._incomeName = State(initialValue: "")
//            self._incomeAmount = State(initialValue: "")
//        }
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 16) {
//                // Income Name TextField
//                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
//                    HStack {
//                        if !languageManager.isArabic {
//                            nameTextField
//                        } else {
//                            Spacer()
//                            nameTextField
//                        }
//                    }
//                    
//                    if showNameError {
//                        errorText(languageManager.isArabic ? "الرجاء إدخال اسم الدخل" : "Please enter income name")
//                    }
//                }
//                
//                // Amount TextField
//                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
//                    HStack {
//                        if !languageManager.isArabic {
//                            Text(currencySymbol)
//                                .foregroundColor(.gray)
//                            amountTextField
//                        } else {
//                            amountTextField
//                            Text(currencySymbol)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    
//                    if showAmountError {
//                        errorText(amountErrorMessage)
//                    }
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle(initialIncome == nil ?
//                           (languageManager.isArabic ? "إضافة دخل" : "Add Income") :
//                           (languageManager.isArabic ? "تعديل الدخل" : "Edit Income"))
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button(languageManager.isArabic ? "إلغاء" : "Cancel") {
//                        isPresented = false
//                    }
//                }
//                
//                ToolbarItem(placement: .confirmationAction) {
//                    saveButton
//                }
//            }
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//    
//    private var nameTextField: some View {
//        TextField(languageManager.isArabic ? "اسم الدخل" : "Income Name", text: $incomeName)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .onChange(of: incomeName) { _ in
//                showNameError = false
//            }
//            .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
//    }
//    
//    private var amountTextField: some View {
//        TextField(languageManager.isArabic ? "المبلغ" : "Amount", text: $incomeAmount)
//            .keyboardType(.numbersAndPunctuation)
//            .onChange(of: incomeAmount) { newValue in
//                validateAmount(newValue)
//            }
//            .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
//    }
//    
//    private func validateAmount(_ newValue: String) {
//        if newValue.isEmpty {
//            showAmountError = true
//            amountErrorMessage = languageManager.isArabic ? "الرجاء إدخال المبلغ" : "Please enter amount"
//        } else if newValue.isValidNumber {
//            showAmountError = false
//            amountErrorMessage = ""
//        } else {
//            showAmountError = true
//            amountErrorMessage = languageManager.isArabic ? "يرجى إدخال رقم صحيح" : "Please enter a valid number"
//        }
//    }
//    
//    private func errorText(_ text: String) -> some View {
//        Text(text)
//            .font(.caption)
//            .foregroundColor(.red)
//            .frame(maxWidth: .infinity, alignment: languageManager.isArabic ? .trailing : .leading)
//    }
//    
//    private var saveButton: some View {
//        Button(initialIncome == nil ?
//              (languageManager.isArabic ? "إضافة" : "Add") :
//              (languageManager.isArabic ? "حفظ" : "Save")) {
//            validateAndSave()
//        }
//        .disabled(incomeName.isEmpty || incomeAmount.isEmpty || showAmountError)
//    }
//    
//    private func validateAndSave() {
//        showNameError = incomeName.isEmpty
//        
//        if incomeAmount.isEmpty {
//            showAmountError = true
//            amountErrorMessage = languageManager.isArabic ? "الرجاء إدخال المبلغ" : "Please enter amount"
//        } else if !incomeAmount.isValidNumber {
//            showAmountError = true
//            amountErrorMessage = languageManager.isArabic ? "يرجى إدخال رقم صحيح" : "Please enter a valid number"
//        } else if let amount = incomeAmount.doubleValue, amount <= 0 {
//            showAmountError = true
//            amountErrorMessage = languageManager.isArabic ? "يجب أن يكون المبلغ أكبر من صفر" : "Amount must be greater than zero"
//        } else {
//            showAmountError = false
//            amountErrorMessage = ""
//        }
//        
//        guard let amount = incomeAmount.doubleValue,
//              !incomeName.isEmpty,
//              !showAmountError else {
//            return
//        }
//        
//        if let existingIncome = initialIncome {
//            let updatedIncome = FinancialIncome(
//                id: existingIncome.id,
//                amount: amount,
//                date: existingIncome.date,
//                description: incomeName
//            )
//            viewModel.updateIncome(updatedIncome)
//        } else {
//            let newIncome = FinancialIncome(
//                amount: amount,
//                date: Date(),
//                description: incomeName
//            )
//            viewModel.addIncome(newIncome)
//        }
//        
//        // Force refresh the view model data
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            viewModel.checkAndUpdateMonth()
//        }
//        
//        isPresented = false
//    }
//}

struct AddIncomeDialog: View {
    let viewModel: IncomeViewModel  // Changed from @ObservedObject to let
    @Binding var isPresented: Bool
    let currencySymbol: String
    var initialIncome: FinancialIncome?
    @StateObject private var languageManager = LanguageManager.shared
    
    @State private var incomeName: String
    @State private var incomeAmount: String
    @State private var showNameError: Bool = false
    @State private var showAmountError: Bool = false
    @State private var amountErrorMessage: String = ""
    
    init(viewModel: IncomeViewModel,
         isPresented: Binding<Bool>,
         currencySymbol: String,
         initialIncome: FinancialIncome? = nil) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self.currencySymbol = currencySymbol
        self.initialIncome = initialIncome
        
        // Initialize @State properties properly
        if let income = initialIncome {
            self._incomeName = State(initialValue: income.description)
            self._incomeAmount = State(initialValue: String(format: "%.0f", income.amount))
        } else {
            self._incomeName = State(initialValue: "")
            self._incomeAmount = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Income Name TextField
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                    HStack {
                        if !languageManager.isArabic {
                            nameTextField
                        } else {
                            Spacer()
                            nameTextField
                        }
                    }
                    
                    if showNameError {
                        errorText(languageManager.isArabic ? "الرجاء إدخال اسم الدخل" : "Please enter income name")
                    }
                }
                
                // Amount TextField
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                    HStack {
                        if !languageManager.isArabic {
                            Text(currencySymbol)
                                .foregroundColor(.gray)
                            amountTextField
                        } else {
                            amountTextField
                            Text(currencySymbol)
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if showAmountError {
                        errorText(amountErrorMessage)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(initialIncome == nil ?
                           (languageManager.isArabic ? "إضافة دخل" : "Add Income") :
                           (languageManager.isArabic ? "تعديل الدخل" : "Edit Income"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(languageManager.isArabic ? "إلغاء" : "Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    private var nameTextField: some View {
        TextField(languageManager.isArabic ? "اسم الدخل" : "Income Name", text: $incomeName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: incomeName) { _ in
                showNameError = false
            }
            .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
    }
    
    private var amountTextField: some View {
        TextField(languageManager.isArabic ? "المبلغ" : "Amount", text: $incomeAmount)
            .keyboardType(.numbersAndPunctuation)
            .onChange(of: incomeAmount) { newValue in
                validateAmount(newValue)
            }
            .multilineTextAlignment(languageManager.isArabic ? .trailing : .leading)
    }
    
    private func validateAmount(_ newValue: String) {
        if newValue.isEmpty {
            showAmountError = true
            amountErrorMessage = languageManager.isArabic ? "الرجاء إدخال المبلغ" : "Please enter amount"
        } else if newValue.isValidNumber {
            showAmountError = false
            amountErrorMessage = ""
        } else {
            showAmountError = true
            amountErrorMessage = languageManager.isArabic ? "يرجى إدخال رقم صحيح" : "Please enter a valid number"
        }
    }
    
    private func errorText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: languageManager.isArabic ? .trailing : .leading)
    }
    
    private var saveButton: some View {
        Button(initialIncome == nil ?
              (languageManager.isArabic ? "إضافة" : "Add") :
              (languageManager.isArabic ? "حفظ" : "Save")) {
            validateAndSave()
        }
        .disabled(incomeName.isEmpty || incomeAmount.isEmpty || showAmountError)
    }
    
    private func validateAndSave() {
        showNameError = incomeName.isEmpty
        
        if incomeAmount.isEmpty {
            showAmountError = true
            amountErrorMessage = languageManager.isArabic ? "الرجاء إدخال المبلغ" : "Please enter amount"
        } else if !incomeAmount.isValidNumber {
            showAmountError = true
            amountErrorMessage = languageManager.isArabic ? "يرجى إدخال رقم صحيح" : "Please enter a valid number"
        } else if let amount = incomeAmount.doubleValue, amount <= 0 {
            showAmountError = true
            amountErrorMessage = languageManager.isArabic ? "يجب أن يكون المبلغ أكبر من صفر" : "Amount must be greater than zero"
        } else {
            showAmountError = false
            amountErrorMessage = ""
        }
        
        guard let amount = incomeAmount.doubleValue,
              !incomeName.isEmpty,
              !showAmountError else {
            return
        }
        
        if let existingIncome = initialIncome {
            let updatedIncome = FinancialIncome(
                id: existingIncome.id,
                amount: amount,
                date: existingIncome.date,
                description: incomeName
            )
            viewModel.updateIncome(updatedIncome)
        } else {
            let newIncome = FinancialIncome(
                amount: amount,
                date: Date(),
                description: incomeName
            )
            viewModel.addIncome(newIncome)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.checkAndUpdateMonth()
        }
        
        isPresented = false
    }
}

struct FAB: View {
    let systemImage: String
    let backgroundColor: Color
    let action: () -> Void
    
    init(
        systemImage: String = "plus",
        backgroundColor: Color = Color(red: 0.39, green: 0.79, blue: 0.55), // #63C98C
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
        .buttonStyle(FABButtonStyle())
        .accessibilityLabel("Add Income")
    }
}

// Custom Button Style to mimic Android FAB interaction
struct FABButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.1 : 0)
    }
}

// MARK: - Income View
struct IncomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var viewModel: IncomeViewModel
    @StateObject private var languageManager = LanguageManager.shared

    @State private var showAddDialog = false
    @State private var showDeleteConfirmation = false
    @State private var selectedIncome: FinancialIncome? = nil
    @State private var showWrongMonthAlert = false
    
    init(viewModel: IncomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(spacing: 8) {
                        Text(formatDate(Date()))
                            .font(.headline)
                            .padding()
                        
                        if viewModel.incomes.isEmpty {
                            Text(languageManager.isArabic ? "لا يوجد دخل لهذا الشهر" : "No incomes for this month")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.incomes) { income in
                                IncomeCard(
                                    incomeName: income.description,
                                    amount: income.amount,
                                    currencySymbol: viewModel.currencySymbol,
                                    onEdit: {
                                        selectedIncome = income
                                        showAddDialog = true
                                    },
                                    onDelete: {
                                        selectedIncome = income
                                        showDeleteConfirmation = true
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
                        FAB(action: { showAddDialog = true })
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
        .alert(languageManager.isArabic ? "حذف الدخل" : "Delete Income", isPresented: $showDeleteConfirmation) {
            Button(languageManager.isArabic ? "حذف" : "Delete", role: .destructive) {
                if let income = selectedIncome {
                    viewModel.deleteIncome(income)
                    selectedIncome = nil
                }
            }
            Button(languageManager.isArabic ? "إلغاء" : "Cancel", role: .cancel) {
                selectedIncome = nil
            }
        }
        .sheet(isPresented: $showAddDialog) {
            if let income = selectedIncome {
                // Edit mode
                AddIncomeDialog(
                    viewModel: viewModel,
                    isPresented: $showAddDialog,
                    currencySymbol: viewModel.currencySymbol,
                    initialIncome: selectedIncome  // Just pass the entire income object

                )
            } else {
                // Add mode
                AddIncomeDialog(
                    viewModel: viewModel,
                    isPresented: $showAddDialog,
                    currencySymbol: viewModel.currencySymbol
                )
            }
        }
        .alert(languageManager.isArabic ? "تنبيه" : "Alert", isPresented: $showWrongMonthAlert) {
            Button(languageManager.isArabic ? "حسناً" : "OK", role: .cancel) { }
        } message: {
            Text(languageManager.isArabic ?
                 "يمكنك فقط إضافة أو تعديل الدخل للشهر الحالي" :
                 "You can only add or modify income for the current month")
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: languageManager.isArabic ? "ar" : "en")
        return formatter.string(from: date)
    }
}
func formatFullNumber(_ number: Double) -> String {
    // Handle edge cases
    if number.isNaN || number.isInfinite {
        return "0"
    }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = ","
    formatter.usesGroupingSeparator = true
    
    return formatter.string(from: NSNumber(value: number)) ?? "0"
}
