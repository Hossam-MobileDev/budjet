//
//  categoryExpensePersistenceController.swift
//  budgetWallet
//
//  Created by test on 30/01/2025.
//

import SwiftUI
import CoreData

class CategoryExpensePersistenceController {
    // Singleton instance
    static let shared = CategoryExpensePersistenceController()
    
    // Core Data container
    let container: NSPersistentContainer
    
    // Private initializer for singleton
    private init() {
        container = NSPersistentContainer(name: "BudgetTrackerModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Save context method
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Category Methods
    
    // Create a new category
    func createCategory(
        name: String,
        budgetAmount: Double,
        type: BudgetType,
        isCategory: Bool = true
    ) -> CategoryEntity {
        let context = container.viewContext
        let category = CategoryEntity(context: context)
        
        category.id = UUID()
        category.name = name
        category.budgetAmount = budgetAmount
        category.type = type == .income ? "income" : "outcome"
        category.isCategory = isCategory
        category.date = Date()
        
        saveContext()
        return category
    }
    
    // Fetch all categories
    func fetchCategories() -> [CategoryEntity] {
        let context = container.viewContext
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        // Optional: Filter for outcome categories
        request.predicate = NSPredicate(format: "type == %@", "outcome")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    // Update existing category
    func updateCategory(
        category: CategoryEntity,
        name: String? = nil,
        budgetAmount: Double? = nil
    ) {
        let context = container.viewContext
        
        if let name = name {
            category.name = name
        }
        
        if let budgetAmount = budgetAmount {
            category.budgetAmount = budgetAmount
        }
        
        saveContext()
    }
    
    // Delete category
    func deleteCategory(_ category: CategoryEntity) {
        let context = container.viewContext
        context.delete(category)
        saveContext()
    }
    
    // MARK: - Expense Methods
    
    // Create a new expense
    func createExpense(
        description: String,
        amount: Double,
        category: CategoryEntity
    ) -> ExpenseEntity {
        let context = container.viewContext
        let expense = ExpenseEntity(context: context)
        
        expense.id = UUID()
        expense.expenseDescription = description
        expense.amount = amount
        expense.date = Date()
        expense.category = category
        
        saveContext()
        return expense
    }
    
    // Fetch expenses for a specific category
    func fetchExpenses(for category: CategoryEntity) -> [ExpenseEntity] {
        let context = container.viewContext
        let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        
        // Filter by category
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching expenses: \(error)")
            return []
        }
    }
    
    // Update existing expense
    func updateExpense(
        expense: ExpenseEntity,
        description: String? = nil,
        amount: Double? = nil
    ) {
        let context = container.viewContext
        
        if let description = description {
            expense.expenseDescription = description
        }
        
        if let amount = amount {
            expense.amount = amount
        }
        
        saveContext()
    }
    
    // Delete expense
    func deleteExpense(_ expense: ExpenseEntity) {
        let context = container.viewContext
        context.delete(expense)
        saveContext()
    }
    
    // Advanced: Fetch total expenses for a category
    func calculateTotalExpenses(for category: CategoryEntity) -> Double {
        let expenses = fetchExpenses(for: category)
        return expenses.reduce(0) { $0 + $1.amount }
    }
}
