//
//  TableViewUpdateExtension.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/1/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

#warning("FIX DRY RULE HERE OR REMOVE VISION API DETECTION AT ALL")
/*
    IN THIS FILE THE "DRY" RULE COMPLETELY BROKEN. IT IS DONE FOR CLARITY, BECUASE TWO DIFFERENT SDKs DETECT BARCODE, AND I NEED TO SEPARATE DICTIONARIES FROM THEM.
    TODO: FIX IT LATER
 */

import Foundation
import UIKit

/*
    EXTENSION TO UPDATE TABLE VIEW WHENEVER VISION API DETECTS BARCODE
 */
extension ViewController: TableViewUpdateDelegate {
    
        func didDetectVNBarcode(barcodeNo: String) {
            
            switch BarcodeData.determineBarcodeType(barcodeNo: barcodeNo) {// TO INSURE THAT ON THIS STAGE I WILL WORK ONLY WITH EAN8 -- FUDGE BARCODES TO MAKE DEVELOPMENT EASY
            case .FUDGE_BARCODE:
                self.updateVNBarcodes(barcodeNo: barcodeNo)
            default:
                return
            }
            checkDetectorMatch()
//            putErrorDuplicatesAllTogetherUp()
//            bringPairedDuplicatesUp()
    //        drawRectangleOnFrame(rectangle: rectangle) // deprecated google give wrong sized rectangles
        }
    
