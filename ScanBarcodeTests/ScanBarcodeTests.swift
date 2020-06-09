//
//  ScanBarcodeTests.swift
//  ScanBarcodeTests
//
//  Created by Bohdan Pedoria on 4/12/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import XCTest
@testable import ScanBarcode
import Firebase

class ScanBarcodeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(BarcodeData(barcodeNo: "203381424087", id: 0, detector: .MLKit).productName == "Tiger Fudge")
        XCTAssertEqual(BarcodeData(barcodeNo: "208162422887", id: 0, detector: .MLKit).productName, "Chocolate Cheesecake Fudge")
        XCTAssertEqual(BarcodeData(barcodeNo: "208262422887", id: 0, detector: .MLKit).productName, "NO NAME")
    }
    
    func testGetPrice() throws {
        print(BarcodeData(barcodeNo: "203381705391", id: 0, detector: .MLKit).barcodePrice)
        XCTAssertEqual(BarcodeData(barcodeNo: "208262422887", id: 0, detector: .MLKit).barcodePrice, 22.88)
        XCTAssertEqual(BarcodeData(barcodeNo: "203381705391", id: 0, detector: .MLKit).barcodePrice, 5.39)
        XCTAssertEqual(BarcodeData(barcodeNo: "208078706118", id: 0, detector: .MLKit).barcodePrice, 6.11)
        
        //Vision API
        XCTAssertEqual(BarcodeData(barcodeNo: "0208262422887", id: 0, detector: .VisionAPI).barcodePrice, 22.88)
        XCTAssertEqual(BarcodeData(barcodeNo: "0203381705391", id: 0, detector: .VisionAPI).barcodePrice, 5.39)
        XCTAssertEqual(BarcodeData(barcodeNo: "0208078706118", id: 0, detector: .VisionAPI).barcodePrice, 6.11)
    }
    
    func testGetBarcodeType() throws {
        var type = BarcodeData.determineBarcodeType(barcodeNo: "208078706118")
        XCTAssertEqual(type, BarcodeType.EAN8)
        type = BarcodeData.determineBarcodeType(barcodeNo: "203381705391")
        XCTAssertEqual(type, BarcodeType.EAN8)
        type = BarcodeData.determineBarcodeType(barcodeNo: "208262422887")
        XCTAssertEqual(type, BarcodeType.EAN8)
        type = BarcodeData.determineBarcodeType(barcodeNo: "20807870611")
        XCTAssertEqual(type, BarcodeType.unknown)
        type = BarcodeData.determineBarcodeType(barcodeNo: "20807870b118")
        XCTAssertEqual(type, BarcodeType.unknown)


    }
    
    func testDetermineProductType() throws {
        print(BarcodeData(barcodeNo: "203381705391", id: 0, detector: .MLKit).productType)
        
        //MLKit
        XCTAssertNotEqual(BarcodeData(barcodeNo: "208262422887", id: 0, detector: .MLKit).productType, ProductType.Fudge)
        XCTAssertEqual(BarcodeData(barcodeNo: "203381705391", id: 0, detector: .MLKit).productType, ProductType.Fudge)
        XCTAssertEqual(BarcodeData(barcodeNo: "208078706118", id: 0, detector: .MLKit).productType, ProductType.Fudge)
        
        // WRONG MLKit
        XCTAssertNotEqual(BarcodeData(barcodeNo: "808262422887", id: 0, detector: .MLKit).productType, ProductType.Fudge)
        XCTAssertEqual(BarcodeData(barcodeNo: "803381705391", id: 0, detector: .MLKit).productType, ProductType.Fudge)
        XCTAssertEqual(BarcodeData(barcodeNo: "808078706118", id: 0, detector: .MLKit).productType, ProductType.Fudge)
        
        //Vision API
        XCTAssertNotEqual(BarcodeData(barcodeNo: "0208262422887", id: 0, detector: .VisionAPI).productType, ProductType.Fudge)
        XCTAssertEqual(BarcodeData(barcodeNo: "0203381705391", id: 0, detector: .VisionAPI).productType, ProductType.Fudge)
        XCTAssertEqual(BarcodeData(barcodeNo: "0208078706118", id: 0, detector: .VisionAPI).productType, ProductType.Fudge)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            BarcodeData(barcodeNo: "208162422887", id: 0, detector: .MLKit)
        }
    }

}
