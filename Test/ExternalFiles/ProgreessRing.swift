//
//  ProgreessRing.swift
//  Test
//
//  Created by PC on 06/07/22.
//

/* USE
 -> add class into UIView
 @IBOutlet var progressRing: ALProgressRing!
 
 progressRing.lineWidth = 10
 progressRing.timingFunction = .easeOutExpo
 progressRing.transform = .stratFromLeft
 progressRing.startColor = UIColor.red
 progressRing.endColor = UIColor.green
 progressRing.grooveColor = UIColor.purple.withAlphaComponent(0.2)
 progressRing.grooveWidth = 20
 progressRing.setProgress(0.60, animated: true)
 */


import UIKit

/// A fillable progress ring drawing.
open class ALProgressRing: UIView {

    // MARK: Properties

    /// Sets the line width for progress ring and groove ring.
    /// - Note: If you need separate customization use the `ringWidth` and `grooveWidth` properties
    public var lineWidth: CGFloat = 10 {
        didSet {
            ringWidth = lineWidth
            grooveWidth = lineWidth
        }
    }

    /// The line width of the progress ring.
    public var ringWidth: CGFloat = 10 {
        didSet {
            ringLayer.lineWidth = ringWidth
        }
    }

    /// The line width of the groove ring.
    public var grooveWidth: CGFloat = 10 {
        didSet {
            grooveLayer.lineWidth = grooveWidth
        }
    }

    /// The first gradient color of the track.
    public var startColor: UIColor = .blue {
        didSet { gradientLayer.colors = [startColor.cgColor, endColor.cgColor] }
    }

    /// The second gradient color of the track.
    public var endColor: UIColor = .blue {
        didSet { gradientLayer.colors = [startColor.cgColor, endColor.cgColor] }
    }

    /// The groove color in which the fillable ring resides.
    public var grooveColor: UIColor = .blue.withAlphaComponent(0.3) {
        didSet { grooveLayer.strokeColor = grooveColor.cgColor }
    }

    /// The start angle of the ring to begin drawing.
    public var startAngle: CGFloat = -.pi / 2 {
        didSet { ringLayer.path = ringPath() }
    }

    /// The end angle of the ring to end drawing.
    public var endAngle: CGFloat = 1.5 * .pi {
        didSet { ringLayer.path = ringPath() }
    }

    /// The starting poin of the gradient. Default is (x: 0.5, y: 0)
    public var startGradientPoint: CGPoint = .init(x: 0.5, y: 0) {
        didSet { gradientLayer.startPoint = startGradientPoint }
    }

    /// The ending position of the gradient. Default is (x: 0.5, y: 1)
    public var endGradientPoint: CGPoint = .init(x: 0.5, y: 1) {
        didSet { gradientLayer.endPoint = endGradientPoint }
    }

    /// Duration of the ring's fill animation. Default is 2.0
    public var duration: TimeInterval = 2.0

    /// Timing function of the ring's fill animation. Default is `.easeOutExpo`
    public var timingFunction: ALTimingFunction = .easeOutExpo

    /// The radius of the ring.
    public var ringRadius: CGFloat {
        var radius = min(bounds.height, bounds.width) / 2 - ringWidth / 2
        if ringWidth < grooveWidth {
            radius -= (grooveWidth - ringWidth) / 2
        }
        return radius
    }

    /// The radius of the groove.
    public var grooveRadius: CGFloat {
        var radius = min(bounds.height, bounds.width) / 2 - grooveWidth / 2
        if grooveWidth < ringWidth {
            radius -= (ringWidth - grooveWidth) / 2
        }
        return radius
    }

    /// The progress of the ring between 0 and 1. The ring will fill based on the value.
    public private(set) var progress: CGFloat = 0

