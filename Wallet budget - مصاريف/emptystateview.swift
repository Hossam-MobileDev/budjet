//
//  emptystateview.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI

struct EmptyStateView: View {
   var body: some View {
       VStack(spacing: 8) {
           Text("No transactions yet")
               .font(.title3)
               .foregroundColor(.gray)
           Text("Click + to add transaction")
               .font(.body)
               .foregroundColor(.gray)
       }
       .padding()
   }
    
}
