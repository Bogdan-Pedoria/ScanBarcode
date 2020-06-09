//
//  BarcodeMLKitExtension.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/1/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// EXTENSION TO START THE CAMERA ///////////////////////////
/////////////////////////// AND BARCODE SCANNER WITH ///////////////////////////////
/////////////////////////// PICTURE SETTINGS FOR MLKit //////////////////////////////

extension ViewController {

////////////////////////// SETTING CAMERA FOR MLKit ////////////////////////////////
    /*
        METHOD setMLKitCaptureSession to make frames suitable for MLKit
     */
   func setCaptureSessionForMLKit() {
    captureSession.sessionPreset = .hd1920x1080
//    captureSession.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                //TODO: HANDLE NO CAMERA PRESENT ON DEVICE CASE
                print("Unable to access back camera")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: (Int(kCVPixelFormatType_32BGRA))]
            output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .default))
            if captureSession.canAddInput(input) && captureSession.canAddOutput(output) {
                captureSession.addInput(input)
                captureSession.addOutput(output)
            }
        }
        catch let error {
            print("Error unable to initialize back camera: \(error.localizedDescription)")
            return
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

