//
//  UIView+Extensions.swift
//  FlixAR
//
//  Created by Anton Romanov on 13.10.2021.
//

import UIKit

// MARK: - Gradient
extension UIView {
    func addGradient(gradientOwner: GradientOwner) {
        layer.sublayers = layer.sublayers?.filter { !($0 is CAGradientLayer) }
        let gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = gradientOwner.backgroundColor
        gradientLayer.colors = gradientOwner.colors

        gradientLayer.locations = gradientOwner.locations
        gradientLayer.startPoint = gradientOwner.startPoint
        gradientLayer.endPoint = gradientOwner.endPoint

        gradientLayer.frame = bounds
        if let cornerRadius = gradientOwner.cornerRadius {
            gradientLayer.cornerRadius = cornerRadius
        }
        if let borderWidth = gradientOwner.borderWidth, let borderColor = gradientOwner.borderColor {
            gradientLayer.borderWidth = borderWidth
            gradientLayer.borderColor = borderColor.cgColor
        }
        gradientLayer.transform = gradientOwner.transform
        gradientLayer.bounds = gradientOwner.adjustedBounds(bounds)
        gradientLayer.position = center
        self.layer.addSublayer(gradientLayer)
    }

    func removeAllGradientLayers() {
        layer.sublayers = layer.sublayers?.filter { !($0 is CAGradientLayer) }
    }
}
