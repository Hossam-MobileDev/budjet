//
//  FinancialIncomeEntity+CoreDataProperties.swift
//  budgetWallet
//
//  Created by test on 30/01/2025.
//
//

import Foundation
import CoreData


extension FinancialIncomeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinancialIncomeEntity> {
        return NSFetchRequest<FinancialIncomeEntity>(entityName: "FinancialIncomeEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: UUID?

}

extension FinancialIncomeEntity : Identifiable {

}
