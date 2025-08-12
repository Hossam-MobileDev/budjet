//
//  settingmyapp.swift
//  budgetWallet
//
//  Created by test on 31/01/2025.
//

import SwiftUI



class SettingsLanguageManager: ObservableObject {
    static let shared = SettingsLanguageManager()
    @Published var isArabic: Bool {
        didSet {
            UserDefaults.standard.set(isArabic, forKey: "isArabic")
        }
    }
    
    init() {
        self.isArabic = UserDefaults.standard.bool(forKey: "isArabic")
    }
    
    func localizedString(arabic: String, english: String) -> String {
        return isArabic ? arabic : english
    }
    
    var supportedNumeralsErrorMessage: String {
        let supportedNumerals = isArabic ? "٠١٢٣٤٥٦٧٨٩ أو 0123456789" : "0123456789 or ٠١٢٣٤٥٦٧٨٩"
        return isArabic ?
            "يرجى استخدام أرقام صحيحة: \(supportedNumerals)" :
            "Please use valid numbers: \(supportedNumerals)"
    }
    
    func validationMessage(for field: String) -> String {
        return isArabic ? "الرجاء إدخال \(field)" : "Please enter \(field)"
    }
}

struct SettingsColors {
    let background: Color
    let cardBackground: Color
    let accent: Color
    let divider: Color
    let text: Color
    let secondaryText: Color
}

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("AlmaraiBold", size: 17))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content
        }
    }
}

struct SettinappView: View {
    @Binding var togglefullscreen: Bool
    @Environment(\.openURL) var openURL
    
    @StateObject private var languageManager = LanguageManager.shared
    private let supportEmail = "support@3rabapp.com"
    
    private let colors = SettingsColors(
        background: .white,
        cardBackground: Color(hex: "F5F5F5"),
        accent: Color(hex: "007AFF"),
        divider: Color(hex: "E0E0E0"),
        text: .black,
        secondaryText: Color.black.opacity(0.6)
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with close button
                HStack {
                    Spacer()
                    Button(action: { togglefullscreen.toggle() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(colors.secondaryText)
                            .font(.system(size: 28))
                            .padding()
                    }
                }
                
                // Title
                Text(languageManager.isArabic ? "الاعدادات الرئيسية" : "Main Settings")
                    .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 24) : .system(size: 24, weight: .bold))
                    .foregroundColor(colors.text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                
                // Language Toggle Section
                SectionView(title: languageManager.isArabic ? "تغيير اللغة" : "Language Settings") {
                    Button(action: {
                        withAnimation {
                            languageManager.isArabic.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(colors.accent)
                                .font(.system(size: 20))
                            
                            Text(languageManager.isArabic ? "الانجليزية" : "Arabic")
                                .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 15) : .system(size: 15, weight: .semibold))
                            
                            Spacer()
                            
                            Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "787880"))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(colors.cardBackground)
                        .cornerRadius(10)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal)
                }
                
                // Feedback Section
                SectionView(title: languageManager.isArabic ? "ساعدنا لتحسين تطبيقنا" : "Help us to improve our app") {
                    VStack(spacing: 12) {
                        FeedbackButton(
                            icon: "star.fill",
                            text: languageManager.isArabic ? "قيم تطبيقنا علي المتجر" : "Rate Our App",
                            iconColor: Color(hex: "FFD700"),
                            action: rateApp
                        )
                        .environmentObject(languageManager)
                        
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "envelope.fill",
                            text: languageManager.isArabic ? "شاركنا اقتراحك" : "Share Your Feedback",
                            iconColor: Color(hex: "4CD964"),
                            action: sendEmail
                        )
                        .environmentObject(languageManager)
                        
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "exclamationmark.triangle.fill",
                            text: languageManager.isArabic ? "لديك مشكلة؟" : "Having Issues?",
                            iconColor: Color(hex: "FF9500"),
                            action: sendEmail
                        )
                        .environmentObject(languageManager)
                        
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "heart.slash.fill",
                            text: languageManager.isArabic ? "لا تستمتع بالتطبيق؟" : "Not Enjoying the App?",
                            iconColor: Color(hex: "FF3B30"),
                            action: sendEmail
                        )
                        .environmentObject(languageManager)
                        
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "square.and.arrow.up",
                            text: languageManager.isArabic ? "مشاركة التطبيق مع اصدقاءك" : "Share App with Friends",
                            iconColor: Color(hex: "007AFF"),
                            action: shareApp
                        )
                        .environmentObject(languageManager)
                    }
                    .padding(.vertical, 8)
                    .background(colors.cardBackground)
                    .cornerRadius(12)
                }
                
                // Our Apps Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(languageManager.isArabic ? "تفقد تطبيقاتنا على المتجر" : "Check out our apps")
                        .font(.custom("AlmaraiBold", size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        AppListItem(
                            title: languageManager.isArabic ? "القبلة" : "Muslim Qibla",
                            subtitle: languageManager.isArabic ? "اتجاه القبلة الدقيق" : "Accurate Qibla Direction",
                            iconName: "qibla",
                            appId: "id6736939515",
                            colors: colors
                        )
                        
                        AppListItem(
                            title: languageManager.isArabic ? "سرعة النت" : "Speedtest",
                            subtitle: languageManager.isArabic ? "قياس سرعة الإنترنت" : "Internet Speed Test",
                            iconName: "speedtest",
                            appId: "id1635139320",
                            colors: colors
                        )
                        
                        AppListItem(
                            title: languageManager.isArabic ? "مقارنة الأسعار" : "Product Finder",
                            subtitle: languageManager.isArabic ? "مقارنة أسعار المنتجات" : "Price Comparison",
                            iconName: "finder",
                            appId: "id6737802621",
                            colors: colors
                        )
                        
                        AppListItem(
                            title: languageManager.isArabic ? "كتابة علي الصور" : "Kitaba",
                            subtitle: languageManager.isArabic ? "تصميم صور وخطوط عربية" : "Design Photos & Arabic Fonts",
                            iconName: "kitaba",
                            appId: "id958075714",
                            colors: colors
                        )
                        
                        AppListItem(
                            title: languageManager.isArabic ? "محول العملات" : "Currency Converter",
                            subtitle: languageManager.isArabic ? "تحويل العملات العالمية" : "Global Currency Exchange",
                            iconName: "currency",
                            appId: "id1492580244",
                            colors: colors
                        )
                        
                        AppListItem(
                            title: languageManager.isArabic ? "زخرفة" : "Zakhrafa",
                            subtitle: languageManager.isArabic ? "زخرفة النصوص العربية" : "Arabic Text Decoration",
                            iconName: "zaghrafalogo",
                            appId: "id6476085334",
                            colors: colors
                        )
                        
                        AppListItem(
                            title: languageManager.isArabic ? "خطوات" : "Steps",
                            subtitle: languageManager.isArabic ? "عداد الخطوات اليومية" : "Daily Step Counter",
                            iconName: "zatawaty",
                            appId: "id6502876950",
                            colors: colors
                        )
                    }
                }
                
                // Footer Links
                HStack(spacing: 16) {
                    FooterLink(
                        title: languageManager.isArabic ? "شروط الاستخدام" : "Terms of Use",
                        url: "https://3rabapp.com/legal/term_of_use.html"
                    )
                    Text("|").foregroundColor(colors.secondaryText)
                    FooterLink(
                        title: languageManager.isArabic ? "الخصوصية" : "Privacy Policy",
                        url: "https://3rabapp.com/legal/privacy_policy.html"
                    )
                }
                .padding(.top, 32)
                .padding(.bottom, 16)
            }
            .padding(.horizontal)
        }
        .background(colors.background.ignoresSafeArea())
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    private func rateApp() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6741729309?action=write-review") else { return }
        openURL(writeReviewURL)
    }
    
    private func sendEmail() {
        guard let emailURL = URL(string: "mailto:\(supportEmail)") else { return }
        openURL(emailURL)
    }
    
    private func shareApp() {
        Task { @MainActor in
            let shareText = languageManager.isArabic ? "تحقق من هذا التطبيق الرائع!" : "Check out this amazing app!"
            let appURL = "https://apps.apple.com/app/id6741729309"
            let itemsToShare = [shareText, appURL]
            
            let activityVC = UIActivityViewController(
                activityItems: itemsToShare,
                applicationActivities: nil
            )
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                return
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = rootViewController.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(
                    x: rootViewController.view.bounds.midX,
                    y: rootViewController.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                activityVC.popoverPresentationController?.permittedArrowDirections = []
            }
            
            var topController = rootViewController
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(activityVC, animated: true, completion: nil)
        }
    }
}

