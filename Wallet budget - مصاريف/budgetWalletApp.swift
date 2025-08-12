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
       
    
    let persistenceController = PersistenceController.shared
    let categoryExpensePersistenceController = CategoryExpensePersistenceController.shared
    
    init() {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    
    var body: some Scene {
        WindowGroup {
            AppLaunchView()
                .environmentObject(appOpenAdManager)
                      .environment(\.managedObjectContext, persistenceController.container.viewContext)
                      .environment(\.budgetContext, categoryExpensePersistenceController.container.viewContext)

                      
        }
    }
}

struct AppLaunchView: View {
    @EnvironmentObject var appOpenAdManager: AppOpenAdManager
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
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isLoading)
    }
}

// MARK: - Banner Ad View
struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    let adSize: GADAdSize
    
    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716", adSize: GADAdSize = GADAdSizeBanner) {
        // Using test ad unit ID - replace with your real ad unit ID for production
        self.adUnitID = adUnitID
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID
        
        // Updated for iOS 15+
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            bannerView.rootViewController = window.rootViewController
        }
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // Update if needed
    }
}

// MARK: - Smart Banner Ad View (Adaptive)
struct SmartBannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716") {
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView()
        bannerView.adUnitID = adUnitID
        
        // Get the current view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            bannerView.rootViewController = window.rootViewController
        }
        
        // Create adaptive banner size
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // Update if needed
    }
}

