//
//  BarcodeManagerVCExt.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 8/10/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit


extension ViewController {
    
    
    func cleanMLBarcodesFromErrors() {
        
        #warning("ALL WRONG. DONT USE")
//        for (barcodeNo, barcode) in MLBarcodes {
////            if barcode.didOneSecondsPass() {
//                if halfPrecisionFilteredBarcodes[barcodeNo] == nil {
//                    MLBarcodes.removeValue(forKey: barcodeNo)
//                }
////            }
//        }
    }
    
    func validateBarcodeByRating(barcodeNo: Int){
        
        //we will be sending multi scanned barcodes all together,
        // therefore, func validateBarcodeRecognition(barcodeNo: String)
        // only for singleDetectionMode
        if  let rating = self.barcodeNumbersWithRating[barcodeNo], rating > 0, rating % MIN_DETECTION_RATING == 0, let barcode = MLBarcodes[barcodeNo] {
            #warning("TODO: CHANGE detectorMatch HERE TO validated and all related to it")
            self.MLBarcodes[barcodeNo]!.didPassValidation = true // TODO: change detectorMatch to validated
        }
    }
    
    func updateBarcodesWithRatingAndFilter(barcodeNo: Int) {
        
        debug("BeforeCalling updateRating()")
        self.updateBarcodeNumbersWithRating(barcodeNo: barcodeNo)
        debug("afterCalling updatedRating()")
        self.updateMLBarcodesRating(barcodeNo: barcodeNo)
        self.filterBarcodeNumbersWithRating()
    }
    
    
//    func updateBarcodesForTableView() {
//        
////        if getNumberOfMLBarcodesWithDuplicates() > barcodesForTableView.count {
//            barcodesForTableView = getBarcodesArrayWithHighRatingForTableView()
////        }
//    }
    
//    func getNumberOfMLBarcodesWithDuplicates() -> Int {
//
//        var count = Int()
//        for (barcodeNo, barcode) in MLBarcodes {
//            if barcode.productName == nil {
//                continue
//            }
////            if tenPercentPrecisionFilteredBarcodes[barcodeNo] == nil {
////                continue
////            }
//
//            if barcode.detectionRating < MIN_DETECTION_RATING {
//                continue
//            }
//            if barcode.hasDuplicate {
//                count += barcode.numberOfDuplicates
//            }
//            count += 1
//        }
//        return count
//    }
    
    
    func getBarcodesArrayWithHighRatingForTableView() -> [BarcodeData] {
        
        guard MLBarcodes.count > 0 else { return [BarcodeData]() }
        var barcodes = [BarcodeData]()
        var filteredMLBarcodes = MLBarcodes.filter { key, value in
            return (value.detectionRating ?? 0) > MIN_DETECTION_RATING
        }
        // looping in MLBarcodes because filteredMLBarcodes has missing ids
        for i in 0...MLBarcodes.count {
            for (barcodeNo, barcode) in filteredMLBarcodes {
                if barcode.id == i {
                    if barcode.isDuplicate {
                        continue
                    }
                    barcodes.append(barcode)
                    if barcode.hasDuplicate {
                        #warning("TODO: All the logic connected to numberOfDuplicates is wrong. REDO")
                        for (barcodeNo, barcode2) in filteredMLBarcodes {
                            if barcode2.isDuplicate && barcode.productName == barcode2.productName {
                                barcodes.append(barcode2)
                            }
                        }
                    }
                }
            }
        }
        // DEBUG
        if MLBarcodes.count > 5 && MLBarcodes.count != barcodes.count {
            debug("MLBarcodes != barcodesForTV")
        }
        return barcodes
    }
    
    
    // filtering to send only not sent barcodes
    func filterBarcodesToSend() -> [Int: BarcodeData]? {
        
        var mlBarcodesCopy = [Int: BarcodeData]()
        
        if self.singleScanMode {
        
            for (barcodeNo, barcodeData) in MLBarcodes {
                //we got a duplicate barcode
//                if barcodeData.timesIsBeingSent > 0 && !(barcodeData.isBeingSent ?? false) && (barcodeData.hasBeenSent ?? false) {
////                    MLBarcodes[barcodeNo]?.quantity += 1
//                }
                if !(barcodeData.isBeingSent ?? false) {
                    MLBarcodes[barcodeNo]?.hasBeenSent = true
                    mlBarcodesCopy[barcodeNo] = barcodeData
                }
            }
        }
        // else: not singleScanMode
        else {
            for barcode in self.getBarcodesArrayWithHighRatingForTableView() {
                if MLBarcodes[Int(barcode.barcodeNo)!] != nil {
                    mlBarcodesCopy[Int(barcode.barcodeNo)!] = barcode
                }
            }
        }
        if mlBarcodesCopy.count == 0 {
            return nil
        }
        return mlBarcodesCopy
    }
    
    
    func sendBarcodeInSSMode(barcodeNo: Int) {
        
        if self.singleScanMode {
    //                self.sendBarcodeInSingleScanMode(Int(barcodeNo)!)
            self.sendButtonTapped()
            #warning("TODO: SEND THROUGH SOCKET, not through senButtonTapped")
//        #warning("TODO: THIS IS WRONG TO markSent here, when i am not really sure if they are sent, but i have to do it here to ease the development")
//            self.MLBarcodes[barcodeNo]!.markSent()
    //                self.MLBarcodes.removeAll()
        
        /// to make sure the previous detector match wont work next time
        if let detectorMatch = self.VNBarcodes[barcodeNo]?.MLKitVisionAPIMatch, detectorMatch {
                    VNBarcodes.removeValue(forKey: barcodeNo)
            }
        }
    }
    
/*
// isDuplicate version 1
    func isDuplicate(barcodeNo: Int, originOfPossibleDuplicate: Point) -> Bool {

        debug("Current barcode\(MLBarcodes[barcodeNo]?.productName): \(barcodeNo)")

        // if does not update -- it is possible duplicate
        guard !self.updateOriginsOfOneFrame(barcodeNo: barcodeNo, origin: originOfPossibleDuplicate) else { return false }
        // for explicity/simplicity: if it does not update, it means it is origin of duplicate
//        let originOfPossibleDuplicate = newOrigin
        #warning("TODO: move originsOfOneFrame inside of every barcode")
        // because it does not update, grab the origin that already there
        let origin = originsOfOneFrame[barcodeNo]!
//            if !BarcodeData.areBarcodesSame(MLBarcodes[key]!, newBarcodeData) {
//                MLBarcodes[key]!.hasDuplicate = true
//                return true
//            }
        #warning("TODO: IT IS Only Temporary. Do the condition above with relative distance, so user can change the distance to barcodes")
        return BarcodeData.isDistanceBetweenTwoOriginsBigEnoughToSayBarcodeIsDifferent(origin, originOfPossibleDuplicate)
    }

    */
    
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
    
    
    // isDuplicate: version 2
    func isDuplicate(barcodeNo: Int, originOfPossibleDuplicate: Point) -> Bool {
        
        /// if barcode with this barcodeNo is not present yet(== nil) -- this just a new barcode, no need to check anything
        /// But if barcode is already present(!= nil), we can check if it is a duplicate
        guard self.MLBarcodes[barcodeNo] != nil else {return false}
        // if does not update -- it is possible duplicate
        guard !self.updateOriginsOfOneFrame(barcodeNo: barcodeNo, origin: originOfPossibleDuplicate) else { return false }
        guard let oldOrigin = self.originsOfOneFrame[barcodeNo] else {return false}
        
        #warning("TODO: IT IS Only Temporary. Do the condition with relative distance, so user can change the distance from camera to barcodes")
        return BarcodeData.isDistanceBetweenTwoOriginsBigEnoughToSayBarcodeIsDifferent(oldOrigin, originOfPossibleDuplicate)
    }
    
    
    func updateMLBarcodeBecauseItHasDuplicate(barcodeNo: Int, numberOfDuplicate: Int) {
        
        MLBarcodes[barcodeNo]!.hasDuplicate = true
        #warning("TODO: THIS IS WRONG, REMAKE ALL CONNECTED TO IT")
        MLBarcodes[barcodeNo]!.numberOfDuplicates = numberOfDuplicate
    }
    
    
    func updateMLBarcodes(with barcodeNo: Int, origin: Point, numberOfDuplicate: Int = 1) -> Bool {
        
        
        var updated = Bool() // flag-return value
        let id = MLBarcodes.count
//        newBarcodeData.duplicateNo = duplicateNo
        var newBarcode: BarcodeData
        if numberOfDuplicate > 1 {
            newBarcode = BarcodeData(barcodeNo: String(barcodeNo), id: id, detector: .MLKit, rectangleOrigin: origin, isDuplicate: true)
        }
        else  {
            newBarcode = BarcodeData(barcodeNo: String(barcodeNo), id: id, detector: .MLKit, rectangleOrigin: origin, isDuplicate: false)
        }
        if MLBarcodes[barcodeNo] == nil {
            MLBarcodes[barcodeNo] = newBarcode
            if numberOfDuplicate > 1 { //isDuplicate
                //            #warning("TEMPORARILY: dont know why rating of duplicate dont get incremented. UPDATE: FIXED")
                            #warning("TODO: (rating = 4) is not good, because it may catch errored barcode. So if rating is small, that maybe a rare(rear?) error, but still can happen")
                MLBarcodes[barcodeNo]!.detectionRating = 4 // to show duplicates right away; but maybe removed
            }
            updated = true
        }
        // otherwise, for singleScanMode, no need to check
        else if !singleScanMode {
            // if it is far enough from origin of barcode(isDuplicate == false)\
            // that is already in, then add duplicate by recursively\
            // updating MLBarcodes by calling updateMLBarcodes().\
            // but if it is not, do not even try to update anything,\
            // because it is the same barcode that is already in
            if self.isDuplicate(barcodeNo: barcodeNo, originOfPossibleDuplicate: origin) {
                self.updateMLBarcodeBecauseItHasDuplicate(barcodeNo: barcodeNo, numberOfDuplicate: numberOfDuplicate)
                let duplicateBarcodeNo = BarcodeData.makeBarcodeNoForDuplicate(barcodeNo: barcodeNo, numberOfDuplicate: MLBarcodes[barcodeNo]!.numberOfDuplicates)

                // RECURSION
                return self.updateMLBarcodes(with: duplicateBarcodeNo, origin: origin, numberOfDuplicate: numberOfDuplicate + 1)
            }
            // updateOrigin of MLBarcode because it is just the same barcode, but origin could change due to camera being moved;(but even if it is exactly same origin, anyway update origin because i dont know if the origin is exactly the same or camera moved, and i dont want to check it (because it is useless; i dont win anything))
//            else { //WRONG
//                self.updateMLBarcodeOriginEveryFrame(barcodeNo: barcodeNo, newOrigin: origin)
//            }
        }
        self.updateBarcodesWithRatingAndFilter(barcodeNo: barcodeNo)
        // VALIDATING BARCODE BY TRYING TO UPDATE MLBarcodes
        return updated
    }
    