struct FeedbackButton: View {
    let icon: String
    let text: String
    let iconColor: Color
    let action: () -> Void
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 20))
                
                Text(text)
                    .font(languageManager.isArabic ? .custom("AlmaraiBold", size: 15) : .system(size: 15, weight: .semibold))
                
                Spacer()
                
                Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "787880"))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(hex: "F5F5F5"))
            .cornerRadius(10)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal)
    }
}

struct AppListItem: View {
    let title: String
    let subtitle: String
    let iconName: String
    let appId: String
    let colors: SettingsColors
    @Environment(\.openURL) var openURL
    
    private let appURLs: [String: String] = [
        "زخرفة": "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334",
        "Zakhrafa": "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334",
        "كتابة علي الصور": "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714",
        "Kitaba": "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714",
        "محول العملات": "https://apps.apple.com/us/app/currency-currency-converter/id1492580244",
        "Currency Converter": "https://apps.apple.com/us/app/currency-currency-converter/id1492580244",
        "خطوات": "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950",
        "Steps": "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950",
        "القبلة": "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515",
        "Muslim Qibla": "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515",
        "سرعة النت": "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320",
        "Speedtest": "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320",
        "مقارنة الأسعار": "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621",
        "Product Finder": "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621"
    ]
    
    var body: some View {
        Button {
            let urlString = appURLs[title] ?? "https://apps.apple.com/app/\(appId)"
            if let url = URL(string: urlString) {
                openURL(url)
            }
        } label: {
            HStack(spacing: 16) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("AlmaraiBold", size: 15))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.custom("Almarai", size: 13))
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Image("get")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(colors.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct FooterLink: View {
    let title: String
    let url: String
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button(title) {
            if let validURL = URL(string: url) {
                openURL(validURL)
            }
        }
        .font(.custom("Almarai", size: 14))
        .foregroundColor(.black)
    }
}

struct DividerLine: View {
    let color: Color
    
    var body: some View {
        color
            .frame(height: 1)
            .opacity(0.3)
            .padding(.horizontal, 16)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
