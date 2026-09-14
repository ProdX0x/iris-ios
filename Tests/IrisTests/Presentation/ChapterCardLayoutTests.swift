// ChapterCardLayoutTests.swift
// Layer: Tests
// Purpose: Every chapter card of the campaign, on every supported phone width and with larger text, fits the width it
// is given (it can no longer widen the screen); optional control images of the cards for visual review

import SwiftUI
import Testing
import UIKit
@testable import Iris

@Suite("Chapter card layout")
@MainActor
struct ChapterCardLayoutTests {
    /// Width a card receives on each phone: screen width minus the two page gutters.
    static let cardWidths: [CGFloat] = [375 - 48, 393 - 48, 402 - 48, 430 - 48, 440 - 48]

    private func card(_ chapter: ChapterDefinition, unlocked: Bool = true) -> ChapterCard {
        let nodes = chapter.levels.enumerated().map { index, level in
            (level: level, state: index == chapter.levels.count - 1 ? LevelNode.State.next : .completed, eclats: Set(Eclat.allCases))
        }
        return ChapterCard(chapter: chapter, isUnlocked: unlocked, completed: chapter.levels.count - 1, nodes: nodes,
                           lockedHint: "Terminez le chapitre précédent", onSelect: { _ in })
    }

    private func fittingSize(_ view: some View, width: CGFloat) -> CGSize {
        let host = UIHostingController(rootView: view)
        return host.sizeThatFits(in: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }

    @Test("the campaign still has twelve chapters of 6, 6 and 7 levels (the cases this layout must hold)")
    func campaignShape() {
        #expect(Campaign.chapters.map(\.levels.count) == [6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7])
        #expect(Campaign.levels.count == 82)
    }

    @Test("every chapter card fits every phone width, unlocked and locked")
    func cardsFit() {
        for width in Self.cardWidths {
            for chapter in Campaign.chapters {
                for unlocked in [true, false] {
                    let size = fittingSize(card(chapter, unlocked: unlocked), width: width)
                    #expect(size.width <= width + 0.5, "chapter \(chapter.numeral) \(unlocked ? "open" : "locked") in \(width) pt: \(size.width)")
                }
            }
        }
    }

    @Test("with larger text the cards still fit: the texts wrap, the counter stays")
    func largerText() {
        let widths: [CGFloat] = [375 - 48, 393 - 48]
        for width in widths {
            for size in [DynamicTypeSize.xxxLarge, .accessibility2] {
                for chapter in Campaign.chapters {
                    let view = card(chapter).environment(\.dynamicTypeSize, size)
                    let fitted = fittingSize(view, width: width)
                    #expect(fitted.width <= width + 0.5, "chapter \(chapter.numeral) at \(size) in \(width) pt: \(fitted.width)")
                }
            }
        }
    }

    @Test("a card with ten levels, more than the campaign has today, still fits")
    func futureCounts() throws {
        let chapter = try #require(Campaign.chapter(number: 3))
        let extra = (8...10).map { index in
            LevelDefinition(chapter: 3, index: index, title: "futur \(index)", principle: "", lueurs: chapter.levels[0].lueurs, par: chapter.levels[0].par)
        }
        let longer = chapter.appending(extra[0]).appending(extra[1]).appending(extra[2])
        #expect(longer.levels.count == 10)
        for width in Self.cardWidths {
            let size = fittingSize(card(longer), width: width)
            #expect(size.width <= width + 0.5, "ten levels in \(width) pt: \(size.width)")
        }
    }

    @Test("control images of the chapter list on each phone width (written only when IRIS_SNAPSHOT_DIR is set)")
    func controlImages() throws {
        let directory = ProcessInfo.processInfo.environment["IRIS_SNAPSHOT_DIR"]
        let phones: [(name: String, width: CGFloat)] = [("375", 375), ("393", 393), ("402", 402), ("440", 440)]
        for phone in phones {
            for (part, range) in [("I-VI", 0..<6), ("VII-XII", 6..<12)] {
                for (label, size) in [("standard", DynamicTypeSize.large), ("large-text", DynamicTypeSize.xxxLarge)] {
                    let column = VStack(alignment: .leading, spacing: DSSpacing.l) {
                        ForEach(Array(Campaign.chapters[range])) { chapter in
                            card(chapter)
                        }
                    }
                    .padding(.horizontal, DSSpacing.gutter)
                    .padding(.vertical, DSSpacing.l)
                    .background(DSColor.fieldInk)
                    .environment(\.dynamicTypeSize, size)
                    .preferredColorScheme(.dark)
                    let renderer = ImageRenderer(content: column)
                    renderer.proposedSize = ProposedViewSize(width: phone.width, height: nil)
                    renderer.scale = 2
                    let image = try #require(renderer.uiImage)
                    #expect(image.size.width <= phone.width + 0.5, "\(part) on \(phone.name) pt with \(label) text renders \(image.size.width) pt wide")
                    if let directory, let data = image.pngData() {
                        let url = URL(fileURLWithPath: directory).appendingPathComponent("cards-\(phone.name)-\(part)-\(label).png")
                        try data.write(to: url)
                    }
                }
            }
        }
    }
}
