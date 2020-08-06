//
//  ViewController.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 4/12/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseMLVision

class ViewController: UIViewController {

    // BLOCKING ROTATION
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // TABLE VIEW
    let tableView = UITableView()
    let tableViewSingleScanModeHeight = 400
    let tableViewFullScreenScanModeHeight = 15
    
    // BUTTONS
    let buttonsHeight = 50
    let counterButtonWidth = 50
    let sendButton = UIButton(type: .roundedRect) // TO SEND BARCODES TO SERVER
    let counterButton = UIButton(type: .custom) //round button to show number of barcodes scanned
    let startStopButton = UIButton(type: .roundedRect) // to startStopScanning
    
    // CAMERA
    lazy var captureSession = AVCaptureSession()
    lazy var previewLayer = AVCaptureVideoPreviewLayer()
    lazy var metadataOutput = AVCaptureMetadataOutput()
    lazy var previewView = UIView()
    
    // DETECTORS
    let vnBarcodeDetector = VNBarcodeDetector()
    let mlBarcodeDetector = MLBarcodeDetector()
    var isScanning = Bool() // flag to let user scan only when button "Scan" is being held
    
    // BARCODES
    var MLBarcodes = [Int: BarcodeData]()
    var VNBarcodes = [Int: BarcodeData]() // TO BE ABLE TO COMPARE RESULTS OF DETECTION
//    var barcodeNumbers = [Int]()
    var barcodeNumbersWithRating = [Int: Int]()
    
    // ANNOTATIONS
    let annotationRectangleHeight = 15
    let borderWidth = 2.0
    let subviewDeletionTag = 100
    
//    // TEXT RECOGNITION
//    var textRecognizer: VisionTextRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .red ////////////////////// DEBUG
        self.configureTableView()
        self.vnBarcodeDetector.barcodeDetectorDelegate = self
        self.mlBarcodeDetector.barcodeDetectorDelegate = self
        
//        // TEXT RECOGNIZER SETUP
//        let vision = Vision.vision()
//        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //TEMPORARY
        self.setCaptureSessionForMLKit()
        self.setLivePreview()
        self.startCamera()
//        self.scanOnlyRectArea()
//        self.setupSingleBarcodeDetectionModeView()
        self.setupFullScreenDetectionModeView()
    }
}
