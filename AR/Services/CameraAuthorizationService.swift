// CameraAuthorizationService.swift
// Layer: AR
// Purpose: Camera permission status and request, abstracted from AVFoundation

import Foundation
import AVFoundation

enum CameraAuthorizationStatus: Hashable, Sendable {
    case notDetermined
    case authorized
    case denied
    case restricted
}

protocol CameraAuthorizationService: Sendable {
    func currentStatus() -> CameraAuthorizationStatus
    func requestAccess() async -> CameraAuthorizationStatus
}

struct AVCaptureCameraAuthorizationService: CameraAuthorizationService {
    init() {}

    func currentStatus() -> CameraAuthorizationStatus {
        Self.map(AVCaptureDevice.authorizationStatus(for: .video))
    }

    func requestAccess() async -> CameraAuthorizationStatus {
        _ = await AVCaptureDevice.requestAccess(for: .video)
        return currentStatus()
    }

    private static func map(_ status: AVAuthorizationStatus) -> CameraAuthorizationStatus {
        switch status {
        case .authorized: .authorized
        case .denied: .denied
        case .restricted: .restricted
        case .notDetermined: .notDetermined
        @unknown default: .denied
        }
    }
}

/// Deterministic authorization used by previews and tests.
final class StubCameraAuthorizationService: CameraAuthorizationService, @unchecked Sendable {
    private let lock = NSLock()
    private var status: CameraAuthorizationStatus
    private let statusAfterRequest: CameraAuthorizationStatus

    init(status: CameraAuthorizationStatus, statusAfterRequest: CameraAuthorizationStatus = .authorized) {
        self.status = status
        self.statusAfterRequest = statusAfterRequest
    }

    func currentStatus() -> CameraAuthorizationStatus {
        lock.withLock { status }
    }

    func requestAccess() async -> CameraAuthorizationStatus {
        lock.withLock {
            status = statusAfterRequest
            return status
        }
    }
}
