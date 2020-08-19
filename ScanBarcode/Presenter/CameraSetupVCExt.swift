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
            previewView = UIView(frame: self.view.frame)
            self.view.addSubview(previewView)
            previewView.layer.addSublayer(previewLayer)
        }
    //////////////////////////////////////////////////////////////////////////////////////
    ///
//    ////////////////////////////// SETTING PREVIEW FOR VISION API ////////////////////////////////////////
//        func setLivePreviewV2() {
////            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            previewLayer.videoGravity = .resizeAspectFill
//            previewLayer.connection?.videoOrientation = .portrait
//    //        let previewView = UIView(frame: self.view.frame)
//            previewLayer.frame = view.frame
//    //        self.view.addSubview(previewView)
//            self.view.layer.insertSublayer(previewLayer, at: 0)
//    //        previewView.layer.addSublayer(previewLayer)
//        }
//    //////////////////////////////////////////////////////////////////////////////////////

    
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
        
    
    ////////////////////////// STOPING CAMERA ////////////////////////////////////////////
        func stopCamera() {
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                self?.captureSession.stopRunning()
            }
        }
    /////////////////////////////////////////////////////////////////////////////////////

    

    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
//    func scanOnlyRectArea() {
//        
//        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
//        self.drawRectangle(rectangle: rect)
//        
////        self.previewLayer.contentsRect = rect
////        let rectForMetadata = self.previewLayer.metadataOutputRectConverted(fromLayerRect: rect)
////        self.metadataOutput.rectOfInterest = rectForMetadata
//    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////
        
}
