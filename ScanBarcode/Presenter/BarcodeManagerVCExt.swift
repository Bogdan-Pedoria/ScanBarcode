//
//  BarcodeManagerVCExt.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 8/10/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


extension ViewController {
    
    
    func validateBarcodeByRating(barcodeNo: String){
        
        //we will be sending multi scanned barcodes all together,
        // therefore, func validateBarcodeRecognition(barcodeNo: String)
        // only for singleDetectionMode
        if  let rating = self.barcodeNumbersWithRating[Int(barcodeNo)!], rating % 3 == 0, let barcode = MLBarcodes[Int(barcodeNo)!] {
            #warning("TODO: CHANGE detectorMatch HERE TO validated and all related to it")
            self.MLBarcodes[Int(barcodeNo)!]!.didPassValidation = true // TODO: change detectorMatch to validated
        }
    }
    
    func updateBarcodesWithRatingAndFilter(barcodeNo: Int) {
        
        self.updateBarcodeNumbersWithRating(barcodeNo: barcodeNo)
        self.updateMLBarcodesRating()
        self.filterBarcodeNumbersWithRating()
    }
    
    func filterBarcodesToSend() -> [Int: BarcodeData] {
        
        //filtering to send only not sent barcodes
        var mlBarcodesCopy = [Int: BarcodeData]()
        
            for (barcodeNo, barcodeData) in MLBarcodes {
                //we got a duplicate barcode
                if barcodeData.timesSent > 0 && !(barcodeData.isSent ?? false) && (barcodeData.hasBeenSent ?? false) {
//                    MLBarcodes[barcodeNo]?.quantity += 1
                }
                if !(barcodeData.isSent ?? false) {
                    MLBarcodes[barcodeNo]?.hasBeenSent = true
                    mlBarcodesCopy[barcodeNo] = barcodeData
                }
            }
        return mlBarcodesCopy
    }
    
    func sendBarcode(barcodeNo: Int) {
    //                self.sendBarcodeInSingleScanMode(Int(barcodeNo)!)
            AudioServicesPlayAlertSound(SystemSoundID(1211))//touch tone pound('#') key: it is vibrating, but maybe it is good to stop detection that way by messing up focus?
            self.sendButtonTapped()
            #warning("TODO: SEND THROUGH SOCKET, not through senButtonTapped")
        #warning("TODO: THIS IS WRONG TO markSent here, when i am not really sure if they are sent, but i have to do it here to ease the development")
            self.MLBarcodes[barcodeNo]!.markSent()
    //                self.MLBarcodes.removeAll()
        // to make sure the previous match wont work
        if let detectorMatch = self.VNBarcodes[barcodeNo]?.MLKitVisionAPIMatch, detectorMatch {
                    VNBarcodes.removeValue(forKey: barcodeNo)
            }
    }
    

    
    func isDuplicate(barcodeNo: Int, newOrigin: Point) -> Bool {
        
        let key = barcodeNo
        debug("Current barcode\(MLBarcodes[key]?.productName): \(key)")
        
        // if does not update -- it is possible duplicate
        guard !self.updateOriginsOfOneFrame(barcodeNo: key, origin: newOrigin) else { return false }
        // for explicity/simplicity: if it does not update, it means it is origin of duplicate
        let originOfPossibleDuplicate = newOrigin
        
        // if does not update, grab the origin that already there
        let origin = originsOfOneFrame[key]!
//            if !BarcodeData.areBarcodesSame(MLBarcodes[key]!, newBarcodeData) {
//                MLBarcodes[key]!.hasDuplicate = true
//                return true
//            }
        #warning("TODO: IT IS Only Temporary. Do the condition above with relative distance, so user can change the distance to barcodes")
        return BarcodeData.isDistanceBetweenTwoOriginsBigEnoughToSayBarcodeIsDifferent(origin, originOfPossibleDuplicate)
    }
    
    
    func updateOriginsOfOneFrame(barcodeNo: Int, origin: Point) -> Bool {
        
//        #warning("TODO: Remove this validation, if you can")
//        guard BarcodeData.validateBarcodeNo(barcodeNo: String(barcodeNo), detector: .MLKit) else {
//            return false
//        }
        debug("originsOfOneFrame: \(originsOfOneFrame)")
        if self.originsOfOneFrame[barcodeNo] == nil {
            
            // update origin every frame
            self.originsOfOneFrame[barcodeNo] = origin
            return true
        }
        return false
    }
    
    
    func updateMLBarcodes(newBarcodeData: BarcodeData) -> Bool {
        
        var key = Int(newBarcodeData.barcodeNo)! // TESTING: crashing to know if it is possible for barcodeNo to have non digits or Int overflow
        
        if MLBarcodes[key] == nil {
            
//            if didValidateBarcodeData(newBarcodeData) {

        }
        // this all HELL: I was drunk of wanting to sleep
//        else if MLBarcodes[key]!.isBarcodeSent && MLBarcodes[key]!.checkDuplicate() {
//                MLBarcodes[key]!.markDuplicate()
//        }
//        else if !MLBarcodes[key]!.isBarcodeSent {
//            self.validateBarcodeByRating(barcodeNo: barcodeNo)
//        }
        return false
    }
    
    
//    // TODO: Method is redundant. Redo to fit in the caller and remove it
//    func didValidateBarcodeData(_ barcodeData: BarcodeData) -> Bool {
//        // ATTENTION:
//        //IT IS DONE TO AVOID CAPTURING BARCODES OF ITEMS THAT DO NOT BELONG TO THE BUSINESS. WHY? BECAUSE, IN THIS VERY CASE, MLKit GIVES PARTIALLY CORRECT BARCODE WITH EITHER WRONG NAME OR PRICE BARCODE DIGITS. SO WHEN THE MISTAKE BELONGS TO NAME DIGITS, THIS CONDITION PREVENTS FROM ERROR, WHEN THE MISTAKE IN THE PRICE DIGITS, IT DOES NOT HELP. THEREFORE WE MIGHT WANT TO COMPARE THE RESULT TO THE VISION API IF IT DETECTS SOMETHING, AND IF PRICE WILL NOT MATCH, WE WILL EITHER TAKE VISION's API RESULT AS IT RETURNS MORE ACCURATE RESULTS, IF IT EVER RETURNS ANYTHING AT ALL. BUT WE ALSO MUST NOTIFY USER THAT THERE IS A PRICE MISMATCH.
//        return true
//    }
    
    
    
