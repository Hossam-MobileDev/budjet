//
//  ContentView.swift
//  budgetWallet
//
//  Created by test on 26/01/2025.
//

import SwiftUI
import GoogleMobileAds

//struct SplashView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @State private var isActive = false
//    @StateObject private var appOpenAdManager = AppOpenAdManager()
//    
//    var body: some View {
//        if isActive {
//            MainView()
//                .environment(\.managedObjectContext, viewContext)
//                .environmentObject(appOpenAdManager)
//        } else {
//            ZStack {
//                Color.white
//                    .ignoresSafeArea()
//                
//                VStack {
//                    Image(systemName: "wallet.pass.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: UIScreen.main.bounds.width * 0.3,
//                               maxHeight: UIScreen.main.bounds.height * 0.3)
//                        .foregroundColor(Color(hex: 0x07492B as UInt))
//                    
//                    Spacer()
//                        .frame(height: 16)
//                    
//                    Text("Wallet")
//                        .font(.title)
//                        .foregroundColor(Color(hex: 0x07492B as UInt))
//                    
//                    Text("budget")
//                        .font(.title)
//                        .foregroundColor(Color(hex: 0x07492B as UInt))
//                }
//            }
//            .onAppear {
//                // Initialize Google Mobile Ads
//                GADMobileAds.sharedInstance().start { _ in
//                    print("Google Mobile Ads initialized")
//                    // Load the ad after initialization
//                    appOpenAdManager.loadAd()
//                }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    withAnimation {
//                        self.isActive = true
//                    }
//                    
//                    // Show ad after a short delay
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        appOpenAdManager.showAdIfAvailable()
//                    }
//                }
//            }
//        }
//    }
//}
//
//class AppOpenAdManager: NSObject, ObservableObject {
//    private var appOpenAd: GADAppOpenAd?
//    private var loadTime = Date()
//    
//    // Use test ad unit ID - replace with your real one for production
//    private let adUnitID = "ca-app-pub-3940256099942544/5662855259"
//    
//    @Published var isShowingAd = false
//    @Published var hasShownFirstAd = false
//    
//    override init() {
//        super.init()
//    }
//    
//    func loadAd() {
//        let request = GADRequest()
//        GADAppOpenAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("App Open Ad failed to load: \(error.localizedDescription)")
//                    return
//                }
//                
//                self?.appOpenAd = ad
//                self?.appOpenAd?.fullScreenContentDelegate = self
//                self?.loadTime = Date()
//                print("App Open Ad loaded successfully")
//            }
//        }
//    }
//    
//    func showAdIfAvailable() {
//        guard let ad = appOpenAd,
//              wasLoadTimeLessThanNHoursAgo(thresholdN: 4),
//              !isShowingAd else {
//            if !wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
//                loadAd()
//            }
//            return
//        }
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first?.rootViewController else {
//            return
//        }
//        
//        isShowingAd = true
//        ad.present(fromRootViewController: rootViewController)
//    }
//    
//    private func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
//        let now = Date()
//        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(loadTime)
//        let secondsPerHour = 3600.0
//        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
//        return intervalInHours < Double(thresholdN)
//    }
//}
//
//extension AppOpenAdManager: GADFullScreenContentDelegate {
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        appOpenAd = nil
//        isShowingAd = false
//        hasShownFirstAd = true
//        loadAd()
//        print("App Open Ad dismissed")
//    }
//    
//    func adDidFailToPresentFullScreenContent(_ ad: GADFullScreenPresentingAd, withError error: Error) {
//        appOpenAd = nil
//        isShowingAd = false
//        loadAd()
//        print("App Open Ad failed to present: \(error.localizedDescription)")
//    }
//    
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("App Open Ad will present")
//    }
//}
//
//extension Color {
//    init(hex: UInt) {
//        self.init(
//            .sRGB,
//            red: Double((hex >> 16) & 0xff) / 255,
//            green: Double((hex >> 8) & 0xff) / 255,
//            blue: Double(hex & 0xff) / 255,
//            opacity: 1
//        )
//    }
//}

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255
        )
    }
}

struct SplashView: View {
    var body: some View {
  
            
            VStack(spacing: 0) {
                Image("splash_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                
                Text("Wallet")
                    .font(.title)
                    .foregroundColor(Color(hex: 0x07492B))
                
                Text("budget")
                    .font(.title)
                    .foregroundColor(Color(hex: 0x07492B))
            }
        }
    }

