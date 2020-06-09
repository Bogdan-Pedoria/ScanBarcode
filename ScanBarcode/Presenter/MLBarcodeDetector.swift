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
    
    func detectMLBarcode(sampleBuffer: CMSampleBuffer) {

        let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
        let MLBarcodeDetector = self.vision.barcodeDetector(options: barcodeOptions)
        let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
        let image = VisionImage(buffer: sampleBuffer)
        
        metadata.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: cameraPosition)
        image.metadata = metadata
        MLBarcodeDetector.detect(in: image, completion: { features, error in
            guard error == nil, let MLBarcodes = features, !MLBarcodes.isEmpty else {
                return
            }
            
            for barcode in MLBarcodes {
//                let corners = barcode.cornerPoints //they are wrong -- maybe smth wrong with orientation in the method above
                let valueType = barcode.valueType
                
                switch valueType {
                case .product:
                    let barcodeNo = barcode.displayValue
//                    let barcodeNo = barcode.rawValue // IT WAS THE SAME
//                    let type = barcode.format
                    self.barcodeDetectorDelegate?.didDetectMLBarcode(barcodeNo: barcodeNo!)
                default:
                    print("NOT A PRODUCT BARCODE. valueType = \(valueType)")
                }
                
            }
        })
    }
    
}