    func updateMLBarcodesRating() {
        
        for (barcodeNo, barcodeData) in MLBarcodes {
            MLBarcodes[barcodeNo]!.detectionRating = barcodeNumbersWithRating[barcodeNo]!
        }
    }
    
    
    func filterBarcodeNumbersWithRating() {
        
        self.tenPercentPrecisionFilteredBarcodes = BarcodesFilter.filterAllThatBelowErrorTreshold(barcodeNumbersWithRating: barcodeNumbersWithRating, errorPercent: 10)
        self.halfPrecisionFilteredBarcodes = BarcodesFilter.filterAllThatBelowHalfOfBestRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        var barcodeRatingData = BarcodesRatingEvaluator(barcodeNumbersWithRating: barcodeNumbersWithRating)
        
//        debug("tenPercentFilteredBarcodes: \(tenPercentPrecisionFilteredBarcodes)")
//        debug("HalfFilteredBarcodes: \(halfPrecisionFilteredBarcodes)")
//        debug("barcodeRatingData:\(barcodeRatingData)")
    }
    
    
    /// Func to update barcodeNumbers
    /// - Parameter barcodeNo: Int
    func updateBarcodeNumbersWithRating(barcodeNo: Int) {
        
//        self.barcodeNumbers.append(barcodeNo)
        if let rating = self.barcodeNumbersWithRating[barcodeNo] {
            self.barcodeNumbersWithRating[barcodeNo] = rating + 1
            debug("Updating barcodeNumber incremeting rating: \(rating + 1)\n\(self.barcodeNumbersWithRating)")
        }
        else {
            self.barcodeNumbersWithRating[barcodeNo] = 0
            debug("new barcode with no rating added \(barcodeNo)\n")
        }
    }
    
    
//    func avoidDetectionNextFiveSeconds(barcodeNo: Int) {
//        
//        
//            self.MLBarcodes[barcodeNo]?.sentDate = datetimeNow()
//            self.MLBarcodes[barcodeNo]?.refreshBarcode()
//            self.MLBarcodes[barcodeNo]?.isSent = true
//    }
//    
//    func preventFromSendingDuplicateBarcode(barcodeNo: Int) {
//        
//        
//        self.MLBarcodes[barcodeNo]?.sentDate = datetimeNow()
//    }
    
    
    /// TO CHECK IF TWO DETECTORS FOUND SAME VALUE
    func validateBarcodesIfDetectorsMatch() {
        // CHECKING MATCH -- IF BOTH DETECTORS FOUND SAME VALUE FOR BARCODE
        for (key, value) in self.MLBarcodes {
            if self.VNBarcodes[key] != nil {
                self.MLBarcodes[key]?.detectorsDidMatch()
                self.VNBarcodes[key]?.detectorsDidMatch()
            }
        }
    }
    
//    func drawRectangleOnFrame(rectangle: CGRect) {
        
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: rectangle, cornerRadius: 0).cgPath
//        layer.fillColor = UIColor.red.cgColor
//        self.view.layer.addSublayer(layer)
//
//        //TEST DRAW -- DRAWING RECTANGLE
//        let testView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        testView.backgroundColor = .yellow
//        testView.tag = 100
//        self.view.addSubview(testView)
//        self.view.viewWithTag(100)?.removeFromSuperview()
//    }
    
    
    func updateVNBarcodes(barcodeNo: String) -> Bool {
        
        var key = Int()
        key = Int(barcodeNo)! // TESTING: crashing to know if it is possible for barcodeNo to have non digits or Int overflow
        if VNBarcodes[key] == nil {
            let id = VNBarcodes.count
            let newBarcodeData = BarcodeData(barcodeNo: barcodeNo, id: id, detector: .VisionAPI, rectangleOrigin: Point.init(x: 0, y: 0)) // now NO ORIGINS FOR VNBarcodes
            #warning("HAVE TO ADD FAKE ORIGIN. FOR NOW I DONT NEED ORIGIN FOR VNBarcodes")
            
//            if didValidateBarcodeData(newBarcodeData) {
                // MARK DUPLICATE WITH DIFFERENT PRICE IF WE HAVE THEM
//                checkPossibleErrorDuplicates(newBarcodeData)
                VNBarcodes[key] = newBarcodeData
//            }
        }
        return true
    }
    
    func saveCurrentBarcodes() {
        var barcodeDatas = [BarcodeData]()
        for (barcodeNo, barcodeData) in MLBarcodes {
            barcodeDatas.append(barcodeData)
        }
        historyBarcodes[datetimeNow()] = barcodeDatas
    }
    
    func removeCurrentBarcodes() {
        self.MLBarcodes.removeAll()
        self.VNBarcodes.removeAll()
        self.barcodeNumbersWithRating.removeAll()
        self.halfPrecisionFilteredBarcodes.removeAll()
        self.tenPercentPrecisionFilteredBarcodes.removeAll()
//        self.rectanglesForBarcodes.removeAll()
        self.reloadTableView()
    }
}
