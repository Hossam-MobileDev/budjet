//
//  SubscriptionView.swift
//  Wallet budget - مصاريف
//
//  Created by test on 22/08/2025.
//

import SwiftUI
import StoreKit


//struct SubscriptionView: View {
//    @State private var isLoading = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject var subscriptionManager: SubscriptionManager
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 30) {
//                    // Header
//                    VStack(spacing: 16) {
//                        Image(systemName: "crown.fill")
//                            .font(.system(size: 60))
//                            .foregroundColor(.yellow)
//                        
//                        Text("Go Premium")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                        
//                        Text("Remove ads and unlock premium features")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.center)
//                    }
//                    .padding(.top, 20)
//                    
//                    // Benefits
//                    VStack(spacing: 20) {
//                        BenefitRow(icon: "xmark.circle.fill",
//                                 title: "Remove All Ads",
//                                 description: "Enjoy uninterrupted experience")
//                        
//                        BenefitRow(icon: "bolt.fill",
//                                 title: "Premium Features",
//                                 description: "Access exclusive functionality")
//                        
//                        BenefitRow(icon: "arrow.clockwise",
//                                 title: "Priority Support",
//                                 description: "Get help when you need it")
//                        
//                        BenefitRow(icon: "icloud.fill",
//                                 title: "Cloud Sync",
//                                 description: "Sync across all your devices")
//                    }
//                    .padding(.horizontal)
//                    
//                    // Subscription Plan
//                    VStack(spacing: 16) {
//                        Text("Choose Your Plan")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                        
//                        // Monthly Plan Card
//                        Button(action: subscribeToPremium) {
//                            HStack {
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text("Monthly Premium")
//                                        .font(.headline)
//                                        .fontWeight(.semibold)
//                                    
//                                    Text("Cancel anytime")
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                }
//                                
//                                Spacer()
//                                
//                                VStack(alignment: .trailing, spacing: 4) {
//                                    Text("$9.99")
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                    
//                                    Text("per month")
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                            .padding(20)
//                            .background(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .fill(Color.blue.opacity(0.1))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 16)
//                                            .stroke(Color.blue, lineWidth: 2)
//                                    )
//                            )
//                            .foregroundColor(.primary)
//                        }
//                        .disabled(isLoading)
//                        
//                        // Subscribe Button
//                        Button(action: subscribeToPremium) {
//                            HStack {
//                                if isLoading {
//                                    ProgressView()
//                                        .scaleEffect(0.8)
//                                        .foregroundColor(.white)
//                                }
//                                
//                                Text(isLoading ? "Processing..." : "Subscribe Now")
//                                    .fontWeight(.semibold)
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                        }
//                        .disabled(isLoading)
//                        
//                        // Billing info
//                        Text("Billed monthly at $9.99")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.horizontal)
//                    
//                    // Terms and Privacy
//                    VStack(spacing: 8) {
//                        Text("By subscribing, you agree to our")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        HStack(spacing: 16) {
//                            Button("Terms of Service") {
//                                // Handle terms action
//                            }
//                            .font(.caption)
//                            
//                            Button("Privacy Policy") {
//                                // Handle privacy action
//                            }
//                            .font(.caption)
//                        }
//                    }
//                    .padding(.bottom, 30)
//                }
//                .padding(.horizontal)
//            }
//            .navigationTitle("Premium")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Close") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//        .alert("Subscription", isPresented: $showAlert) {
//            Button("OK", role: .cancel) {
//                // Close the sheet when user taps OK on success alert
//                if alertMessage.contains("successful") {
//                    dismiss()
//                }
//            }
//        } message: {
//            Text(alertMessage)
//        }
//    }
//    
//    private func subscribeToPremium() {
//        isLoading = true
//        
//        Task {
//            do {
//                let products = try await Product.products(for: ["com.3rabapp.walletbudget.monthly.premium"])
//                guard let product = products.first else {
//                    await MainActor.run {
//                        isLoading = false
//                        alertMessage = "Product not available. Please try again later."
//                        showAlert = true
//                    }
//                    return
//                }
//                
//                let result = try await product.purchase()
//                
//                await MainActor.run {
//                    isLoading = false
//                    
//                    switch result {
//                    case .success(let verification):
//                        switch verification {
//                        case .verified(let transaction):
//                            // Successfully purchased - unlock premium
//                            subscriptionManager.updateSubscriptionStatus(true)
//                            alertMessage = "Subscription successful! Welcome to Premium!"
//                            showAlert = true
//                            
//                            // Finish the transaction
//                            Task { await transaction.finish() }
//                            
//                        case .unverified:
//                            alertMessage = "Transaction could not be verified. Please try again."
//                            showAlert = true
//                        }
//                        
//                    case .userCancelled:
//                        // User cancelled - do nothing
//                        break
//                        
//                    case .pending:
//                        alertMessage = "Purchase is pending. Please check your payment method."
//                        showAlert = true
//                        
//                    @unknown default:
//                        alertMessage = "Unknown error occurred. Please try again."
//                        showAlert = true
//                    }
//                }
//                
//            } catch {
//                await MainActor.run {
//                    isLoading = false
//                    alertMessage = "Purchase failed: \(error.localizedDescription)"
//                    showAlert = true
//                }
//            }
//        }
//    }
//}
//
//// MARK: - BenefitRow Component
//struct BenefitRow: View {
//    let icon: String
//    let title: String
//    let description: String
//    
//    var body: some View {
//        HStack(spacing: 16) {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundColor(.blue)
//                .frame(width: 30)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(.headline)
//                    .fontWeight(.semibold)
//                
//                Text(description)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color(.systemGray6))
//        )
//    }
//}
//
//// MARK: - SubscriptionManager
//class SubscriptionManager: ObservableObject {
//    @Published var isPremiumUser = false
//    private let productID = "com.3rabapp.walletbudget.monthly.premium"
//    
//    init() {
//        // Check current subscription status
//        isPremiumUser = UserDefaults.standard.bool(forKey: "isPremiumUser")
//        
//        // Check for existing transactions
//        Task {
//            await checkSubscriptionStatus()
//        }
//    }
//    
//    func purchaseMonthlySubscription() async {
//        do {
//            let products = try await Product.products(for: [productID])
//            guard let product = products.first else { return }
//            
//            let result = try await product.purchase()
//            
//            await MainActor.run {
//                switch result {
//                case .success(let verification):
//                    switch verification {
//                    case .verified(let transaction):
//                        self.updateSubscriptionStatus(true)
//                        Task { await transaction.finish() }
//                    case .unverified:
//                        break
//                    }
//                case .userCancelled:
//                    break
//                case .pending:
//                    break
//                @unknown default:
//                    break
//                }
//            }
//            
//        } catch {
//            print("Purchase failed: \(error)")
//        }
//    }
//    
//    func checkSubscriptionStatus() async {
//        await MainActor.run {
//            let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
//            self.updateSubscriptionStatus(isPremium)
//        }
//    }
//    
//    func restorePurchases() async {
//        do {
//            try await AppStore.sync()
//            await checkSubscriptionStatus()
//        } catch {
//            print("Restore failed: \(error)")
//        }
//    }
//    
//    @MainActor
//    func updateSubscriptionStatus(_ isPremium: Bool) {
//        isPremiumUser = isPremium
//        UserDefaults.standard.set(isPremium, forKey: "isPremiumUser")
//        print("📱 Premium status updated to: \(isPremium)")
//    }
//}
//
//// MARK: - Preview
//struct SubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionView()
//            .environmentObject(SubscriptionManager())
//    }
//}

