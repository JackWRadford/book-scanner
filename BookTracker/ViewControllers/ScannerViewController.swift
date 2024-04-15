//
//  ScannerViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 11/04/2024.
//

import AVFoundation
import UIKit

class ScannerViewController: BTDataLoadingViewController {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        createAndStartCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCaptureSession()
    }
    
    // MARK: - Functions
    
    private func startCaptureSession() {
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                self.captureSession.startRunning()
            }
        }
    }
    
    private func stopCaptureSession() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    private func createAndStartCaptureSession() {
        do {
            captureSession = AVCaptureSession()
            try addVideoInput(to: captureSession)
            try addMetadataOutput(to: captureSession)
            configureCameraPreviewLayer()
            startCaptureSession()
        } catch {
            failedToScan(with: error)
        }
    }
    
    private func addVideoInput(to captureSession: AVCaptureSession) throws {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                throw BTError.scanningNotSupported
            }
        } catch {
            throw error
        }
    }
    
    private func addMetadataOutput(to captureSession: AVCaptureSession) throws {
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .code128] // ISBN barcodes should be covered by these types.
        } else {
            throw  BTError.scanningNotSupported
        }
    }
    
    /// Presents an alert and resets the capture session.
    ///
    /// - Parameter error: The Error thrown to cause the alert to be required.
    private func failedToScan(with error: Error) {
        presentBTAlertOnMainThread(for: error)
        captureSession = nil
    }
    
    
    /// Fetch the book and try to persist it.
    ///
    /// - Parameter isbn: The ISBN for the scanned book.
    private func found(isbn: String) {
        showLoadingView()
        Task {
            do {
                let book = try await NetworkManager.shared.getBook(forISBN: isbn)
                dismissLoadingView()
                if let book {
                    // Persist the found book
                    try PersistenceManager.update(book: book, actionType: .add)
                    dismissViewController()
                } else {
                    presentBTAlertOnMainThread(
                        title: "No Books Found",
                        message: "Sorry we could not find any books with that ISBN.",
                        action: startCaptureSession
                    )
                }
            } catch {
                presentBTAlertOnMainThread(for: error, action: startCaptureSession)
            }
        }
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    // MARK: - Configuration
    
    private func configureViewController() {
        title = "Scan ISBN Barcode"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dismissViewController)
        )
    }
    
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
    
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopCaptureSession()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            found(isbn: stringValue)
        }
    }
    
}