    // NO NEED
//    func updateMLBarcodeOriginEveryFrame(barcodeNo: Int, newOrigin: Point) {
//
//        guard self.MLBarcodes[barcodeNo] != nil else {return}
//        self.MLBarcodes[barcodeNo]?.origin = newOrigin
//    }
    
    
//    // TODO: Method is redundant. Redo to fit in the caller and remove it
//    func didValidateBarcodeData(_ barcodeData: BarcodeData) -> Bool {
//        // ATTENTION:
//        //IT IS DONE TO AVOID CAPTURING BARCODES OF ITEMS THAT DO NOT BELONG TO THE BUSINESS. WHY? BECAUSE, IN THIS VERY CASE, MLKit GIVES PARTIALLY CORRECT BARCODE WITH EITHER WRONG NAME OR PRICE BARCODE DIGITS. SO WHEN THE MISTAKE BELONGS TO NAME DIGITS, THIS CONDITION PREVENTS FROM ERROR, WHEN THE MISTAKE IN THE PRICE DIGITS, IT DOES NOT HELP. THEREFORE WE MIGHT WANT TO COMPARE THE RESULT TO THE VISION API IF IT DETECTS SOMETHING, AND IF PRICE WILL NOT MATCH, WE WILL EITHER TAKE VISION's API RESULT AS IT RETURNS MORE ACCURATE RESULTS, IF IT EVER RETURNS ANYTHING AT ALL. BUT WE ALSO MUST NOTIFY USER THAT THERE IS A PRICE MISMATCH.
//        return true
//    }
    
