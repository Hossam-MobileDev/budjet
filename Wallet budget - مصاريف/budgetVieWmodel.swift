//
//  budgetVieWmodel.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI

struct Transaction: Identifiable, Hashable {
    let id: UUID
    let amount: Double
    let date: Date
    let description: String
    let type: TransactionType
    
    init(id: UUID = UUID(), amount: Double, date: Date = Date(), description: String, type: TransactionType) {
        self.id = id
        self.amount = amount
        self.date = date
        self.description = description
        self.type = type
    }
}

enum TransactionType {
    case income
    case outcome
}

class BudgetViewModel: ObservableObject {
    // Singleton-like shared instance
    static let shared = BudgetViewModel()
    
    // Published properties to track transactions
    @Published var transactions: [Transaction] = []
    
    // Currency symbol (can be made configurable)
    let currencySymbol: String = "$"
    
    // Computed property for total income
    var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    // Computed property for total outcome (expenses)
    var totalOutcome: Double {
        transactions
            .filter { $0.type == .outcome }
            .reduce(0) { $0 + $1.amount }
    }
    
    // Method to add income
    func addIncome(_ income: FinancialIncome) {
        let transaction = Transaction(
            amount: income.amount,
            date: income.date,
            description: income.description,
            type: .income
        )
        transactions.append(transaction)
    }
    
    // Method to add expense
    func addExpense(_ expense: Expensee) {
        let transaction = Transaction(
            amount: expense.amount,
            date: expense.date,
            description: expense.description,
            type: .outcome
        )
        transactions.append(transaction)
    }
    
    // Method to delete a transaction
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
    }
}

// Extension to modify existing view models