struct SubscriptionView: View {
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header - With image only
                VStack(spacing: 16) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                    
                    Text(languageManager.localizedString(
                        arabic: "إزالة الإعلانات وفتح المميزات الحصرية",
                        english: "Remove ads and unlock premium features"
                    ))
                    .font(languageManager.isArabic ? .custom("Almarai", size: 16) : .subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Benefits - Only Remove Ads
                VStack(spacing: 16) {
                    BenefitRow(
                        icon: "xmark.circle.fill",
                        title: languageManager.localizedString(
                            arabic: "إزالة جميع الإعلانات",
                            english: "Remove All Ads"
                        ),
                        description: languageManager.localizedString(
                            arabic: "استمتع بتجربة بدون انقطاع",
                            english: "Enjoy uninterrupted experience"
                        )
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Subscription Plan - Bottom section
                VStack(spacing: 20) {
                    Text(languageManager.localizedString(
                        arabic: "اختر خطتك",
                        english: "Choose Your Plan"
                    ))
                    .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 18) : .title3)
                    .fontWeight(.semibold)
                    
                    // Monthly Plan Card
                    Button(action: subscribeToPremium) {
                        HStack {
                            VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                                Text(languageManager.localizedString(
                                    arabic: "الاشتراك الشهري المميز",
                                    english: "Monthly Premium"
                                ))
                                .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 14) : .subheadline)
                                .fontWeight(.semibold)
                                
                                Text(languageManager.localizedString(
                                    arabic: "يمكن الإلغاء في أي وقت",
                                    english: "Cancel anytime"
                                ))
                                .font(languageManager.isArabic ? .custom("Almarai", size: 11) : .caption2)
                                .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: languageManager.isArabic ? .leading : .trailing, spacing: 4) {
                                Text("$9.99")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text(languageManager.localizedString(
                                    arabic: "شهرياً",
                                    english: "per month"
                                ))
                                .font(languageManager.isArabic ? .custom("Almarai", size: 11) : .caption2)
                                .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        )
                        .foregroundColor(.primary)
                    }
                    .disabled(isLoading)
                    
