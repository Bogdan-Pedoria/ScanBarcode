//
//  BarcodesModel.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 5/31/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation




let PRICES = [
    ProductType.Fudge : Double(23.96)
]

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
    var quantity = Double()
    var barcodeType: BarcodeType
    var id = Int()
    var didPassValidation: Bool? //nil: to know it has not been validated yet at all
    var MLKitVisionAPIMatch = Bool()
    var detector: Detector
    var productType: ProductType?
//    var possibleErrorDuplicate = Bool() // MLkit READS WRONG PRICE DIGITS WITH RIGHT NAME DIGITS
//    var arrangementNo = Int()
//    var pairedByNameWithBarcodeNo: String?
    var detectionRating: Int?
    var isBeingSent: Bool? //nil: to know it has not been sent at all
    var isBeingSentDate = Date()
    var isBeingSentTimes = Int() // > 1 means hasDuplicate (for singleScanMode at least)
    var hasBeenSent: Bool?
    var origin: Point
    var hasDuplicate = Bool()
    var isDuplicate = Bool()
    
    // 0 means has no duplicates.
    // 1 means it is original(first)\
    // barcode that has at least\
    // one duplicate
    var numberOfDuplicates = Int()
//    var duplicate: [Int?: BarcodeData?]
    
    enum CodingKeys: String, CodingKey {
        case barcodeNo
        case productName
        case barcodePrice
        case quantity
        case barcodeType
        case id
        case didPassValidation
        case detector
        case productType
//        case possibleErrorDuplicate
        case detectionRating
        case isBeingSent
        case isBeingSentDate
        case isBeingSentTimes
        case MLKitVisionAPIMatch
        case hasBeenSent
        case origin
        case hasDuplicate
        case isDuplicate
        case numberOfDuplicates
//        case duplicate
//        case arrangementNo
//        case pairedByNameWithBarcodeNo
    }
    
    
    // TODO: DO init WITH ADDITIONAL PARAMETER barcodeType from MLKit
    init(barcodeNo: String, id: Int, detector: Detector, rectangleOrigin: Point, isDuplicate: Bool, detectionRating: Int? = 0) {
        // if isDuplicate, it should have prefix of one digit
        var tempBarcodeNo = barcodeNo
        if isDuplicate {
            self.isDuplicate = isDuplicate
            tempBarcodeNo = String(barcodeNo.dropFirst())
        }
        self.id = id
        self.detector = detector
        self.barcodeType = BarcodeData.determineBarcodeType(barcodeNo: tempBarcodeNo, detector: detector)
        self.origin = rectangleOrigin
        self.detectionRating = detectionRating
        self.productName = BarcodeData.determineBarcodeName(barcodeNo: tempBarcodeNo, detector: detector)
        self.productType = BarcodeData.determineProductType(barcodeNo: tempBarcodeNo, detector: detector)
//        self.barcodeType = BarcodeData.determineBarcodeType(barcodeNo: self.barcodeNo, detector: detector)
        self.barcodePrice = BarcodeData.determineBarcodePrice(barcodeNo: tempBarcodeNo, barcodeType: self.barcodeType, detector: detector)
        if productType != nil {
            self.quantity = BarcodeData.calculateQuantity(productType: self.productType!, barcodePrice: self.barcodePrice)
        }
        self.barcodeNo = barcodeNo
    }
    
    
    static func encodeBarcodes(barcodes: [Int:BarcodeData]) -> Data {
        
        let encodedBarcodes = try! JSONEncoder().encode(barcodes)
        return encodedBarcodes
    }
    
    
    static func validateBarcodeNo(barcodeNo: String, detector: Detector) -> Bool {
        
        // MLDetector  SOMETIMES PLACE 8 INSTEAD OF 2 AS A FIRST DIGIT IN FUDGE ITEMS. FUDGE ITEMS ALWAYS START WITH 2. SO WHEN IT IS 8, IT MIGHT BE ERROR. SO WE FILTER SUCH BARCODES IF THEY BELONG TO FUDGE
//        if self.productType == .Fudge {
            return BarcodeData.checkFirstTwoDigits(barcodeNo: barcodeNo, detector: detector)
//        }
        return false
    }
    
    
