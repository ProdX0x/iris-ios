// CameraAccessViewModelTests.swift
// Layer: Tests
// Purpose: Camera permission phases and navigation

import Foundation
import Testing
@testable import Iris

@Suite("CameraAccessViewModel")
@MainActor
struct CameraAccessViewModelTests {
    private let navigator = MockNavigator()

    @Test("initial phase mirrors the authorization status")
    func initialPhases() {
        #expect(CameraAccessViewModel(authorization: StubCameraAuthorizationService(status: .notDetermined), navigator: navigator).phase == .explain)
        #expect(CameraAccessViewModel(authorization: StubCameraAuthorizationService(status: .denied), navigator: navigator).phase == .denied)
        #expect(CameraAccessViewModel(authorization: StubCameraAuthorizationService(status: .restricted), navigator: navigator).phase == .restricted)
    }

    @Test("granting access navigates forward")
    func granted() async {
        let sut = CameraAccessViewModel(authorization: StubCameraAuthorizationService(status: .notDetermined, statusAfterRequest: .authorized), navigator: navigator)

        await sut.requestAccess()

        #expect(navigator.cameraGrantedCount == 1)
    }

    @Test("denying access shows the denied state")
    func denied() async {
        let sut = CameraAccessViewModel(authorization: StubCameraAuthorizationService(status: .notDetermined, statusAfterRequest: .denied), navigator: navigator)

        await sut.requestAccess()

        #expect(sut.phase == .denied)
        #expect(navigator.cameraGrantedCount == 0)
    }

    @Test("refresh after returning from Settings navigates when now authorized")
    func refresh() {
        let authorization = StubCameraAuthorizationService(status: .authorized)
        let sut = CameraAccessViewModel(authorization: authorization, navigator: navigator)

        sut.refresh()

        #expect(navigator.cameraGrantedCount == 1)
    }

    @Test("abandon returns to the navigator")
    func abandon() {
        let sut = CameraAccessViewModel(authorization: StubCameraAuthorizationService(status: .denied), navigator: navigator)

        sut.abandon()

        #expect(navigator.cameraAbandonedCount == 1)
    }
}