    func saveAndDeleteMLBarcodes() {
        
        if MLBarcodes.count > 0 {
            
            self.saveCurrentBarcodes()
            self.removeCurrentBarcodes()
        }
    }
    
    func updateMLBarcodesRating(barcodeNo: Int) {
        
        debug("INSIDE \(#function): barcodeNo: \(barcodeNo)")
        for (barcodeNo, barcodeData) in MLBarcodes {
            // IT WAS GIVING ME A WEIRD ERROR. Looked like functions was executed in wrong order, and then like it was passing wrong value.
            // To repeat ERROR, remove if != nil condition
            if barcodeNumbersWithRating[barcodeNo] != nil {
                MLBarcodes[barcodeNo]!.detectionRating = barcodeNumbersWithRating[barcodeNo]!
            }
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
        
        debug("INSIDE \(#function): barcodeNo: \(barcodeNo)")
//        self.barcodeNumbers.append(barcodeNo)
        // DEBUG
//        if String(barcodeNo).count > 12 {
//            debug("DUPLICATE BARCODE_NO FOUND: \(barcodeNo)")
//        }
        if let rating = self.barcodeNumbersWithRating[barcodeNo] {
            self.barcodeNumbersWithRating[barcodeNo] = rating + 1
            debug("Updating barcodeNumber incremeting rating: \(rating + 1)\n\(self.barcodeNumbersWithRating)")
        }
        else {
            self.barcodeNumbersWithRating[barcodeNo] = MLBarcodes[barcodeNo]?.detectionRating ?? 0
            debug("new barcode with no or \(MLBarcodes[barcodeNo]?.detectionRating ?? 0) rating added:  \(barcodeNo)\n")
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
            let newBarcodeData = BarcodeData(barcodeNo: barcodeNo, id: id, detector: .VisionAPI, rectangleOrigin: Point.init(x: 0, y: 0), isDuplicate: false) // now NO ORIGINS FOR VNBarcodes
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
        self.barcodesForTableView.removeAll()
        self.barcodeNumbersWithRating.removeAll()
        self.halfPrecisionFilteredBarcodes.removeAll()
        self.tenPercentPrecisionFilteredBarcodes.removeAll()
//        self.rectanglesForBarcodes.removeAll()
        self.reloadTableView()
    }
}
