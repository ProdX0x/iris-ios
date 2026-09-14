// AdaptiveLevelRowMetricsTests.swift
// Layer: Tests
// Purpose: The level row geometry for 1 to 10 levels on every supported width: inside its width, full touch targets,
// one row when it fits, balanced rows otherwise, circles at most the historical size, rings clear of neighbours

import CoreGraphics
import Testing
@testable import Iris

@Suite("Adaptive level row metrics")
struct AdaptiveLevelRowMetricsTests {
    /// Width left for the levels on each phone (screen minus page gutters minus card padding), and a capped iPad column.
    static let widths: [CGFloat] = [375 - 96, 393 - 96, 402 - 96, 430 - 96, 440 - 96, 560 - 48]
    static let counts = [1, 5, 6, 7, 8, 10]

    @Test("every cell stays inside the width, cells never overlap, order is row by row")
    func inside() {
        for width in Self.widths {
            for count in Self.counts {
                let metrics = AdaptiveLevelRowMetrics(count: count, availableWidth: width)
                let cells = (0..<count).map(metrics.cell(at:))
                for (index, cell) in cells.enumerated() {
                    #expect(cell.minX >= -0.001 && cell.maxX <= width + 0.001, "\(count) levels in \(width) pt: cell \(index) \(cell)")
                    #expect(cell.minY >= -0.001 && cell.maxY <= metrics.totalHeight + 0.001)
                    if index > 0 {
                        let previous = cells[index - 1]
                        let sameRow = abs(previous.minY - cell.minY) < 0.001
                        #expect(sameRow ? cell.minX >= previous.maxX - 0.001 : cell.minY >= previous.maxY - 0.001, "\(count) in \(width): order at \(index)")
                    }
                }
            }
        }
    }

    @Test("touch targets are never below 44 pt and circles never above the historical 48 pt")
    func targets() {
        for width in Self.widths {
            for count in Self.counts {
                let metrics = AdaptiveLevelRowMetrics(count: count, availableWidth: width)
                #expect(metrics.target >= 44, "\(count) levels in \(width) pt: target \(metrics.target)")
                #expect(metrics.circle <= 48 && metrics.circle >= 42, "\(count) levels in \(width) pt: circle \(metrics.circle)")
                #expect(metrics.cellWidth >= metrics.target - 0.001)
            }
        }
    }

    @Test("one row whenever every level keeps a full target; balanced rows otherwise")
    func rows() {
        for width in Self.widths {
            for count in Self.counts {
                let metrics = AdaptiveLevelRowMetrics(count: count, availableWidth: width)
                let fitsOneRow = CGFloat(count) * 44 + CGFloat(count - 1) * 4 <= width
                #expect((metrics.rows == 1) == fitsOneRow, "\(count) levels in \(width) pt: \(metrics.rows) rows")
                #expect(metrics.rows * metrics.columns >= count && (metrics.rows - 1) * metrics.columns < count)
                let lastRow = count - (metrics.rows - 1) * metrics.columns
                #expect(lastRow >= 1 && metrics.columns - lastRow < metrics.rows, "\(count) in \(width): last row \(lastRow) of \(metrics.columns)")
            }
        }
    }

    @Test("the phones of the campaign: six levels in one row on a 393 pt phone, seven in four and three; seven in one row on a Pro Max")
    func campaignCases() {
        let fourteenPro: CGFloat = 393 - 96
        let six = AdaptiveLevelRowMetrics(count: 6, availableWidth: fourteenPro)
        #expect(six.rows == 1 && six.target >= 44)
        let seven = AdaptiveLevelRowMetrics(count: 7, availableWidth: fourteenPro)
        #expect(seven.rows == 2 && seven.columns == 4 && seven.circle == 48)
        let proMax = AdaptiveLevelRowMetrics(count: 7, availableWidth: 440 - 96)
        #expect(proMax.rows == 1 && proMax.target >= 44)
        let five = AdaptiveLevelRowMetrics(count: 5, availableWidth: fourteenPro)
        #expect(five.rows == 1 && five.circle == 48 && five.spacing == 8, "five levels keep the historical look")
        let small = AdaptiveLevelRowMetrics(count: 6, availableWidth: 375 - 96)
        #expect(small.rows == 2 && small.columns == 3)
    }

    @Test("the next-level ring never reaches a neighbouring cell")
    func ring() {
        for width in Self.widths {
            for count in Self.counts {
                let metrics = AdaptiveLevelRowMetrics(count: count, availableWidth: width)
                let ring = metrics.circle + 2 * metrics.style.ringOutset
                let beyondCell = max(0, (ring - metrics.cellWidth) / 2)
                if metrics.columns > 1 {
                    #expect(beyondCell <= metrics.spacing + 0.001, "\(count) levels in \(width) pt: ring reaches \(beyondCell) pt past its cell, spacing \(metrics.spacing)")
                }
                #expect(max(0, (ring - metrics.rowHeight) / 2) <= metrics.style.rowSpacing)
            }
        }
    }

    @Test("degenerate inputs: no level, a width of zero or unbounded, a number of levels far larger than today")
    func degenerate() {
        let none = AdaptiveLevelRowMetrics(count: 0, availableWidth: 300)
        #expect(none.totalHeight == 0 && none.cell(at: 0) == .zero)
        let zero = AdaptiveLevelRowMetrics(count: 7, availableWidth: 0)
        #expect(zero.cellWidth == 0 && (0..<7).allSatisfy { zero.cell(at: $0).maxX <= 0.001 })
        let infinite = AdaptiveLevelRowMetrics(count: 7, availableWidth: .infinity)
        #expect(infinite.width == 0)
        let many = AdaptiveLevelRowMetrics(count: 24, availableWidth: 297)
        #expect(many.target >= 44 && (0..<24).allSatisfy { many.cell(at: $0).maxX <= 297.001 } && many.rows == 4)
        let ideal = AdaptiveLevelRowMetrics.idealWidth(count: 7)
        let expected: CGFloat = 7 * 50 + 6 * 8
        #expect(abs(ideal - expected) < 0.001, "ideal width \(ideal), expected \(expected)")
    }
}
