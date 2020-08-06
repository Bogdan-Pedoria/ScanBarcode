////
////  VNCameraSetup.swift
////  ScanBarcode
////
////  Created by Bohdan Pedoria on 6/1/20.
////  Copyright © 2020 Bohdan Pedoria. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//import UIKit
//
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// EXTENSION TO START THE CAMERA ///////////////////////////
///////////////////////////// AND BARCODE SCANNER WITH ///////////////////////////////
///////////////////////////// PICTURE SETTINGS FOR MLKit //////////////////////////////
//
//extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//////////////////////////// SETTING CAMERA FOR MLKit ////////////////////////////////
//    /*
//        METHOD setMLKitCaptureSession to make frames suitable for MLKit
//     */
//   func setVNCaptureSession() {
//        captureSession.sessionPreset = .hd1280x720
//        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
//    
//        var camera = AVCaptureDevice.default(for: .video)
//    
//        // SELECTING BACKCAMERA
//        for device in session.devices {
//            if device.position == AVCaptureDevice.Position.back {
//                camera = device
//            }
//        }
//    
//        // UNWRAPING BACKCAMERA
//        guard let backCamera = camera else {
//            return
//        }
//    
//        //
//        do {
//            let input = try AVCaptureDeviceInput(device: backCamera)
//            let videoOutput = AVCaptureVideoDataOutput()
//            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: (Int(kCVPixelFormatType_32BGRA))]
//            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .default))
//            if captureSession.canAddInput(input) && captureSession.canAddOutput(videoOutput) {
//                captureSession.addInput(input)
//                captureSession.addOutput(videoOutput)
//            }
//        }
//        catch let error {
//            print("Error unable to initialize back camera: \(error.localizedDescription)")
//            return
//        }
//    }
//}
//
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
//
