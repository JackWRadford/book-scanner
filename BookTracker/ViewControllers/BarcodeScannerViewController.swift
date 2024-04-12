//
//  BarcodeScannerViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 11/04/2024.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scan ISBN Barcode"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dismissViewController)
        )
        
        createCaptureSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCaptureSession()
    }
    
    // MARK: - Functions
    
    private func startCaptureSession() {
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    private func stopCaptureSession() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    private func createCaptureSession() {
        captureSession = AVCaptureSession()
        addVideoInput(to: captureSession)
        addMetadataOutput(to: captureSession)
        configureCameraPreviewLayer()
    }
    
    private func addMetadataOutput(to captureSession: AVCaptureSession) {
        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .code128] // ISBN barcodes should be covered by these types.
        } else {
            failedToScan()
            return
        }
    }
    
    private func addVideoInput(to captureSession: AVCaptureSession) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failedToScan()
            return
        }
    }
    
    private func failedToScan() {
        presentBTAlertOnMainThread(
            title: "Scanning not supported",
            message: "Barcode scanning not supported. Please use a device with a camera.",
            actionLabel: "Okay"
        )
        captureSession = nil
    }

    private func found(code: String) {
        print("ISBN: \(code)")
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    // MARK: - Configuration
    
    private func configureCameraPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(
            x: 0,
            y: navigationController?.navigationBar.frame.height ?? 0,
            width: view.layer.bounds.width,
            height: view.layer.bounds.height - (navigationController?.navigationBar.frame.height ?? 0)
        )
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    override var prefersStatusBarHidden: Bool { return true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopCaptureSession()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismissViewController()
    }
    
}
