//
//  mainViewModel.swift
//  budgetWallet
//
//  Created by test on 31/01/2025.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var incomeViewModel: IncomeViewModel
    @Published var outcomeViewModel: OutcomeViewModel
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        self.incomeViewModel = IncomeViewModel(context: context)
        self.outcomeViewModel = OutcomeViewModel()
    }
}
