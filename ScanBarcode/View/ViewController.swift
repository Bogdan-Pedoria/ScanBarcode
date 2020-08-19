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
    
    
//DEBUG VAR
var unknownTypeCount = Int()

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
    let sendButtonWidth = 100
    let scanButtonWidth = UIScreen.main.bounds.width - 100 - 50 // 100 - sendButtonWidth, 50 - counterButtonWidth
    let sendButton = UIButton(type: .roundedRect) // TO SEND BARCODES TO SERVER
    let counterButton = UIButton(type: .custom) //round button to show number of barcodes scanned
    let scanBtn = UIButton(type: .roundedRect) // to startStopScanning
    let changeModeButton = UIButton(type: .custom)
    
    // CAMERA
    lazy var captureSession = AVCaptureSession()
    lazy var previewLayer = AVCaptureVideoPreviewLayer()
    lazy var metadataOutput = AVCaptureMetadataOutput()
    lazy var previewView = UIView()
    let cameraResolution = CGSize(width: 1080, height: 1920)
    
    //SCANNER VARS
    let singleScanModeCroppingRect = CGRect(x: UIScreen.main.bounds.origin.x + 80, y: UIScreen.main.bounds.origin.y + 120, width: UIScreen.main.bounds.width - 160, height: CGFloat(400) - 240)
//    no cropping rectangle
//    let singleScanModeCroppingRect = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: CGFloat(400))
    var singleScanMode = Bool()
    let borderRectangle = BorderRectangle()
    
    // DETECTORS
    let vnBarcodeDetector = VNBarcodeDetector()
    let mlBarcodeDetector = MLBarcodeDetector()
    var isScanning = Bool() // flag to let user scan only when button "Scan" is being held
//    var areBarcodesSent = Bool()
    
    // BARCODES
    var MLBarcodes = [Int: BarcodeData]()
    var VNBarcodes = [Int: BarcodeData]() // TO BE ABLE TO COMPARE RESULTS OF DETECTION
//    var barcodeNumbers = [Int]()
    var barcodeNumbersWithRating = [Int: Int]()
    var halfPrecisionFilteredBarcodes = [Int: Int]()
    var tenPercentPrecisionFilteredBarcodes = [Int: Int]()
    //to check duplicates on single frame for MultiBarcodeScanMode
    var originsOfOneFrame = [Int: Point]() //you have to update it every frame
    
    // ANNOTATIONS
    let annotationRectangleHeight = 15
    let borderWidth = 2.0
    let subviewDeletionTag = 100
    var rectanglesForBarcodes = [Int: Int]() //barcodeNo with rectangleLayers hash values, to be able to remove
    var priceLabelsForBarcodes = [Int: Int]()
    
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
        self.setupSingleBarcodeDetectionModeView()
//        self.setupFullScreenDetectionModeView()
        self.setupChangeModeButton()
        
        // TIMER TO CLEAR UP THE OBSOLETE RECTANGLES.
        // TODO: BETTER TO REMOVE RECTANGLES
        // BY SAVING RECTANGES WITH DATE
        // CHECKING HOW OLD THEY ARE AND REMOVING THEM IF HALF
        // SECOND OLD (IT IS ALL IN ADDITION OF HOW I REMOVE
        // THEM BY BarcdeNo(hashValue))
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.removeAllDrawings), userInfo: nil, repeats: true)
    }
}
