// AncreSilhouette.swift
// Layer: Presentation
// Purpose: Chapter X final « l'ancre »: the head-and-shoulders silhouette that frames the anchor, traced from the
// reference image `x7_silhouette_reference.png` (crown, ears, jaw, neck and shoulders only: no face, no text, no
// button). Points are in face half-widths from the face centre, screen convention (+y down); the right half is
// authored and the left half is its mirror, so the figure stays exactly symmetric.

import SwiftUI

enum AncreSilhouette {
    /// Right half of the outer contour, crown to chin; the ear replaces the stretch of head it hides.
    static let headRight: [CGPoint] = [
        CGPoint(x: 0.000, y: -1.501), CGPoint(x: 0.309, y: -1.456), CGPoint(x: 0.586, y: -1.316), CGPoint(x: 0.800, y: -1.101),
        CGPoint(x: 0.932, y: -0.839), CGPoint(x: 0.992, y: -0.572), CGPoint(x: 1.005, y: -0.327), CGPoint(x: 0.993, y: -0.150),
        // The ear, from its upper attachment round to the lobe.
        CGPoint(x: 1.140, y: -0.105), CGPoint(x: 1.196, y: 0.000), CGPoint(x: 1.197, y: 0.165), CGPoint(x: 1.163, y: 0.293),
        CGPoint(x: 1.109, y: 0.422), CGPoint(x: 1.038, y: 0.522), CGPoint(x: 0.977, y: 0.580),
        // Jaw and chin.
        CGPoint(x: 0.896, y: 0.651), CGPoint(x: 0.867, y: 0.780), CGPoint(x: 0.816, y: 0.907), CGPoint(x: 0.737, y: 1.015),
        CGPoint(x: 0.645, y: 1.117), CGPoint(x: 0.540, y: 1.213), CGPoint(x: 0.425, y: 1.308), CGPoint(x: 0.297, y: 1.398),
        CGPoint(x: 0.154, y: 1.466), CGPoint(x: 0.000, y: 1.492),
    ]

    /// Right neck line, from under the jaw down into the shoulder, to where the reference lets it fade.
    static let shoulderRight: [CGPoint] = [
        CGPoint(x: 0.665, y: 1.081), CGPoint(x: 0.625, y: 1.150), CGPoint(x: 0.637, y: 1.230), CGPoint(x: 0.644, y: 1.360),
        CGPoint(x: 0.653, y: 1.467), CGPoint(x: 0.676, y: 1.553), CGPoint(x: 0.735, y: 1.624), CGPoint(x: 0.821, y: 1.685),
        CGPoint(x: 0.964, y: 1.753), CGPoint(x: 1.107, y: 1.814), CGPoint(x: 1.250, y: 1.875), CGPoint(x: 1.394, y: 1.939),
    ]

    /// The shoulder line keeps its light up to the first bound and has faded out at the second (face half-widths).
    static let shoulderFade: ClosedRange<CGFloat> = 0.95...1.394

    /// The closed contour: the right half, then the mirrored left half (crown and chin not repeated).
    static var headContour: [CGPoint] {
        let left = headRight.dropFirst().dropLast().reversed().map { CGPoint(x: -$0.x, y: $0.y) }
        return headRight + left
    }

    /// How much of the head's lean a point follows: all of it on the head, fading down the neck, none on the shoulders.
    static func leanWeight(_ y: CGFloat) -> CGFloat {
        min(1, max(0, (1.6 - y) / 0.5))
    }

    /// Unit points placed on screen: `center` is the face centre, `scale` one face half-width in points, `lean` the
    /// head's shift in face half-widths.
    static func place(_ points: [CGPoint], center: CGPoint, scale: CGFloat, lean: CGVector = .zero, mirrored: Bool = false) -> [CGPoint] {
        points.map { point in
            let x = mirrored ? -point.x : point.x
            let weight = leanWeight(point.y)
            return CGPoint(x: center.x + (x + lean.dx * weight) * scale, y: center.y + (point.y + lean.dy * weight) * scale)
        }
    }

    static func headPath(center: CGPoint, scale: CGFloat, lean: CGVector = .zero) -> Path {
        smoothPath(through: place(headContour, center: center, scale: scale, lean: lean), closed: true)
    }

    static func shoulderPath(center: CGPoint, scale: CGFloat, lean: CGVector = .zero, mirrored: Bool) -> Path {
        smoothPath(through: place(shoulderRight, center: center, scale: scale, lean: lean, mirrored: mirrored), closed: false)
    }

    /// A centripetal Catmull-Rom curve through the points, as cubic Béziers: no cusp and no overshoot where the ears
    /// attach.
    static func smoothPath(through points: [CGPoint], closed: Bool) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        let count = points.count
        guard count > 1 else { return path }
        func point(_ index: Int) -> CGPoint {
            closed ? points[(index % count + count) % count] : points[min(max(index, 0), count - 1)]
        }
        for index in 0..<(closed ? count : count - 1) {
            let controls = controlPoints(point(index - 1), point(index), point(index + 1), point(index + 2))
            path.addCurve(to: point(index + 1), control1: controls.0, control2: controls.1)
        }
        if closed { path.closeSubpath() }
        return path
    }

    private static func controlPoints(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> (CGPoint, CGPoint) {
        func root(_ a: CGPoint, _ b: CGPoint) -> CGFloat { hypot(b.x - a.x, b.y - a.y).squareRoot() }
        let d1 = root(p0, p1), d2 = root(p1, p2), d3 = root(p2, p3)
        guard d2 > 1e-9 else { return (p1, p2) }
        var first = CGPoint(x: p1.x + (p2.x - p1.x) / 3, y: p1.y + (p2.y - p1.y) / 3)
        var second = CGPoint(x: p2.x - (p2.x - p1.x) / 3, y: p2.y - (p2.y - p1.y) / 3)
        if d1 > 1e-9 {
            let a = d1 * d1, b = d2 * d2, k = 3 * d1 * (d1 + d2)
            first = CGPoint(x: (a * p2.x - b * p0.x + (2 * a + 3 * d1 * d2 + b) * p1.x) / k,
                            y: (a * p2.y - b * p0.y + (2 * a + 3 * d1 * d2 + b) * p1.y) / k)
        }
        if d3 > 1e-9 {
            let a = d3 * d3, b = d2 * d2, k = 3 * d3 * (d3 + d2)
            second = CGPoint(x: (a * p1.x - b * p3.x + (2 * a + 3 * d3 * d2 + b) * p2.x) / k,
                             y: (a * p1.y - b * p3.y + (2 * a + 3 * d3 * d2 + b) * p2.y) / k)
        }
        return (first, second)
    }
}
