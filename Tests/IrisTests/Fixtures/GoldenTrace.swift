// GoldenTrace.swift
// Layer: Tests
// Purpose: Decodes the golden traces produced by the reference JavaScript engine (Fixtures/golden_generator.js)

import Foundation

struct GoldenTrace: Decodable {
    struct Canvas: Decodable {
        let width: Double
        let height: Double
    }

    struct Sample: Decodable {
        let x: Double
        let y: Double
        let vx: Double
        let vy: Double
        let hold: Int
        let settled: Bool
    }

    struct Event: Decodable {
        let frame: Int
        let type: String
        let seq: Int?
    }

    let levelIndex: Int
    let canvas: Canvas
    let frames: Int
    let trace: [[Sample]]
    let events: [Event]

    static func load(named name: String) throws -> GoldenTrace {
        let bundle = Bundle(for: GoldenTraceBundleLocator.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw GoldenTraceError.missing(name)
        }
        return try JSONDecoder().decode(GoldenTrace.self, from: Data(contentsOf: url))
    }
}

enum GoldenTraceError: Error {
    case missing(String)
}

final class GoldenTraceBundleLocator {}
