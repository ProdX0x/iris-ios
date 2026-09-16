// DeviceCapabilityReportTests.swift
// Layer: Tests
// Purpose: Reads what ARKit really exposes on the running device and prints it as one greppable block, so that two
// iPhones can be compared with measurements instead of with published specifications. It reads only: nothing in the
// Gaze Engine, the calibration or the physics is touched, and no ARSession is started

import ARKit
import Foundation
import Testing
@testable import Iris

@Suite("Device capability report")
struct DeviceCapabilityReportTests {
    /// Marker the capture scripts grep for.
    private static let marker = "IRIS-ARKIT"

    /// "iPhone15,2" for an iPhone 14 Pro, "iPhone16,1" for an iPhone 15 Pro.
    private var hardwareModel: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        guard size > 0 else { return "(unknown)" }
        var buffer = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &buffer, &size, nil, 0)
        return String(decoding: buffer.prefix { $0 != 0 }.map { UInt8(bitPattern: $0) }, as: UTF8.self)
    }

    private var systemVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }

    @Test("what ARKit face tracking exposes on the running device")
    func faceTrackingCapabilities() {
        let isSupported = ARFaceTrackingConfiguration.isSupported
        var lines: [String] = [
            "device.model=\(hardwareModel) device.ios=\(systemVersion)",
            "faceTracking.isSupported=\(isSupported)",
            "faceTracking.supportedNumberOfTrackedFaces=\(ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces)",
        ]
        let formats = ARFaceTrackingConfiguration.supportedVideoFormats
        lines.append("faceTracking.formatCount=\(formats.count)")
        for (index, format) in formats.enumerated() {
            var fields = [
                "resolution=\(Int(format.imageResolution.width))x\(Int(format.imageResolution.height))",
                "fps=\(format.framesPerSecond)",
                "capturePosition=\(format.captureDevicePosition.rawValue)",
                "captureDeviceType=\(format.captureDeviceType.rawValue)",
            ]
            if #available(iOS 16.0, *) {
                fields.append("hdr=\(format.isVideoHDRSupported)")
                fields.append("highResCapture=\(format.isRecommendedForHighResolutionFrameCapturing)")
            }
            lines.append("format[\(index)] " + fields.joined(separator: " "))
        }
        for line in lines {
            print("\(Self.marker) \(line)")
        }

        // The one thing worth asserting: what Iris believes about the device is what ARKit says.
        #expect(ARKitDeviceCapabilities().supportsFaceTracking == isSupported)
        #if !targetEnvironment(simulator)
        #expect(isSupported, "a TrueDepth device must report face tracking support")
        #expect(!formats.isEmpty, "a supporting device must expose at least one video format")
        #endif
    }
}
