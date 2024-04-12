//
//  PermissionManager.swift
//  BookTracker
//
//  Created by Jack Radford on 12/04/2024.
//

import AVFoundation

struct PermissionManager {
    
    private static func videoPermissionGranted() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    static func checkForVideoPermission() async -> Bool {
        guard !videoPermissionGranted() else { return true }
        // Request permission
        return await AVCaptureDevice.requestAccess(for: .video)
    }
}
