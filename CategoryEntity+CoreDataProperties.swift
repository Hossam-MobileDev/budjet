//
//  CategoryEntity+CoreDataProperties.swift
//  budgetWallet
//
//  Created by test on 30/01/2025.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var budgetAmount: Double

    @NSManaged public var type: String?
    @NSManaged public var isCategory: Bool
    @NSManaged public var date: Date?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension CategoryEntity {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: ExpenseEntity)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: ExpenseEntity)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension CategoryEntity : Identifiable {

}
