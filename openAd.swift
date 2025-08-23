//
//  openAd.swift
//  Wallet budget - مصاريف
//
//  Created by test on 11/08/2025.
//

import SwiftUI
import GoogleMobileAds
import UIKit

//final class AppOpenAdManager: NSObject, ObservableObject {
//    private var appOpenAd: GADAppOpenAd?
//    private var isLoadingAd = false
//    private let adUnitID = "ca-app-pub-3940256099942544/5575463023"
//    
//    override init() {
//        super.init()
//        loadAd()
//        observeAppForeground()
//    }
//    
//    private func observeAppForeground() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appDidBecomeActive),
//            name: UIApplication.didBecomeActiveNotification,
//            object: nil
//        )
//    }
//    
//    @objc private func appDidBecomeActive() {
//        // Check premium status before showing ads
//        let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
//        if isPremium {
//            print("✅ User is premium - skipping app open ad")
//            return
//        }
//        
//        if let rootVC = UIApplication.shared.connectedScenes
//            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
//            .first {
//            showAdIfAvailable(from: rootVC)
//        }
//    }
//    
//    func loadAd() {
//        // Don't load ads for premium users
//        let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
//        if isPremium {
//            print("✅ User is premium - not loading app open ad")
//            return
//        }
//        
//        if isLoadingAd || appOpenAd != nil { return }
//        
//        isLoadingAd = true
//        GADAppOpenAd.load(
//            withAdUnitID: adUnitID,
//            request: GADRequest()
//        ) { [weak self] (ad: GADAppOpenAd?, error: Error?) in
//            self?.isLoadingAd = false
//            if let ad = ad {
//                self?.appOpenAd = ad
//                self?.appOpenAd?.fullScreenContentDelegate = self as? any GADFullScreenContentDelegate
//                print("✅ App Open Ad loaded")
//            } else if let error = error {
//                print("❌ Failed to load App Open Ad: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func showAdIfAvailable(from rootViewController: UIViewController) {
//        // Double-check premium status before showing
//        let isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
//        if isPremium {
//            print("✅ User is premium - not showing app open ad")
//            return
//        }
//        
//        guard let ad = appOpenAd else {
//            print("ℹ️ App Open Ad not ready")
//            loadAd()
//            return
//        }
//        
//        ad.present(fromRootViewController: rootViewController)
//    }
//}

final class AppOpenAdManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    private var appOpenAd: GADAppOpenAd?
    private var isLoadingAd = false
    private let adUnitID = "ca-app-pub-3940256099942544/5575463023"
    
    // Add reference to premium manager
    weak var premiumManager: SubscriptionManager?
    
    override init() {
        super.init()
        observeAppForeground()
    }
    
    // Method to set premium manager reference
    func setPremiumManager(_ manager: SubscriptionManager) {
        self.premiumManager = manager
        loadAd() // Load ad after setting premium manager
    }
    
    private func observeAppForeground() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appDidBecomeActive() {
        // Check premium status using the manager
        if premiumManager?.isPremiumUser == true {
            print("✅ User is premium - skipping app open ad")
            return
        }
        
        if let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
            .first {
            showAdIfAvailable(from: rootVC)
        }
    }
    
    func loadAd() {
        // Don't load ads for premium users
        if premiumManager?.isPremiumUser == true {
            print("✅ User is premium - not loading app open ad")
            return
        }
        
        if isLoadingAd || appOpenAd != nil { return }
        
        isLoadingAd = true
        GADAppOpenAd.load(
            withAdUnitID: adUnitID,
            request: GADRequest()
        ) { [weak self] (ad: GADAppOpenAd?, error: Error?) in
            self?.isLoadingAd = false
            if let ad = ad {
                self?.appOpenAd = ad
                self?.appOpenAd?.fullScreenContentDelegate = self
                print("✅ App Open Ad loaded")
            } else if let error = error {
                print("❌ Failed to load App Open Ad: \(error.localizedDescription)")
            }
        }
    }
    
    func showAdIfAvailable(from rootViewController: UIViewController) {
        // Double-check premium status before showing
        if premiumManager?.isPremiumUser == true {
            print("✅ User is premium - not showing app open ad")
            return
        }
        
        guard let ad = appOpenAd else {
            print("ℹ️ App Open Ad not ready")
            loadAd()
            return
        }
        
        ad.present(fromRootViewController: rootViewController)
    }
    
    // MARK: - GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        loadAd()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Failed to present: \(error.localizedDescription)")
        appOpenAd = nil
        loadAd()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("🎬 App Open Ad will present")
    }
}