    func didDetectMLBarcode(barcodeNo: String, barcodeFrame: CGRect) {
                
        switch BarcodeData.determineBarcodeType(barcodeNo: barcodeNo) {// TO INSURE THAT ON THIS STAGE I WILL WORK ONLY WITH EAN8 -- FUDGE BARCODES TO MAKE DEVELOPMENT EASY
        case .FUDGE_BARCODE:
            if self.updateMLBarcodes(barcodeNo: barcodeNo) {
                self.markDetectedArea(barcodeFrame: barcodeFrame, barcodeNo: barcodeNo)
                self.checkDetectorMatch()
//                self.reloadTableView()
                self.updateCounterButton(number: MLBarcodes.count)
            }
            self.updateBarcodeNumbersWithRating(barcodeNo: Int(barcodeNo)!)
            self.filterBarcodeNumbersWithRating()
            self.updateMLBarcodesRating()
            self.reloadTableView()
        case .unknown:
            print("UNKNOWN BARCODE TYPE FOUND. should be just a detection error, ignore it")
        }
        
//        putErrorDuplicatesAllTogetherUp()
//        bringPairedDuplicatesUp()
    }
    
    
    func updateMLBarcodesRating() {
        
        for (barcodeNo, barcodeData) in MLBarcodes {
            MLBarcodes[barcodeNo]!.detectionRating = barcodeNumbersWithRating[barcodeNo]!
        }
    }
    
    
    func filterBarcodeNumbersWithRating() {
        
        var tenPercentFilteredBarcodes = BarcodesFilter.filterAllThatBelowErrorTreshold(barcodeNumbersWithRating: barcodeNumbersWithRating, errorPercent: 10)
        var halfFilteredBarcodes = BarcodesFilter.filterAllThatBelowHalfOfBestRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        var barcodeRatingData = BarcodesRatingEvaluator(barcodeNumbersWithRating: barcodeNumbersWithRating)
        
        debug("tenPercentFilteredBarcodes: \(tenPercentFilteredBarcodes)")
        debug("HalfFilteredBarcodes: \(halfFilteredBarcodes)")
        debug("barcodeRatingData:\(barcodeRatingData)")
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
    
    
    /// TO CHECK IF TWO DETECTORS FOUND SAME VALUE
    private func checkDetectorMatch() {
        // CHECKING MATCH -- IF BOTH DETECTORS FOUND SAME VALUE FOR BARCODE
        for (key, value) in self.MLBarcodes {
            if self.VNBarcodes[key] != nil {
                self.MLBarcodes[key]?.detectorMatch = true
                self.VNBarcodes[key]?.detectorMatch = true
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
    
    private func updateMLBarcodes(barcodeNo: String) -> Bool {
        
        var key = Int()
        key = Int(barcodeNo)! // TESTING: crashing to know if it is possible for barcodeNo to have non digits or Int overflow
        if MLBarcodes[key] == nil {
            let id = MLBarcodes.count
            var newBarcodeData = BarcodeData(barcodeNo: barcodeNo, id: id, detector: .MLKit)
            
            if didValidateBarcodeData(newBarcodeData) {
                // MARK DUPLICATE WITH DIFFERENT PRICE IF WE HAVE THEM
                //it was due to error: same barcode scanned twice but with the wrong price on one of the results
                // and i probably disallowed this from happening at all(?)
//                checkPossibleErrorDuplicates(newBarcodeData)
                
                MLBarcodes[key] = newBarcodeData

                #warning("TODO: MAKE SEPARATE FUNCTION IN THE Alert struct THAT NOTIFIES ABOUT NEW BARCODE")
//                Alert.showAlert(withTitle: "Price = $\(MLBarcodes[Int(barcodeNo)!]?.barcodePrice)", message: "Price = $\(MLBarcodes[Int(barcodeNo)!]?.productName)", buttonText: "Price is CORRECT", completion: { _ in
//                    return
//                })
                return true
            }
        }
        return false
    }
    
    
    private func updateVNBarcodes(barcodeNo: String) -> Bool {
        
        var key = Int()
        key = Int(barcodeNo)! // TESTING: crashing to know if it is possible for barcodeNo to have non digits or Int overflow
        if VNBarcodes[key] == nil {
            let id = VNBarcodes.count
            var newBarcodeData = BarcodeData(barcodeNo: barcodeNo, id: id, detector: .VisionAPI)
            
            if didValidateBarcodeData(newBarcodeData) {
                // MARK DUPLICATE WITH DIFFERENT PRICE IF WE HAVE THEM
//                checkPossibleErrorDuplicates(newBarcodeData)
                VNBarcodes[key] = newBarcodeData
            }
        }
        return true
    }
    
    private func didValidateBarcodeData(_ barcodeData: BarcodeData) -> Bool {
        // ATTENTION: IT IS DONE TO AVOID CAPTURING BARCODES OF ITEMS THAT DO NOT BELONG TO THE BUSINESS. WHY? BECAUSE, IN THIS VERY CASE, MLKit GIVES PARTIALLY CORRECT BARCODE WITH EITHER WRONG NAME OR PRICE BARCODE DIGITS. SO WHEN THE MISTAKE BELONGS TO NAME DIGITS, THIS CONDITION PREVENTS FROM ERROR, WHEN THE MISTAKE IN THE PRICE DIGITS, IT DOES NOT HELP. THEREFORE WE MIGHT WANT TO COMPARE THE RESULT TO THE VISION API IF IT DETECTS SOMETHING, AND IF PRICE WILL NOT MATCH, WE WILL EITHER TAKE VISION's API RESULT AS IT RETURNS MORE ACCURATE RESULTS, IF IT EVER RETURNS ANYTHING AT ALL. BUT WE ALSO MUST NOTIFY USER THAT THERE IS A PRICE MISMATCH.
        if barcodeData.productName == nil {
            return false
        }
        
        // MLDetector  SOMETIMES PLACE 8 INSTEAD OF 2 AS A FIRST DIGIT IN FUDGE ITEMS. FUDGE ITEMS ALWAYS START WITH 2. SO WHEN IT IS 8, IT MIGHT BE ERROR. SO WE FILTER SUCH BARCODES IF THEY BELONG TO FUDGE
        if barcodeData.detector == .MLKit {
            if barcodeData.productType == .Fudge {
                for (i, digit) in barcodeData.barcodeNo.enumerated() {
                    if i == 0 && digit != "2" {
                        return false
                    }
                }
            }
        }
        return true
    }
    
//    func checkPossibleErrorDuplicates(_ barcodeData: BarcodeData) {
//
//        //CASE: The duplicate item with wrong/different price occures?
//        for (key, value) in MLBarcodes {
//            if value.productName == barcodeData.productName {
//                if value.barcodePrice != barcodeData.barcodePrice {
////                    barcodeData.possibleErrorDuplicate = true
//
//                    //CHANGING ITEM IN GENERAL ARRAY TO MAKE FOR USER EASY TO RECOGNIZE WHERE BOTH OF THE DUPLICATES
//                    MLBarcodes[key]!.possibleErrorDuplicate = true
//                }
//            }
//        }
//    }
    
//    func putErrorDuplicatesAllTogetherUp() {
//        var notDuplicateArrangementNumber = MLBarcodes.count - 1
//        var duplicateArrangementNumber = Int()
//        for (i, (key, value)) in self.MLBarcodes.enumerated() {
//            if !value.possibleErrorDuplicate {
//                self.MLBarcodes[key]?.arrangementNo = notDuplicateArrangementNumber
//                print(MLBarcodes[key])
//                print(" ** assigned NotDuplicateNo = ", notDuplicateArrangementNumber)
//                notDuplicateArrangementNumber -= 1
//            }
//            if value.possibleErrorDuplicate {
//                self.MLBarcodes[key]?.arrangementNo = duplicateArrangementNumber
//                print(MLBarcodes[key])
//                print(" ** assigned duplicateNo = ", duplicateArrangementNumber)
//                duplicateArrangementNumber += 1
//            }
//        }
//    }
    
//    private func bringPairedDuplicatesUp() {
//        print(" ** MLBarcodes before bringing duplicates together = \(MLBarcodes)")
//        connectBarcodeDuplicatesByBarcodeNo()
//        print(" ** Connected Barcode Duplicates = \(MLBarcodes)")
//        bringDuplicatesArrangementNumbersTogether()
//        print(" ** DuplicatesBroughTogether = \(MLBarcodes)")
////        findMissingArrangmentsNumbers()
//        shiftCollidedArrangementNumbers()
//        print(" ** CollidedDuplicates shifted = \(MLBarcodes)")
//    }

//    private func connectBarcodeDuplicatesByBarcodeNo() {
//            for (i, (key, value)) in MLBarcodes.enumerated() {
//                for (j, (key2, value2)) in MLBarcodes.enumerated() {
//                    if j <= i {
//                        continue
//                    }
//                    if value2.productName == value.productName {
//                        MLBarcodes[key]?.pairedByNameWithBarcodeNo = value2.barcodeNo
//    //                    MLBarcodes[key2]?.pairedByNameWithBarcodeNo = value.barcodeNo
//                    }
//                }
//            }
//        }
    
    
//    private func bringDuplicatesArrangementNumbersTogether() {
//        for (key, value) in MLBarcodes {
//            if let pairBarcodeNo = value.pairedByNameWithBarcodeNo {
//                MLBarcodes[Int(pairBarcodeNo)!]?.arrangementNo = value.arrangementNo + 1
//            }
//        }
//    }
    
//    private func shiftCollidedArrangementNumbers() {
//        var alreadyShifted = Bool()
//        for (i, (key, value)) in MLBarcodes.enumerated() {
//            var shiftedBarcodeData = [BarcodeData]()
//            for (j, (key2, value2)) in MLBarcodes.enumerated() {
//                alreadyShifted = false
//                if j <= i {
//                    continue
//                }
//                for barcodeData in shiftedBarcodeData {
//                    if value2.barcodeNo == barcodeData.barcodeNo {
//                        alreadyShifted = true
//                    }
//                }
//                if value.arrangementNo == value2.arrangementNo && !alreadyShifted {
//                    MLBarcodes[key2]!.arrangementNo += 1
//                    shiftedBarcodeData.append(MLBarcodes[key2]!)
//                }
//            }
//        }
//    }
}
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
