//
//  ExpenseEntity+CoreDataProperties.swift
//  budgetWallet
//
//  Created by test on 30/01/2025.
//
//

import Foundation
import CoreData


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var expenseDescription: String?
    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var category: CategoryEntity?

}

extension ExpenseEntity : Identifiable {

}
