//
//  CameraVC.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private var deviceOrientationHelper = DeviceOrientationHelper()
    
    let imagePicker = UIImagePickerController()
    
    var imageOrientation: AVCaptureVideoOrientation?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var isTest = 0
    var accessToken = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // picker controller
        imagePicker.delegate = self
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        // handler chiamato quando viene cambiato orientamento
        self.imageOrientation = AVCaptureVideoOrientation.portrait
        deviceOrientationHelper.startDeviceOrientationNotifier { (deviceOrientation) in
            self.orientationChanged(deviceOrientation: deviceOrientation)
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            captureSession?.sessionPreset = .high
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)

            //start video capture
            captureSession?.startRunning()
            
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.isTest = appDelegate.isTest
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTapFlash(_ sender: Any) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashButton.setImage(UIImage(named: "flash"), for: .normal)
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    flashButton.setImage(UIImage(named: "flash"), for: .normal)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    @IBAction func onTapTakePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.hasFlash {
            photoSettings.flashMode = .auto
        } else {
            photoSettings.flashMode = .off
        }
        
        if let photoOutputConnection = capturePhotoOutput.connection(with: AVMediaType.video) {
            photoOutputConnection.videoOrientation = self.imageOrientation ?? AVCaptureVideoOrientation.portrait
        }
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    func orientationChanged(deviceOrientation: UIDeviceOrientation) {
        //https://medium.com/elevate-by-lateral-view/developing-camille-how-to-determine-device-orientation-in-a-camera-app-4c622d251993
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        if deviceOrientation == .portrait {
            print("Device: Portrait")
            self.imageOrientation = AVCaptureVideoOrientation.portrait
            UIView.animate(withDuration: 0.2, animations: ({
                self.settingsButton.transform = .identity
                self.flashButton.transform = .identity
                self.galleryButton.transform = .identity
            }))
        }else if (deviceOrientation == .landscapeLeft){
            print("Device: LandscapeLeft")
            self.imageOrientation = AVCaptureVideoOrientation.landscapeLeft
            UIView.animate(withDuration: 0.2, animations: ({
                self.settingsButton.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
                self.flashButton.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
                self.galleryButton.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
            }))
        }else if (deviceOrientation == .landscapeRight){
            print("Device LandscapeRight")
            self.imageOrientation = AVCaptureVideoOrientation.landscapeRight
            UIView.animate(withDuration: 0.2, animations: ({
                self.settingsButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
                self.flashButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
                self.galleryButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }))
        }else if (deviceOrientation == .portraitUpsideDown){
            print("Device PortraitUpsideDown")
            self.imageOrientation = AVCaptureVideoOrientation.portraitUpsideDown
            UIView.animate(withDuration: 0.2, animations: ({
                self.settingsButton.transform = CGAffineTransform(rotationAngle: .pi)
                self.flashButton.transform = CGAffineTransform(rotationAngle: .pi)
                self.galleryButton.transform = CGAffineTransform(rotationAngle: .pi)
            }))
        }else{
            self.imageOrientation = AVCaptureVideoOrientation.portrait
        }
        
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            // vado al VC con l'editor dell'immagine
            performSegue(withIdentifier: "toImageEditor", sender: image)
        }
    }
    
    //Azione performata quando viene effettuato il segue tra i view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showOggetto":
            
            guard let request = sender as? OggettoRequest else { return }
            
            let oggettoVC = segue.destination as! OggettoVC
            oggettoVC.objectType = request.objectType
            oggettoVC.accessToken = request.token
            oggettoVC.qrCode = request.qrCode
            
        default:
            break
        }
        
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        print("torno indietro dal ViewController ImageEditor")
    }
    
    
    @IBAction func onTapGallery(_ sender: Any) {
        // Choose Image Here
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true, completion: { () -> Void in
                // vado al VC con l'editor dell'immagine
                self.performSegue(withIdentifier: "toImageEditor", sender: pickedImage)
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Classe per l'oggetto della richiesta per aprire la foto del profilo in HD
    class OggettoRequest {
        var token: String = ""
        var qrCode: String = ""
        var objectType: String = ""
    }
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            //qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.isHidden = true
            return
        }
        
        self.captureSession?.stopRunning()
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            print(metadataObj.stringValue)
            
            var source: RequestProtocol
            if (self.isTest == 0) {
                source = Requests()
            } else {
                source = TestMockup()
            }
            
            if let code = metadataObj.stringValue {
                let objNetworkManager = NetworkManager(shared: source)
                objNetworkManager.shared.genericObjectApi(token: self.accessToken, qRCode: code) { (objTypeResponse) in
                    
                    if objTypeResponse == nil { return }
                    DispatchQueue.main.async {
                        let request = OggettoRequest()
                        request.token = self.accessToken
                        request.qrCode = code
                        request.objectType = objTypeResponse!.description
                        self.performSegue(withIdentifier: "showOggetto", sender: request)
                    }
                    
                }
    
            }
    
        }
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        
        // vado al TVC con i settings
        performSegue(withIdentifier: "showSettings", sender: nil)
        
    }
    
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}
