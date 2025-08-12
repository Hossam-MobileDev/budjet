//
//  monthlyHeaderview.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI

struct MonthYearHeaderView: View {
   var body: some View {
       VStack {
           Text(Date().formatted(.dateTime.month(.wide)))
               .font(.headline)
               .bold()
           Text(Date().formatted(.dateTime.year()))
               .foregroundColor(.secondary)
       }
       .padding()
   }
    
    
}
