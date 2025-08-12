//
//  monthYearHeader.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI
struct MonthYearHeader: View {
   var body: some View {
       VStack {
           Text(Date().formatted(.dateTime.month(.wide)))
               .font(.headline)
               .bold()
               .foregroundColor(.primary)
           
           Text(Date().formatted(.dateTime.year()))
               .font(.subheadline)
               .foregroundColor(.secondary)
       }
       
       .padding()
       
   }
    
}
