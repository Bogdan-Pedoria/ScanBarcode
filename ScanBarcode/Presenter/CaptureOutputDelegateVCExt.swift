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
        
//        print("^^^^^^^^^ did NOT drop frame. type error count = \(self.unknownTypeCount)")
        
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        guard let imageBuffer = sampleBuffer.imageBuffer else { return }
        guard isScanning else { return }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        var image = UIImage()
        if self.singleScanMode {
            image = self.cropImage(ciImage: ciImage, with: self.singleScanModeCroppingRect)
//            debug("SINGLE SCAN MODE IS ACTIVE")
        }
        else {
            image = convert(ciImage)!
//            debug("MULTY SCAN MODE IS ACTIVE")
        }
    
//    print("Dimensions of buffer before modifications:\n width: \(CVPixelBufferGetWidth(ciImage.pixelBuffer!)); height: \(CVPixelBufferGetHeight(ciImage.pixelBuffer!))\n")
    
    /// DEBUG
//let jpgData = image!.jpegData(compressionQuality: 1.0)
//print("just jpg data = \(jpgData)")
//UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    /// END DEBUG
        
        // BARCODE DETECTION
        mlBarcodeDetector.detectMLBarcode(image: image)
        
        // PROCESS IMAGE WITH Vision API
        vnBarcodeDetector.detectVNBarcode(coreImage: ciImage)
        
        // RECOGNIZING TEXT ON IMAGE
//                self.recognizeText(on: sampleBuffer)
    }
    
    
    func cropImage(ciImage: CIImage, with croppingRect: CGRect) -> UIImage {
        
        let screenRatio = self.imageToScreenRatio(self.cameraResolution)
        let resizedCroppingRectangle = self.resizeRect(croppingRect, withRatio: screenRatio)
        let cgImage = convertToCGImage(ciImage: ciImage)
        guard let croppedImage = cgImage.cropping(to: resizedCroppingRectangle) else { return UIImage() }
        return UIImage(cgImage: croppedImage)
    }
    
    
    func convertToUIImage(ciImage:CIImage) -> UIImage? {
        
        let cgImage = convertToCGImage(ciImage: ciImage)
        let image:UIImage = UIImage(cgImage: cgImage)
        return image
    }
    
    
    func convertToCGImage(ciImage: CIImage) -> CGImage {
        
        let context: CIContext = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }
}
