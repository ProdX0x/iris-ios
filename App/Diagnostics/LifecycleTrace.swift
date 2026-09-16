// LifecycleTrace.swift
// Layer: App (DEBUG instrumentation)
// Purpose: Records the system events a brief visual glitch could be correlated with — scene lifecycle, memory
// warnings, thermal changes — with a timestamp, into the app's own container. It observes only: it registers
// notifications, draws nothing, schedules nothing, and changes no behaviour. Release contains none of it.

#if DEBUG
import Foundation
import os
import UIKit

@MainActor
final class LifecycleTrace {
    static let shared = LifecycleTrace()
    /// Marker the capture scripts grep for.
    static let marker = "IRIS-LIFECYCLE"
    /// File appended to inside Documents, pullable with `devicectl device copy from`.
    static let fileName = "iris-lifecycle.log"

    private var hasStarted = false

    private init() {}

    /// Idempotent: calling it again never registers a second set of observers.
    func start() {
        guard !hasStarted else { return }
        hasStarted = true
        let centre = NotificationCenter.default
        let events: [(Notification.Name, String)] = [
            (UIApplication.didBecomeActiveNotification, "didBecomeActive"),
            (UIApplication.willResignActiveNotification, "willResignActive"),
            (UIApplication.didEnterBackgroundNotification, "didEnterBackground"),
            (UIApplication.willEnterForegroundNotification, "willEnterForeground"),
            (UIApplication.didReceiveMemoryWarningNotification, "memoryWarning"),
            (UIApplication.significantTimeChangeNotification, "significantTimeChange"),
            (ProcessInfo.thermalStateDidChangeNotification, "thermalStateChanged"),
            (UIAccessibility.reduceMotionStatusDidChangeNotification, "reduceMotionChanged"),
            (UIAccessibility.reduceTransparencyStatusDidChangeNotification, "reduceTransparencyChanged"),
            (UIAccessibility.darkerSystemColorsStatusDidChangeNotification, "increaseContrastChanged"),
        ]
        for (name, label) in events {
            centre.addObserver(forName: name, object: nil, queue: .main) { _ in
                MainActor.assumeIsolated { Self.shared.record(label) }
            }
        }
        record("traceStarted")
    }

    /// One line: when, what, and the two pieces of context a glitch is worth correlating with.
    private func record(_ event: String) {
        let fields = [
            "event=\(event)",
            "thermal=\(Self.describe(ProcessInfo.processInfo.thermalState))",
            "availableMemoryMB=\(os_proc_available_memory() / 1_048_576)",
            "lowPowerMode=\(ProcessInfo.processInfo.isLowPowerModeEnabled)",
        ]
        let line = "\(Self.marker) " + fields.joined(separator: " ")
        print(line)
        append(line)
    }

    private static func describe(_ state: ProcessInfo.ThermalState) -> String {
        switch state {
        case .nominal: "nominal"
        case .fair: "fair"
        case .serious: "serious"
        case .critical: "critical"
        @unknown default: "unknown"
        }
    }

    /// Appends to the app's own Documents directory. Failure is silent: the printed line remains.
    private func append(_ line: String) {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = documents.appendingPathComponent(Self.fileName)
        let stamped = "\(ISO8601DateFormatter().string(from: Date())) \(line)\n"
        guard let data = stamped.data(using: .utf8) else { return }
        if let handle = try? FileHandle(forWritingTo: url) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        } else {
            try? data.write(to: url)
        }
    }
}
#endif
