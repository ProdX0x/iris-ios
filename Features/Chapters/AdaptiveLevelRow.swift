// AdaptiveLevelRow.swift
// Layer: Presentation
// Purpose: Lays a chapter's level buttons out inside exactly the width it is offered (see AdaptiveLevelRowMetrics):
// the row never reports a width larger than its proposal, so it can never widen the card or the screen

import SwiftUI

struct AdaptiveLevelRow: Layout {
    var style: AdaptiveLevelRowMetrics.Style = .standard

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = resolvedWidth(proposal, count: subviews.count)
        let metrics = AdaptiveLevelRowMetrics(count: subviews.count, availableWidth: width, style: style)
        return CGSize(width: width, height: metrics.totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let metrics = AdaptiveLevelRowMetrics(count: subviews.count, availableWidth: bounds.width, style: style)
        for (index, subview) in subviews.enumerated() {
            let cell = metrics.cell(at: index)
            subview.place(at: CGPoint(x: bounds.minX + cell.midX, y: bounds.minY + cell.midY), anchor: .center,
                          proposal: ProposedViewSize(width: metrics.target, height: metrics.target))
        }
    }

    /// The offered width; only when nothing is offered (or an unbounded width) the row falls back to its ideal width.
    private func resolvedWidth(_ proposal: ProposedViewSize, count: Int) -> CGFloat {
        if let width = proposal.width, width.isFinite {
            return max(width, 0)
        }
        return AdaptiveLevelRowMetrics.idealWidth(count: count, style: style)
    }
}
