//
//  BarcodeDetector.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 5/31/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import Vision
import UIKit

/////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// MARK: VNBarcodeDetector //////////////////////////////

class VNBarcodeDetector {
    
    var barcodeDetectorDelegate: TableViewUpdateDelegate?
    
    private lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest(completionHandler: {[weak self] (request, error) in
            guard error == nil else {
                Alert.showAlert(withTitle: "VNBarcodeDetector Error", message: error!.localizedDescription)
                return
            }
        })
    }()
    
    private func evaluateBarcode(for request: VNRequest) -> String? {
        
        guard let results = request.results else {return nil}
        let bestResult = results.first as? VNBarcodeObservation
        return bestResult?.payloadStringValue
    }
    
    func detectVNBarcode(coreImage: CIImage) {
        
        let handler = VNImageRequestHandler(ciImage: coreImage, orientation: CGImagePropertyOrientation.up, options: [:])
        do {
            try handler.perform([self.detectBarcodeRequest])
        } catch {
            //TODO: HANDLE THE BARCODE DETECTION ERROR
            print(" *** ERROR DETECTING BARCODE. Error \(error.localizedDescription)")
        }
        if let barcodeNo = evaluateBarcode(for: self.detectBarcodeRequest) {
            barcodeDetectorDelegate?.didDetectVNBarcode(barcodeNo: barcodeNo)
        }
    }
}
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

