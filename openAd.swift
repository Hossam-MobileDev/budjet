//
//  openAd.swift
//  Wallet budget - مصاريف
//
//  Created by test on 11/08/2025.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final class AppOpenAdManager: NSObject, ObservableObject {
    private var appOpenAd: GADAppOpenAd?
    private var isLoadingAd = false
 
//    private let adUnitID = "ca-app-pub-1439642083038769/2243380376"
    
       private let adUnitID = "ca-app-pub-3940256099942544/5575463023"
    
    override init() {
        super.init()
        loadAd()
        observeAppForeground()
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
        if let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
            .first {
            showAdIfAvailable(from: rootVC)
        }
    }

    func loadAd() {
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
        guard let ad = appOpenAd else {
            print("ℹ️ App Open Ad not ready")
            loadAd()
            return
        }

        ad.present(fromRootViewController: rootViewController)
    }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        loadAd()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Failed to present: \(error.localizedDescription)")
        appOpenAd = nil
        loadAd()
    }
}
