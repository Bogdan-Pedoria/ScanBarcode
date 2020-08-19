//
//  MLBarcodeDetector.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/1/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation

//////////////////////////////////////////////////////////////////////////////
////////////////// VCExtension FOR MLKit Barcode Detection

class MLBarcodeDetector {
    
    var barcodeDetectorDelegate: TableViewUpdateDelegate?
    let format = VisionBarcodeFormat.all
    lazy var vision = Vision.vision()
    
    func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> VisionDetectorImageOrientation {
        
        
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
    
    func detectMLBarcode(sampleBuffer: CMSampleBuffer?=nil, image: UIImage?=nil) {

        guard sampleBuffer != nil || image != nil else { return }
        let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
        let MLBarcodeDetector = self.vision.barcodeDetector(options: barcodeOptions)
//        let cameraPosition = AVCaptureDevice.Position.back
//        let metadata = VisionImageMetadata()
        var mlImage: VisionImage
        if let buffer = sampleBuffer {
            mlImage = VisionImage(buffer: buffer)
        }
        else {
            mlImage = VisionImage(image: image!)
        }
//        metadata.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: cameraPosition)
//        image.metadata = metadata
        
        MLBarcodeDetector.detect(in: mlImage, completion: { features, error in
            guard error == nil, let barcodes = features, !barcodes.isEmpty else {
                return
            }
            self.barcodeDetectorDelegate?.didDetectMLBarcodes(barcodes: barcodes)
        })
    }
    
}
