//
//  ShimmerExtension.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.01.26.
//

import UIKit

/// Note:
/// A dedicated ShimmerView would be a more scalable solution,
/// but for this small project an extension-based shimmer is
/// intentionally used to keep the implementation lightweight
/// and avoid extra view hierarchy complexity
extension UIView {

    func startShimmer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "shimmerLayer"

        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.locations = [0, 0.5, 1]

        layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue   = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "shimmer")
    }

    func stopShimmer() {
        layer.sublayers?.removeAll(where: { $0.name == "shimmerLayer" })
    }
}

