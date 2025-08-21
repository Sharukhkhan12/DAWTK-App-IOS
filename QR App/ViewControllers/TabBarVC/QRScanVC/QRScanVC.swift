//
//  QRScanVC.swift
//  QR App
//
//  Created by Touheed khan on 28/07/2025.
//

import UIKit
import AVFoundation
import PhotosUI
import CoreImage

class QRScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var flashLightImage: UIImageView!
    @IBOutlet weak var preView: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var metadataOutput: AVCaptureMetadataOutput!
    
    /// This layer will visually show the scan area
    var scanBoxLayer: CAShapeLayer!
    var overlayLayer: CAShapeLayer!
    var progressAlertv = ProgressAlertView()
    /// Flashlight toggle flag
    var isFlashOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashLightImage.image = UIImage(systemName: "flashlight.off.fill") // Torch OFF
        captureSession = AVCaptureSession()
        
        // Setup the camera input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        // Setup metadata output
        metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        // Setup preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = preView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        preView.layer.addSublayer(previewLayer)
        
        // Draw the rectangle (center scan area)
        drawCenterRectangle()
        
        // Set scanning area
        setRectOfInterest()
        
        // Start scanning
        captureSession.startRunning()
    }
    
    // MARK: - Open gallery
    @IBAction func didTapGalleryOpen(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // MARK: - Flashlight Toggle
    @IBAction func didTapFlashlight(_ sender: Any) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            if isFlashOn {
                device.torchMode = .off
                flashLightImage.image = UIImage(systemName: "flashlight.off.fill") // Torch OFF
            } else {
                try device.setTorchModeOn(level: 1.0)
                flashLightImage.image = UIImage(systemName: "flashlight.on.fill") // Torch ON
            }
            device.unlockForConfiguration()
            isFlashOn.toggle()
        } catch {
            print("Torch could not be used")
        }
    }

    
    // MARK: - Image Picker Delegate (Detect QR in picked image)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        
        if let qrValue = detectQRCode(from: pickedImage) {
            showAlert(message: qrValue)
        } else {
            showAlert(message: "No QR code found in the image.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    /// Detect QR Code from UIImage using CIDetector
    func detectQRCode(from image: UIImage) -> String? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        if let features = detector?.features(in: ciImage) as? [CIQRCodeFeature],
           let firstFeature = features.first {
            return firstFeature.messageString
        }
        
        return nil
    }
    
    // MARK: - Draw Scan Box
    func drawCenterRectangle() {
        let width: CGFloat = preView.frame.width * 0.6
        let height: CGFloat = width
        let originX = (preView.frame.width - width) / 2
        let originY = (preView.frame.height - height) / 2
        
        let scanRect = CGRect(x: originX, y: originY, width: width, height: height)
        
        // Rounded rectangle path
        let cornerRadius: CGFloat = 20
        let path = UIBezierPath(roundedRect: scanRect, cornerRadius: cornerRadius)
        
        // Draw overlay (dark background outside the scan box)
        let fullPath = UIBezierPath(rect: preView.bounds)
        fullPath.append(path)
        fullPath.usesEvenOddFillRule = true
        
        overlayLayer = CAShapeLayer()
        overlayLayer.path = fullPath.cgPath
        overlayLayer.fillRule = .evenOdd
        overlayLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        preView.layer.addSublayer(overlayLayer)
        
        // Draw the scan box border
        scanBoxLayer = CAShapeLayer()
        scanBoxLayer.path = path.cgPath
        scanBoxLayer.strokeColor = UIColor.white.cgColor
        scanBoxLayer.lineWidth = 3
        scanBoxLayer.fillColor = UIColor.clear.cgColor
        
        preView.layer.addSublayer(scanBoxLayer)
    }
    
    // MARK: - Restrict scanning area
    func setRectOfInterest() {
        let width: CGFloat = preView.frame.width * 0.6
        let height: CGFloat = width
        let originX = (preView.frame.width - width) / 2
        let originY = (preView.frame.height - height) / 2
        
        let scanRect = CGRect(x: originX, y: originY, width: width, height: height)
        
        let normalizedRect = previewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
        metadataOutput.rectOfInterest = normalizedRect
    }
    
    // MARK: - QR detection callback
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let qrValue = metadataObject.stringValue {
            
            print("QR Code: \(qrValue)")
            captureSession.stopRunning()
            self.progressAlertv.show()
            FirebaseManager.shared.fetchCard(cardKey: qrValue) { result in
                switch result {
                case .success(let model):
                    if let invitationCard = model as? InvitationModel {
                        print("🎉 Found Invitation Card: \(invitationCard)")
                        self.navigateToPreVieeScreen(invitationCard: invitationCard)
                    } else if let businessCard = model as? UserBusinessCardModel {
                        print(" ✅ Business Card fetched:", businessCard)
                        self.dismiss(animated: true) {
                            self.navigateToViewCardScreen(card: businessCard)
                        }
                        print("🎉 Found Business Card: \(businessCard)")
                    }
                case .failure(let error):
                    self.progressAlertv.dismiss()
                    self.showAlert(message: "Invalid QR") {
                        self.captureSession.startRunning()
                    }
                    print("❌ Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: - Navigate to View Card Screen
    private func navigateToViewCardScreen(card: UserBusinessCardModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewAsVC = storyboard.instantiateViewController(withIdentifier: "ViewAsVC") as? ViewAsVC {
            print()
            viewAsVC.cardInfo = card
            viewAsVC.checkUSerScanVC = true
            viewAsVC.modalTransitionStyle = .crossDissolve
            viewAsVC.modalPresentationStyle = .fullScreen
            present(viewAsVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate TO Invitation PreViee Controller
    
    private func navigateToPreVieeScreen(invitationCard: InvitationModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationPreViewVC = storyboard.instantiateViewController(withIdentifier: "InvitationPreViewVC") as? InvitationPreViewVC {
            invitationPreViewVC.modalTransitionStyle = .crossDissolve
            invitationPreViewVC.userCard = invitationCard
            invitationPreViewVC.checkUSerScanVC = true
            
            invitationPreViewVC.modalPresentationStyle = .fullScreen
            present(invitationPreViewVC, animated: true)
        }
    }
    
    
    // MARK: - Alert helper
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "QR Result", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

