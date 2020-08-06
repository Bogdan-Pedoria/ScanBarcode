//
//  CaptureOutputDelegateVCExt.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/9/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



extension ViewController {
    
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("DID DROP FRAME")
    }
    
        //////////////// CAPTURING PHOTO AND DETECTING BARCODE ////////////////////////////////
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        guard let imageBuffer = sampleBuffer.imageBuffer else { return }
        guard isScanning else { return }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let image = convert(ciImage)
    
    print("Dimensions of buffer before modifications:\n width: \(CVPixelBufferGetWidth(ciImage.pixelBuffer!)); height: \(CVPixelBufferGetHeight(ciImage.pixelBuffer!))\n")
    
    /// DEBUG
//let jpgData = image!.jpegData(compressionQuality: 1.0)
//print("just jpg data = \(jpgData)")
//UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    /// END DEBUG
        
        // BARCODE DETECTION
        mlBarcodeDetector.detectMLBarcode(image: image!)
        
        // PROCESS IMAGE WITH Vision API
        vnBarcodeDetector.detectVNBarcode(coreImage: ciImage)
        
        // RECOGNIZING TEXT ON IMAGE
//                self.recognizeText(on: sampleBuffer)
        self.removeMarkingRectangles()
        self.removePriceAnnotations()
    }
    
}
