//
//  transactionChartView.swift
//  budgetWallet
//
//  Created by test on 30/01/2025.
//

import SwiftUI
struct TransactionChartView: View {
    @ObservedObject var incomeViewModel: IncomeViewModel
    @ObservedObject var outcomeViewModel: OutcomeViewModel
    @Binding var selectedCurrency: String

    @State private var incomeAnimation: CGFloat = 0.0
    @State private var outcomeAnimation: CGFloat = 0.0
    
    private var totalIncome: Double {
        incomeViewModel.incomes.reduce(0) { $0 + $1.amount }
    }
    
    private var totalOutcome: Double {
        let sum = outcomeViewModel.categories.reduce(0) { sum, category in
            let categoryExpenses = outcomeViewModel.expenses[category.id] ?? []
            let categoryTotal = categoryExpenses.reduce(0) { $0 + $1.amount }
            return sum + categoryTotal
        }
        return sum
    }
    
    private func drawChart(context: GraphicsContext, size: CGSize) {
        let strokeWidth: CGFloat = 20 // Reduced stroke width
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = (min(size.width, size.height) - strokeWidth) / 2.2 // Slightly increased divisor for smaller size
        let total = totalIncome + totalOutcome
        
        // Always draw background circle first
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(270),
            clockwise: false
        )
        context.stroke(path, with: .color(.gray.opacity(0.2)), lineWidth: strokeWidth)
        
        if total > 0 {
            let incomeFraction = CGFloat(totalIncome / total)
            let endAngle = Double(-90 + (360 * incomeFraction))
            
            // Draw income segment (green)
            path = Path()
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(-90),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
            context.stroke(
                path,
                with: .color(Color(red: 76/255, green: 175/255, blue: 80/255)),
                lineWidth: strokeWidth
            )
            
            // Draw outcome segment (red)
            path = Path()
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(endAngle),
                endAngle: .degrees(270),
                clockwise: false
            )
            context.stroke(
                path,
                with: .color(Color(red: 229/255, green: 115/255, blue: 115/255)),
                lineWidth: strokeWidth
            )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                drawChart(context: context, size: size)
            }
        }
        .frame(height: 250) // Reduced height from 270 to 250
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                incomeAnimation = 1
                outcomeAnimation = 1
            }
        }
    }
}
