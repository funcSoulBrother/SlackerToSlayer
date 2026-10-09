//
//  AdBannerView.swift
//  Productivity Points
//
//  Created by Daniel Marsh on 9/23/26.
//

import SwiftUI
import GoogleMobileAds
import UIKit

struct AdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(
            adSize: AdSize(size: CGSize(width: 320, height: 50), flags: 0)
        )
        banner.adUnitID = "ca-app-pub-1269877083649460/4161863942"
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: \.isKeyWindow)?
            .rootViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
