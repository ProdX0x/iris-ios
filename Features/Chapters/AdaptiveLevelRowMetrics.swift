// AdaptiveLevelRowMetrics.swift
// Layer: Presentation
// Purpose: Geometry of a chapter's level buttons inside the width the card gives them: as many per row as fit with
// comfortable touch targets, spacing given up before size, rows balanced, never wider than the width received

import SwiftUI

struct AdaptiveLevelRowMetrics: Hashable, Sendable {
    struct Style: Hashable, Sendable {
        /// Smallest touch target (Human Interface Guidelines).
        var minimumTarget: CGFloat = 44
        /// Largest visual circle: the historical size of a level button.
        var maximumCircle: CGFloat = 48
        /// Gap between the circle and the edge of its touch target.
        var circleInset: CGFloat = 1
        /// How far the ring of the next level to play reaches outside the circle.
        var ringOutset: CGFloat = 5
        var preferredSpacing: CGFloat = DSSpacing.s
        var minimumSpacing: CGFloat = DSSpacing.xs
        var rowSpacing: CGFloat = DSSpacing.s

        /// Largest touch target: the largest circle and its inset.
        var maximumTarget: CGFloat { maximumCircle + 2 * circleInset }

        static let standard = Style()
    }

    let style: Style
    let count: Int
    let width: CGFloat
    let columns: Int
    let rows: Int
    let spacing: CGFloat
    let cellWidth: CGFloat
    /// Side of the square touch target placed at the centre of each cell.
    let target: CGFloat

    init(count: Int, availableWidth: CGFloat, style: Style = .standard) {
        self.style = style
        let count = max(count, 0)
        let width = availableWidth.isFinite ? max(availableWidth, 0) : 0
        self.count = count
        self.width = width
        guard count > 0 else {
            columns = 0
            rows = 0
            spacing = 0
            cellWidth = 0
            target = 0
            return
        }
        // 1. One row if every level keeps a full touch target with at least the minimum spacing.
        let fitting = Int(((width + style.minimumSpacing) / (style.minimumTarget + style.minimumSpacing)).rounded(.down))
        let widest = min(count, max(1, fitting))
        // 2. Otherwise as few rows as possible, balanced (seven levels become four and three, never six and one).
        let rowCount = Int((Double(count) / Double(widest)).rounded(.up))
        let columns = Int((Double(count) / Double(rowCount)).rounded(.up))
        self.columns = columns
        rows = Int((Double(count) / Double(columns)).rounded(.up))
        // 3. Spacing is given up (down to its minimum) before the targets shrink below their comfortable size.
        if columns > 1 {
            let room = (width - CGFloat(columns) * style.minimumTarget) / CGFloat(columns - 1)
            spacing = min(style.preferredSpacing, max(style.minimumSpacing, room))
        } else {
            spacing = 0
        }
        let cell = max(0, (width - CGFloat(columns - 1) * spacing) / CGFloat(columns))
        cellWidth = cell
        // 4. The circle takes what the cell allows, up to its historical size.
        target = min(cell, style.maximumTarget)
    }

    /// Visual diameter of the level circle.
    var circle: CGFloat { max(0, target - 2 * style.circleInset) }

    /// Height of one row: the touch target.
    var rowHeight: CGFloat { target }

    var totalHeight: CGFloat {
        rows == 0 ? 0 : CGFloat(rows) * rowHeight + CGFloat(rows - 1) * style.rowSpacing
    }

    /// Frame of the cell holding level `index` (row by row, the last row centred), relative to the row's origin.
    func cell(at index: Int) -> CGRect {
        guard count > 0, columns > 0, (0..<count).contains(index) else { return .zero }
        let row = index / columns
        let column = index % columns
        let inRow = min(columns, count - row * columns)
        let rowWidth = CGFloat(inRow) * cellWidth + CGFloat(max(inRow - 1, 0)) * spacing
        let leading = (width - rowWidth) / 2
        return CGRect(x: leading + CGFloat(column) * (cellWidth + spacing),
                      y: CGFloat(row) * (rowHeight + style.rowSpacing),
                      width: cellWidth, height: rowHeight)
    }

    /// Width the row would like when nothing constrains it (every circle at its historical size, preferred spacing).
    static func idealWidth(count: Int, style: Style = .standard) -> CGFloat {
        guard count > 0 else { return 0 }
        return CGFloat(count) * style.maximumTarget + CGFloat(count - 1) * style.preferredSpacing
    }
}
