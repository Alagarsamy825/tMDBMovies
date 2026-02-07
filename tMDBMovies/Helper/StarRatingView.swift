//
//  StarRatingView.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation
import UIKit

class StarRatingView: UIView {

    var maxRating: Int = 5
    var rating: Double = 0 {
        didSet { updateStars() }
    }

    private let filledColor = UIColor.systemYellow
    private let emptyColor = UIColor.systemGray4
    private var starLayers: [CAShapeLayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        createStars()
        updateStars()
    }

    private func createStars() {
        layer.sublayers?.removeAll()
        starLayers.removeAll()

        let starWidth = bounds.width / CGFloat(maxRating)

        for index in 0..<maxRating {
            let rect = CGRect(
                x: CGFloat(index) * starWidth,
                y: 0,
                width: starWidth,
                height: bounds.height
            ).insetBy(dx: 2, dy: 4)

            let starLayer = CAShapeLayer()
            starLayer.path = UIBezierPath.star(in: rect).cgPath
            starLayer.fillColor = emptyColor.cgColor

            layer.addSublayer(starLayer)
            starLayers.append(starLayer)
        }
    }

    private func updateStars() {
        for (index, layer) in starLayers.enumerated() {
            let starValue = Double(index) + 1
            layer.fillColor = rating >= starValue
                ? filledColor.cgColor
                : emptyColor.cgColor
        }
    }
}

extension UIBezierPath {
    static func star(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = 5
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * 0.45
        let angle = CGFloat.pi / CGFloat(points)

        for i in 0..<(points * 2) {
            let r = i.isMultiple(of: 2) ? radius : innerRadius
            let theta = CGFloat(i) * angle - CGFloat.pi / 2
            let point = CGPoint(
                x: center.x + r * cos(theta),
                y: center.y + r * sin(theta)
            )

            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        path.close()
        return path
    }
}
