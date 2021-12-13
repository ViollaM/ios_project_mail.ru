//
//  CircleProgressView.swift
//  StepperApp
//
//  Created by Ruben Egikian on 13.12.2021.
//

import UIKit

public class CircleProgressView: UIView {
    private var radius: CGFloat { (bounds.height - lineWidth) / 2 }
    private let baseLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    var oldProgress: CGFloat = 1
    var progress: CGFloat
    private let duration: TimeInterval
    private let delay: TimeInterval
    private let lineWidth: CGFloat = 10.0
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public init(progress: CGFloat, baseColor: UIColor, progressColor: UIColor, duration: TimeInterval, delay: TimeInterval) {
        self.progress = progress
        self.duration = duration
        self.delay = delay
        for layer in [baseLayer, progressLayer] {
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = lineWidth
            layer.lineCap = .round
        }
        baseLayer.strokeColor = baseColor.cgColor
        baseLayer.strokeEnd = 1.0

        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.strokeEnd = 0.0

        super.init(frame: .zero)

        layer.addSublayer(baseLayer)
        layer.addSublayer(progressLayer)
    }

    public func animateCircle(duration: TimeInterval, delay: TimeInterval) {
        progressLayer.removeAnimation(forKey: "circleAnimation")
        progressLayer.strokeEnd = 0
        addAnimation(duration: duration, delay: delay)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        baseLayer.frame = bounds
        progressLayer.frame = bounds

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let basePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: .initialAngle, endAngle: .endAngle(progress: oldProgress), clockwise: true)
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: .initialAngle * oldProgress, endAngle: .endAngle(progress: progress), clockwise: true)
        baseLayer.path = basePath.cgPath
        progressLayer.path = progressPath.cgPath
        oldProgress = progress
        addAnimation(duration: duration, delay: delay)
    }
}

private extension CircleProgressView {
    func addAnimation(duration: TimeInterval, delay: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "circleAnimation")
    }
}

private extension CGFloat {
    static var initialAngle: CGFloat = -(.pi / 2)

    static func endAngle(progress: CGFloat) -> CGFloat {
        .pi * 2 * progress + .initialAngle
    }
}
