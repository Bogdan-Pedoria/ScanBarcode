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

class ViewController: UIViewController {

    // TABLE VIEW
    let tableView = UITableView()
    let tableViewInitialHeight = 400
    let tableViewExpandHeight = 15
    
    // BUTTONS
    let buttonsHeight = 50
    let sendButton = UIButton(type: .roundedRect) // TO SEND BARCODES TO SERVER
    let counterButton = UIButton(type: .custom) //round button to show number of barcodes scanned
    
    // CAMERA
    let captureSession = AVCaptureSession()
    //    var backCamera: AVCaptureDevice?
//    let output = AVCaptureVideoDataOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
//    let stillImageOutput = AVCapturePhotoOutput()
    
    // DETECTORS
    let vnBarcodeDetector = VNBarcodeDetector()
    let mlBarcodeDetector = MLBarcodeDetector()
    var MLBarcodes = [Int: BarcodeData]()
    var VNBarcodes = [Int: BarcodeData]() // TO BE ABLE TO COMPARE RESULTS OF DETECTION


    enum cells: String {
        case barcodeCell = "barcodeCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .red ////////////////////// DEBUG
        self.configureTableView()
        self.vnBarcodeDetector.barcodeDetectorDelegate = self
        self.mlBarcodeDetector.barcodeDetectorDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TEMPORARY
        self.setCaptureSessionForMLKit()
        self.setLivePreview()
        self.startCamera()
        self.setupSingleBarcodeDetectionModeView()
        self.setupFullScreenDetectionModeView()
    }
    
}
