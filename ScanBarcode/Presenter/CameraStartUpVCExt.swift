//
//  Camera.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 4/12/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension ViewController {
        
    ////////////////////////////// SETTING PREVIEW ////////////////////////////////////////
        func setLivePreview() {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            let previewView = UIView(frame: self.view.frame)
            self.view.addSubview(previewView)
            previewView.layer.addSublayer(previewLayer)
        }
    //////////////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////// SETTING PREVIEW FOR VISION API ////////////////////////////////////////
        func setLivePreviewV2() {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
    //        let previewView = UIView(frame: self.view.frame)
            previewLayer.frame = view.frame
    //        self.view.addSubview(previewView)
            self.view.layer.insertSublayer(previewLayer, at: 0)
    //        previewView.layer.addSublayer(previewLayer)
        }
    //////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////// STARTING CAMERA ////////////////////////////////////////////
        func startCamera() {
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                self?.captureSession.startRunning()
                DispatchQueue.main.async {
                    self?.previewLayer.frame = self?.view.bounds as! CGRect
                }
            }
        }
    /////////////////////////////////////////////////////////////////////////////////////
        
    //////////////// CAPTURING PHOTO AND DETECTING BARCODE ////////////////////////////////
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let imageBuffer = sampleBuffer.imageBuffer else {
                return
            }
//            // DUBUG
////            print("sample = ", sampleBuffer)
//            let ciImage = CIImage(cvImageBuffer: imageBuffer)
//            let image = UIImage(ciImage: ciImage)
//            let jpgData = image.jpegData(compressionQuality: 0.9)
//            print("just jpg data = \(jpgData)")
//            // END DEBUG
            
            // DETECT BARCODE WITH MLKit
            // TODO: PUT ON ANOTHER THREAD
            mlBarcodeDetector.detectMLBarcode(sampleBuffer: sampleBuffer)
            
            // PROCESS IMAGE WITH Vision API
            let coreImage = CIImage(cvImageBuffer: imageBuffer)
            vnBarcodeDetector.detectVNBarcode(coreImage: coreImage)
             
            
        }
    //////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////// JUST A TRY FUNC TO SHOW HOW AN OBJECT CAN BE DRAWN /////////////
    func addPointlessCircle() {
        // ADD CIRCLE
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = 50.0
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: 200, y: 200)
//            circleLayer.fillColor = UIColor.blue.cgColor
        self.view.layer.insertSublayer(circleLayer, above: previewLayer)
    }
    ///////////////////////////////////////////////////////////////////////////////
        
}
