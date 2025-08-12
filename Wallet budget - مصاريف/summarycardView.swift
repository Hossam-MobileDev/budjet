//
//  summarycardView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI

struct SummaryCard: View {
   let title: String
   let amount: Double
   let color: Color
   
   var body: some View {
       VStack {
           Text(title)
               .font(.headline)
           Text(String(format: "%.2f", amount))
               .font(.title2)
               .foregroundColor(color)
       }
       .padding()
       .background(color.opacity(0.1))
       .cornerRadius(10)
   }
}
