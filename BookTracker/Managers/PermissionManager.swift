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
    
    /// Checks for video authorization and tries to request it if there is none.
    ///
    /// - Returns: A Bool representing if there is video authorization or not.
    static func checkForVideoPermission() async -> Bool {
        guard !videoPermissionGranted() else { return true }
        // Request permission.
        return await AVCaptureDevice.requestAccess(for: .video)
    }
}
