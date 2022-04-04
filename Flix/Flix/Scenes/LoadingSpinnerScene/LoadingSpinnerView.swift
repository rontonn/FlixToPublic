//
//  LoadingSpinnerView.swift
//  Flix
//
//  Created by Anton Romanov on 05.11.2021.
//

import UIKit

final class LoadingSpinnerView: UIView {
    // MARK: - Properties
    private var loadingLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.contents = #imageLiteral(resourceName: "loadingSpinner").cgImage
        return l
    }()
    private var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .jakarta(font: .display, ofSize: 50, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    private var subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .jakarta(font: .display, ofSize: 28, weight: .regular)
        l.textColor = .white.withAlphaComponent(0.5)
        l.textAlignment = .center
        return l
    }()

    private var titles: Titles?
    

    // MARK: - Lifecycle
    init(frame: CGRect, titles: Titles?) {
        super.init(frame: frame)
        self.titles = titles
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension LoadingSpinnerView {
    var isAnimating: Bool {
        if let animationKeys = loadingLayer.animationKeys(),
            !animationKeys.isEmpty {
            return true
        }
        return false
    }
    func startAnimating() {
        if !isAnimating {
            animateRotation()
        }
    }

    func stopAnimating() {
        loadingLayer.removeAllAnimations()
    }
}

// MARK: - Private methods
private extension LoadingSpinnerView {
    func configure() {
        backgroundColor = .black.withAlphaComponent(0.9)
        let loaderXPosition = bounds.width / 2 - size.width / 2
        var loaderYPosition = bounds.height / 2 - size.height / 2
        if let titles = titles {
            loaderYPosition = 224
            titleLabel.text = titles.title
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -10),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20)
            ])
            if let subtitle = titles.subtitle {
                subtitleLabel.text = subtitle
                addSubview(subtitleLabel)
                NSLayoutConstraint.activate([
                    subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
                    subtitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -10),
                    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25)
                ])
            }
        }
        loadingLayer.frame = CGRect(x: loaderXPosition,
                                    y: loaderYPosition,
                                    width: size.width,
                                    height: size.height)
        layer.addSublayer(loadingLayer)
    }

    var size: CGSize {
        return CGSize(width: 196, height: 196)
    }
    var keyTimesOfRotation: [NSNumber] {
        return [0.0,
                0.25,
                0.5,
                0.75,
                1.0]
    }

    var valuesOfRotation: [CGFloat] {
        return [0.0,
                1.0 * .pi,
                2.0 * .pi,
                3.0 * .pi,
                4.0 * .pi]
    }

    var durationOfRotation: CFTimeInterval {
        return 2.0
    }

    func animateRotation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.keyTimes = keyTimesOfRotation
        animation.values = valuesOfRotation
        animation.calculationMode = .linear
        animation.duration = durationOfRotation
        animation.repeatCount = Float.infinity
        loadingLayer.add(animation, forKey: animation.keyPath)
    }
}

extension LoadingSpinnerView {
    struct Titles {
        let title: String
        let subtitle: String?
    }
}
