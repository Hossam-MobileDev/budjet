//
//  budgetWalletApp.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI
import CoreData
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           return true
       }
       
       func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           return .portrait // Lock to portrait orientation only
       }
}

//// MARK: - Custom Environment Keys
struct BudgetContextKey: EnvironmentKey {
    static let defaultValue: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

extension EnvironmentValues {
    var budgetContext: NSManagedObjectContext {
        get { self[BudgetContextKey.self] }
        set { self[BudgetContextKey.self] = newValue }
    }
}

// MARK: - Main App
@main
struct BudgetWalletApp: App {
    @StateObject private var appOpenAdManager = AppOpenAdManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var premiumManager = SubscriptionManager()

    let persistenceController = PersistenceController.shared
    let categoryExpensePersistenceController = CategoryExpensePersistenceController.shared
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            AppLaunchView()
                .environmentObject(appOpenAdManager)
                .environmentObject(premiumManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.budgetContext, categoryExpensePersistenceController.container.viewContext)
                .onAppear {
                    // Connect the premium manager to the app open ad manager
                    appOpenAdManager.setPremiumManager(premiumManager)
                }
        }
    }
}

struct AppLaunchView: View {
    @EnvironmentObject var appOpenAdManager: AppOpenAdManager
    @EnvironmentObject var premiumManager: SubscriptionManager
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                MainView()
                    .environmentObject(appOpenAdManager)
                    .environmentObject(premiumManager)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isLoading)
    }
}
//struct AppLaunchView: View {
//    @EnvironmentObject var appOpenAdManager: AppOpenAdManager
//    @State private var isLoading = true
//    
//    var body: some View {
//        ZStack {
//            if isLoading {
//                SplashView()
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            isLoading = false
//                        }
//                    }
//            } else {
//                MainView()
//                    .environmentObject(appOpenAdManager)
//            }
//        }
//        .animation(.easeInOut(duration: 0.5), value: isLoading)
//    }
//}
//struct BannerAdView: UIViewRepresentable {
//    let adUnitID: String
//    let adSize: GADAdSize
//    
//    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716", adSize: GADAdSize = GADAdSizeBanner) {
//        self.adUnitID = adUnitID
//        self.adSize = adSize
//    }
//    
//    func makeUIView(context: Context) -> UIView {
//        // Check premium status
//        let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
//        if isPremium {
//            // Return empty view for premium users
//            return UIView()
//        }
//        
//        let bannerView = GADBannerView(adSize: adSize)
//        bannerView.adUnitID = adUnitID
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            bannerView.rootViewController = window.rootViewController
//        }
//        
//        bannerView.load(GADRequest())
//        return bannerView
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Update if needed
//    }
//}
//
//// MARK: - Smart Banner Ad View (Adaptive)
//struct SmartBannerAdView: UIViewRepresentable {
//    let adUnitID: String
//    
//    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716") {
//        self.adUnitID = adUnitID
//    }
//    
//    func makeUIView(context: Context) -> UIView {
//        // Check premium status
//        let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
//        if isPremium {
//            // Return empty view for premium users
//            return UIView()
//        }
//        
//        let bannerView = GADBannerView()
//        bannerView.adUnitID = adUnitID
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            bannerView.rootViewController = window.rootViewController
//        }
//        
//        let frame = UIScreen.main.bounds
//        let viewWidth = frame.size.width
//        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
//        
//        bannerView.load(GADRequest())
//        return bannerView
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Update if needed
//    }
//}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    let adSize: GADAdSize
    @EnvironmentObject var premiumManager: SubscriptionManager
    
    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716", adSize: GADAdSize = GADAdSizeBanner) {
        self.adUnitID = adUnitID
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        updateBannerView(in: containerView)
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // This gets called when @EnvironmentObject changes
        updateBannerView(in: uiView)
    }
    
    private func updateBannerView(in containerView: UIView) {
        // Remove existing banner if any
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // Check premium status
        if premiumManager.isPremiumUser {
            // Return empty view for premium users
            return
        }
        
        // Create and add banner view for non-premium users
        let bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            bannerView.rootViewController = window.rootViewController
        }
        
        bannerView.load(GADRequest())
        
        // Add banner to container
        containerView.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bannerView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            bannerView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
}

// MARK: - Updated Smart Banner Ad View (Adaptive)
struct SmartBannerAdView: UIViewRepresentable {
    let adUnitID: String
    @EnvironmentObject var premiumManager: SubscriptionManager
    
    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716") {
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        updateBannerView(in: containerView)
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // This gets called when @EnvironmentObject changes
        updateBannerView(in: uiView)
    }
    
    private func updateBannerView(in containerView: UIView) {
        // Remove existing banner if any
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // Check premium status
        if premiumManager.isPremiumUser {
            // Return empty view for premium users
            return
        }
        
        // Create and add banner view for non-premium users
        let bannerView = GADBannerView()
        bannerView.adUnitID = adUnitID
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            bannerView.rootViewController = window.rootViewController
        }
        
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        bannerView.load(GADRequest())
        
        // Add banner to container
        containerView.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bannerView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            bannerView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
}
