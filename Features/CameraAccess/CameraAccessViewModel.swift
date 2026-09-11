// CameraAccessViewModel.swift
// Layer: Presentation
// Purpose: Camera permission flow: explanation, request, denied and restricted states

import Foundation
import Observation

@MainActor
@Observable
final class CameraAccessViewModel {
    enum Phase: Hashable, Sendable {
        case explain
        case requesting
        case denied
        case restricted
    }

    private(set) var phase: Phase

    private let authorization: any CameraAuthorizationService
    private weak var navigator: (any CameraAccessNavigating)?

    init(authorization: any CameraAuthorizationService, navigator: any CameraAccessNavigating) {
        self.authorization = authorization
        self.navigator = navigator
        self.phase = Self.phase(for: authorization.currentStatus())
    }

    /// Re-reads the status, for instance after the player comes back from Settings.
    func refresh() {
        let status = authorization.currentStatus()
        if status == .authorized {
            navigator?.cameraAccessGranted()
        } else {
            phase = Self.phase(for: status)
        }
    }

    func requestAccess() async {
        phase = .requesting
        let status = await authorization.requestAccess()
        if status == .authorized {
            navigator?.cameraAccessGranted()
        } else {
            phase = Self.phase(for: status)
        }
    }

    func abandon() {
        navigator?.cameraAccessAbandoned()
    }

    private static func phase(for status: CameraAuthorizationStatus) -> Phase {
        switch status {
        case .notDetermined, .authorized: .explain
        case .denied: .denied
        case .restricted: .restricted
        }
    }
}