                    // Subscribe Button
                    Button(action: subscribeToPremium) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            
                            Text(isLoading ?
                                languageManager.localizedString(
                                    arabic: "جاري المعالجة...",
                                    english: "Processing..."
                                ) :
                                languageManager.localizedString(
                                    arabic: "اشترك الآن",
                                    english: "Subscribe Now"
                                )
                            )
                            .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 16) : .body)
                            .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isLoading)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
            .navigationTitle(languageManager.localizedString(
                arabic: "المميز",
                english: "Premium"
            ))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(languageManager.localizedString(
                        arabic: "إغلاق",
                        english: "Close"
                    )) {
                        dismiss()
                    }
                }
            }
        }
        .alert(languageManager.localizedString(
            arabic: "الاشتراك",
            english: "Subscription"
        ), isPresented: $showAlert) {
            Button(languageManager.localizedString(
                arabic: "حسناً",
                english: "OK"
            ), role: .cancel) {
                // Close the sheet when user taps OK on success alert
                if alertMessage.contains("successful") || alertMessage.contains("بنجاح") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func subscribeToPremium() {
        isLoading = true
        
        Task {
            do {
                let products = try await Product.products(for: ["com.3rabapp.walletbudget.monthly.premium"])
                guard let product = products.first else {
                    await MainActor.run {
                        isLoading = false
                        alertMessage = languageManager.localizedString(
                            arabic: "المنتج غير متوفر. يرجى المحاولة مرة أخرى لاحقاً.",
                            english: "Product not available. Please try again later."
                        )
                        showAlert = true
                    }
                    return
                }
                
                let result = try await product.purchase()
                
                await MainActor.run {
                    isLoading = false
                    
                    switch result {
                    case .success(let verification):
                        switch verification {
                        case .verified(let transaction):
                            // Successfully purchased - unlock premium
                            subscriptionManager.updateSubscriptionStatus(true)
                            alertMessage = languageManager.localizedString(
                                arabic: "تم إعدادك بالكامل! تم الشراء بنجاح",
                                english: "You're all set! Your purchase was successful"
                            )
                            showAlert = true
                            
                            // Finish the transaction
                            Task { await transaction.finish() }
                            
                        case .unverified:
                            alertMessage = languageManager.localizedString(
                                arabic: "لا يمكن التحقق من المعاملة. يرجى المحاولة مرة أخرى.",
                                english: "Transaction could not be verified. Please try again."
                            )
                            showAlert = true
                        }
                        
                    case .userCancelled:
                        // User cancelled - do nothing
                        break
                        
                    case .pending:
                        alertMessage = languageManager.localizedString(
                            arabic: "الشراء في الانتظار. يرجى التحقق من طريقة الدفع.",
                            english: "Purchase is pending. Please check your payment method."
                        )
                        showAlert = true
                        
                    @unknown default:
                        alertMessage = languageManager.localizedString(
                            arabic: "حدث خطأ غير معروف. يرجى المحاولة مرة أخرى.",
                            english: "Unknown error occurred. Please try again."
                        )
                        showAlert = true
                    }
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = languageManager.localizedString(
                        arabic: "فشل الشراء: \(error.localizedDescription)",
                        english: "Purchase failed: \(error.localizedDescription)"
                    )
                    showAlert = true
                }
            }
        }
    }
}

// MARK: - BenefitRow Component
struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 28)
            
            VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                Text(title)
                    .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 16) : .headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: languageManager.isArabic ? .trailing : .leading)
                
                Text(description)
                    .font(languageManager.isArabic ? .custom("Almarai", size: 14) : .subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: languageManager.isArabic ? .trailing : .leading)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - SubscriptionManager (unchanged)
class SubscriptionManager: ObservableObject {
    @Published var isPremiumUser = false
    private let productID = "com.3rabapp.walletbudget.monthly.premium"
    
    init() {
        // Check current subscription status
        isPremiumUser = UserDefaults.standard.bool(forKey: "isPremiumUser")
        
        // Check for existing transactions
        Task {
            await checkSubscriptionStatus()
        }
    }
    
    func purchaseMonthlySubscription() async {
        do {
            let products = try await Product.products(for: [productID])
            guard let product = products.first else { return }
            
            let result = try await product.purchase()
            
            await MainActor.run {
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        self.updateSubscriptionStatus(true)
                        Task { await transaction.finish() }
                    case .unverified:
                        break
                    }
                case .userCancelled:
                    break
                case .pending:
                    break
                @unknown default:
                    break
                }
            }
            
        } catch {
            print("Purchase failed: \(error)")
        }
    }
    
    func checkSubscriptionStatus() async {
        await MainActor.run {
            let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
            self.updateSubscriptionStatus(isPremium)
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }
    
    @MainActor
    func updateSubscriptionStatus(_ isPremium: Bool) {
        isPremiumUser = isPremium
        UserDefaults.standard.set(isPremium, forKey: "isPremiumUser")
        print("📱 Premium status updated to: \(isPremium)")
    }
}

// MARK: - Preview
struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
            .environmentObject(SubscriptionManager())
    }
}
