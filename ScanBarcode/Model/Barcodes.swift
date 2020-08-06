//
//  BarcodesModel.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 5/31/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation


let FUDGE_NAMES_FOR_DIGITS = [
    "3381": "Tiger Fudge",
    "8162": "Mk.Ch. Cheesecake Fudge",
    "8078": "Vanilla Caramel Praline Fudge",
    "3356": "Mk.Ch. Fudge",
    "3123": "Mk.Ch. PeanutButter Oreo Fudge",
    "8066": "Mk.Ch. PeanutButter Fudge",
    "3364": "Cookies&Cream Fudge",
    "3360": "RockyRoad Fudge",
    "8100": "Heavenly Goo Fudge",
    "1360": "Root Beer Float Fudge",
    "3359": "Mint Fudge",
    "8067": "Divinity Fudge",
    "3358": "Mk.Ch. Walnut Fudge",
    "3371": "Maple Nut Fudge",
    "8096": "Red Velvet Fudge"
]

let PRODUCTS = [
    ProductType.Fudge : FUDGE_NAMES_FOR_DIGITS
]

enum ProductType: String, Codable {
    case Fudge
}

enum BarcodeType: String, Codable {
//    case EAN8(Int?, Int?, Int?, Int?, Int?, Int?, Int?, Int?, Int?, Int?, Int?, Int?)
    case FUDGE_BARCODE
    case unknown
}

enum Detector: String, Codable {
    case MLKit
    case VisionAPI
}

struct BarcodeData: Codable {
    
    var barcodeNo = String()
    var productName: String?
    var barcodePrice = Float()
    var quantity = Int()
    var barcodeType: BarcodeType
    var id = Int()
    var detectorMatch = Bool()
    var detector: Detector
    var productType: ProductType?
    var possibleErrorDuplicate = Bool() // MLkit READS WRONG PRICE DIGITS WITH RIGHT NAME DIGITS
//    var arrangementNo = Int()
//    var pairedByNameWithBarcodeNo: String?
    var detectionRating = Int()
    
    enum CodingKeys: String, CodingKey {
        case barcodeNo
        case productName
        case barcodePrice
        case quantity
        case barcodeType
        case id
        case detectorMatch
        case detector
        case productType
        case possibleErrorDuplicate
//        case arrangementNo
//        case pairedByNameWithBarcodeNo
    }
    
    
    // TODO: DO init WITH ADDITIONAL PARAMETER barcodeType from MLKit
    init(barcodeNo: String, id: Int, detector: Detector) {
        self.id = id
//        self.arrangementNo = id // INITIAL SETUP. THEN IT WILL CHANGE BY IMPORTANCE
        self.barcodeNo = barcodeNo
        self.detector = detector
        self.barcodeType = .unknown
        self.productName = self.determineBarcodeName()
        self.productType = self.determineProductType()
        self.barcodeType = BarcodeData.determineBarcodeType(barcodeNo: self.barcodeNo)
        self.barcodePrice = self.determineBarcodePrice(barcodeType: self.barcodeType)
    }
    
    // TODO: DO init WITH ADDITIONAL PARAMETER barcodeType from MLKit
    // TODO: HANDLE MULTIPLE TYPES OF BARCODES. RIGHT NOW HANDLES ONLY EAN8
    static func determineBarcodeType(barcodeNo: String) -> BarcodeType {
        var barcodeType = BarcodeType.unknown
        if barcodeNo.count <= 13 { //BECAUSE VisionAPI prepends 0 TO THE BarcodeNo
            for (i, char) in barcodeNo.enumerated() {
                if !char.isWholeNumber {
                    break
                }
                else {
                    if i == 11 {
                        barcodeType = BarcodeType.FUDGE_BARCODE
                    }
                }
            }
        }
        return barcodeType
    }
    
    private func getNameDigits() -> String {
        var nameDigits = String()
        if self.detector == .MLKit {
            for (i, digit) in self.barcodeNo.enumerated() {
                if i > 1 && i < 6 {
                    nameDigits.append(digit)
                }
            }
        }
        
        // VISION API PREPENDS 0 TO THE EAN8
        if self.detector == .VisionAPI {
            for (i, digit) in self.barcodeNo.enumerated() {
                if i > 2 && i < 7 {
                    nameDigits.append(digit)
                }
            }
        }
        return nameDigits
    }
    
    private func determineProductType() -> ProductType? {
        var nameDigits = String()
        var type: ProductType?
        
        nameDigits = getNameDigits()
        type = getProductType(forNameDigits: nameDigits)
        return type
    }
    
    private func getProductType(forNameDigits nameDigits: String) -> ProductType? {
        var type: ProductType?
        for (_productType, value) in PRODUCTS {
            if value[nameDigits] != nil {
                type = _productType
                break
            }
        }
        return type
    }
    
    private func determineBarcodeName() -> String? {
        var nameDigits = String()
        var name: String?
        
        nameDigits = getNameDigits()
        name = getMatchName(for: nameDigits)
        return name
    }
    
    private func getMatchName(for nameDigits: String) -> String? {
        var name: String?
        if let _name = FUDGE_NAMES_FOR_DIGITS[nameDigits] {
            name = _name
        }
        return name
    }
    
    private func determineBarcodePrice(barcodeType: BarcodeType) -> Float {
        var price = Float()
        if detector == .MLKit {
            if barcodeType == .FUDGE_BARCODE {
                var multiplier = Float(10)
                for (i, digit) in barcodeNo.enumerated() {
                    if i > 6 && i < 11 {
                        let fDigit = Float(digit.wholeNumberValue!)
                        price += fDigit * multiplier
                        price = roundToHundredth(number: price)
                        multiplier /= 10
                    }
                }
            }
        }
        
        // VISION API PREPENDS 0 TO THE EAN8
        if detector == .VisionAPI {
            if barcodeType == .FUDGE_BARCODE {
                var multiplier = Float(10)
                for (i, digit) in barcodeNo.enumerated() {
                    if i > 7 && i < 12 {
                        let fDigit = Float(digit.wholeNumberValue!)
                        price += fDigit * multiplier
                        price = roundToHundredth(number: price)
                        multiplier /= 10
                    }
                }
            }
        }
        return price
    }
    
}