    private let ringLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        return layer
    }()

    private let grooveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        layer.strokeEnd = 1
        return layer
    }()

    private let gradientLayer = CAGradientLayer()

    // MARK: Life Cycle
    public init() {
        super.init(frame: .zero)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configureRing()
        styleRingLayer()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        styleRingLayer()
    }

    // MARK: Methods

    /// Set the progress value of the ring. The ring will fill based on the value.
    ///
    /// - Parameters:
    ///   - value: Progress value between 0 and 1.
    ///   - animated: Flag for the fill ring's animation.
    ///   - completion: Closure called after animation ends
    public func setProgress(_ value: Float, animated: Bool, completion: (() -> Void)? = nil) {
        layoutIfNeeded()
        let value = CGFloat(min(value, 1.0))
        let oldValue = ringLayer.presentation()?.strokeEnd ?? progress
        progress = value
        ringLayer.strokeEnd = progress
        guard animated else {
            layer.removeAllAnimations()
            ringLayer.removeAllAnimations()
            gradientLayer.removeAllAnimations()
            completion?()
            return
        }

        CATransaction.begin()
        let path = #keyPath(CAShapeLayer.strokeEnd)
        let fill = CABasicAnimation(keyPath: path)
        fill.fromValue = oldValue
        fill.toValue = value
        fill.duration = duration
        fill.timingFunction = timingFunction.function
        CATransaction.setCompletionBlock(completion)
        ringLayer.add(fill, forKey: "fill")
        CATransaction.commit()
    }


    private func setup() {
        preservesSuperviewLayoutMargins = true
        layer.addSublayer(grooveLayer)
        layer.addSublayer(gradientLayer)
        styleRingLayer()
    }

    private func styleRingLayer() {
        grooveLayer.strokeColor = grooveColor.cgColor
        grooveLayer.lineWidth = grooveWidth

        ringLayer.lineWidth = ringWidth
        ringLayer.strokeColor = UIColor.black.cgColor
        ringLayer.strokeEnd = min(progress, 1.0)

        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1)

        gradientLayer.shadowColor = startColor.cgColor
        gradientLayer.shadowOffset = .zero
    }

    private func configureRing() {
        let ringPath = self.ringPath()
        let groovePath = self.groovePath()
        grooveLayer.frame = bounds
        grooveLayer.path = groovePath

        ringLayer.frame = bounds
        ringLayer.path = ringPath

        gradientLayer.frame = bounds
        gradientLayer.mask = ringLayer
    }

    private func ringPath() -> CGPath {
        let center = CGPoint(x: bounds.origin.x + frame.width / 2.0, y: bounds.origin.y + frame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center, radius: ringRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return circlePath.cgPath
    }

    private func groovePath() -> CGPath {
        let center = CGPoint(x: bounds.origin.x + frame.width / 2.0, y: bounds.origin.y + frame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center, radius: grooveRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return circlePath.cgPath
    }
}

public enum ALTimingFunction: String, CaseIterable, Hashable {
    case `default`
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
    case easeInSine
    case easeOutSine
    case easeInOutSine
    case easeInQuad
    case easeOutQuad
    case easeInOutQuad
    case easeInCubic
    case easeOutCubic
    case easeInOutCubic
    case easeInQuart
    case easeOutQuart
    case easeInOutQuart
    case easeInQuint
    case easeOutQuint
    case easeInOutQuint
    case easeInExpo
    case easeOutExpo
    case easeInOutExpo
    case easeInCirc
    case easeOutCirc
    case easeInOutCirc
    case easeInBack
    case easeOutBack
    case easeInOutBack

    var function: CAMediaTimingFunction {
        switch self {
        case .`default`:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        case .linear:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInEaseOut:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        case .easeInSine:
            return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
        case .easeOutSine:
            return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
        case .easeInOutSine:
            return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
        case .easeInQuad:
            return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
        case .easeOutQuad:
            return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
        case .easeInOutQuad:
            return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
        case .easeInCubic:
            return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
        case .easeOutCubic:
            return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
        case .easeInOutCubic:
            return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
        case .easeInQuart:
            return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
        case .easeOutQuart:
            return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
        case .easeInOutQuart:
            return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
        case .easeInQuint:
            return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
        case .easeOutQuint:
            return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
        case .easeInOutQuint:
            return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
        case .easeInExpo:
            return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
        case .easeOutExpo:
            return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        case .easeInOutExpo:
            return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
        case .easeInCirc:
            return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
        case .easeOutCirc:
            return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
        case .easeInOutCirc:
            return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
        case .easeInBack:
            return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
        case .easeOutBack:
            return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
        case .easeInOutBack:
            return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
        }
    }
}

extension CGAffineTransform {
    static let stratFromLeft = CGAffineTransform(scaleX: -1, y: 1)
    static let stratFromRight = identity
}