//    mutating func addDuplicateBarcode(_ barcode: BarcodeData) {
//
//        self.duplicate = [Int(barcode.barcodeNo): barcode]
//    }
    
    static func isDistanceBetweenTwoOriginsBigEnoughToSayBarcodeIsDifferent(_ origin1: Point, _ origin2: Point) -> Bool {
        
        var xDist = (origin1.x - origin2.x)
        var yDist = (origin1.y - origin2.y)
        
        // absoluting values
        if xDist < 0 {
            xDist *= -1
        }
        if yDist < 0 {
            yDist *= -1
        }
        
        // TODO: THIS IS DEBUG: THIS IS WRONG: FIND REAL DISTANCE
        if (xDist > MIN_DISTANCE_BETWEEN_BARCODES) || (yDist > MIN_DISTANCE_BETWEEN_BARCODES) {
            return true
        }
        return false
    }
    
    static func areBarcodesSame(_ barcode1: BarcodeData, _ barcode2: BarcodeData) -> Bool {
        
        let origin1 = barcode1.origin
        let origin2 = barcode2.origin
        let distanceBetweenBarcodesOrigins = Point.measureDistanceBetweenPoints(origin1, origin2)
        if distanceBetweenBarcodesOrigins > MIN_DISTANCE_BETWEEN_BARCODES {
            return false
        }
        return true
    }
    
    static func checkFirstTwoDigits(barcodeNo: String, detector: Detector) -> Bool {
        
        
        for (i, digit) in barcodeNo.enumerated() {
            if detector == .MLKit {
                if i == 0 && digit != "2" {
                    return false
                }
                if i == 1 && digit != "0" {
                    return false
                }
            }
            // VISION API PREPENDS 0 TO THE EAN8
            if detector == .VisionAPI {
                if i == 1 && digit != "2" {
                    return false
                }
                if i == 2 && digit != "0" {
                    return false
                }
            }
        }
        return true
    }
    
    // TODO: DO init WITH ADDITIONAL PARAMETER barcodeType from MLKit
    // TODO: HANDLE MULTIPLE TYPES OF BARCODES. RIGHT NOW HANDLES ONLY EAN8
    static func determineBarcodeType(barcodeNo: String, detector: Detector) -> BarcodeType {
        
        var barcodeType = BarcodeType.unknown
        guard BarcodeData.checkFirstTwoDigits(barcodeNo: barcodeNo, detector: detector) else { return barcodeType }
        if detector != .VisionAPI { //BECAUSE VisionAPI prepends 0 TO THE BarcodeNo
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
    
    
    static func makeBarcodeNoForDuplicate(barcodeNo: Int, numberOfDuplicate: Int) -> Int {
        
        let numberOfZeros = makeIntThatIsOldButAllDigitsAreZerosWith1InFront(oldInt: barcodeNo)
        let prefix = numberOfDuplicate * numberOfZeros
        let barcodeNumberForDuplicate = prefix + barcodeNo
        return barcodeNumberForDuplicate
    }
    
//    mutating func setOrigin(origin: Point) {
//        self.origin = origin
//    }
    
    
    static func calculateQuantity(productType: ProductType, barcodePrice: Float) -> Double {
        
        var quantity = Double()
        if productType == .Fudge {
            quantity = Double(barcodePrice) / (PRICES[productType]!)
        }
        return quantity
    }
    
    
    static func getNameDigits(barcodeNo: String, detector: Detector) -> String {
        
        var nameDigits = String()
        if detector == .MLKit {
            for (i, digit) in barcodeNo.enumerated() {
                if i > 1 && i < 6 {
                    nameDigits.append(digit)
                }
            }
        }
        
        // VISION API PREPENDS 0 TO THE EAN8
        if detector == .VisionAPI {
            for (i, digit) in barcodeNo.enumerated() {
                if i > 2 && i < 7 {
                    nameDigits.append(digit)
                }
            }
        }
        return nameDigits
    }
    
    static func determineProductType(barcodeNo: String, detector: Detector) -> ProductType? {
        var nameDigits = String()
        var type: ProductType?
        
        nameDigits = getNameDigits(barcodeNo: barcodeNo, detector: detector)
        type = getProductType(forNameDigits: nameDigits)
        return type
    }
    
    static func getProductType(forNameDigits nameDigits: String) -> ProductType? {
        var type: ProductType?
        for (_productType, value) in PRODUCTS {
            if value[nameDigits] != nil {
                type = _productType
                break
            }
        }
        return type
    }
    
    static func determineBarcodeName(barcodeNo: String, detector: Detector) -> String? {
        var nameDigits = String()
        var name: String?
        
        nameDigits = getNameDigits(barcodeNo: barcodeNo, detector: detector)
        name = getMatchName(for: nameDigits)
        return name
    }
    
    static func getMatchName(for nameDigits: String) -> String? {
        var name: String?
        if let _name = FUDGE_NAMES_FOR_DIGITS[nameDigits] {
            name = _name
        }
        return name
    }
    
    static func determineBarcodePrice(barcodeNo: String, barcodeType: BarcodeType, detector: Detector) -> Float {
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
    
    
    mutating func markIsBeingSent() {
        
        self.isBeingSent = true
        self.isBeingSentDate = datetimeNow()
        self.isBeingSentTimes += 1
//        self.quantity += 1
    }
    
    
    func didOneSecondsPass() -> Bool {

        print("LastSentDate = \(self.isBeingSentDate)")
        print("timeNow = \(datetimeNow())")
        if datetimeNow().timeIntervalSince(self.isBeingSentDate) > 1 {
            debug("ComparisonResult = \(datetimeNow().timeIntervalSince(self.isBeingSentDate))")
            return true
        }
        return false
    }
    
    
    func didTwoSecondsPass() -> Bool {
        
        if datetimeNow().timeIntervalSince(self.isBeingSentDate) > 2 {
            debug("ComparisonResult = \(datetimeNow().timeIntervalSince(self.isBeingSentDate))")
            return true
        }
        return false
    }
    
    
    ///func to update barcode, knowing that we have to barcode labels with same barcodeNo
    mutating func refreshBarcode() {
        
        self.didPassValidation = false
        self.MLKitVisionAPIMatch = false
        self.isBeingSent = false
        self.detectionRating = 0
    }
    
    
    mutating func detectorsDidMatch() {
        self.MLKitVisionAPIMatch = true
        self.didPassValidation = true
    }
    
    
    mutating func updateSentDateAhead(seconds: Double) {
        
        var future = datetimeNow() - seconds
        debug("comparison of sendDate to datetimeNow() + 3 seconds: \(datetimeNow().timeIntervalSince(future)))")
        self.isBeingSentDate = future
    }
    
}

