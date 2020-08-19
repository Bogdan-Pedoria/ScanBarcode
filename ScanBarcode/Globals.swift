//
//  Globals.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 5/31/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit


/* CONSTANTS */
let MIN_DISTANCE_BETWEEN_BARCODES = 325
/* END CONSTANTS */


/////////////////////////////// SOCKET CONNECTION //////////////////////////////////
let socketClient = SocketClient()
//////////////////////////////////////////////////////////////////////////////////////////////////
var historyBarcodes = [Date: [BarcodeData]]()


struct Ratio {
    
    var xRatio = CGFloat()
    var yRatio = CGFloat()
}


enum cells: String {
    case barcodeCell = "barcodeCell"
}

enum ShutDownReason {
    case serverConnectionError
    case serverErrorAfterConnectionRetries
}

/*
                                            Mark: FUNCTIONS
 */
func debug(_ message: String = "emptyMessage", function: String = #function, line: Int = #line, file: String = #file){
    print("\n\n *** \n \(message)\n in:File = \(file)\n unction=\(function), line =\(line) \n ***\n")
}

func shutAppDown(reason: ShutDownReason) {

        
//    Alert.alert(title: "EXITING", message: "Server Connection Failure", accept: "EXIT", acceptAction: { (_) in
//        exit(0)
//    })
    
    switch reason {
    case .serverErrorAfterConnectionRetries:
        Alert.showAlertForServerErrorAfterConnectionRetries(buttonText: "RETRY", completion: { _ in
            exit(0)
            
        })
    default:
        Alert.showExitAlert(message: "EXITING APP FOR UNKNOWN REASON")
    }
}

func convert(_ cmage:CIImage) -> UIImage? {
    let context:CIContext = CIContext(options: nil)
    guard let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent) else { return nil }
    let image:UIImage = UIImage(cgImage: cgImage)
    return image
}


func dateToString(_ date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    return dateFormatter.string(from: date)
}

func formatDateToString(_ date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    dateFormatter.timeStyle = .medium
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: date)
}

func formatStringToDate(_ date: String) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZZZZZ"
    //    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    //    dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
    //    dateFormatter.timeStyle = .medium
    //    dateFormatter.dateStyle = .short
    
    return dateFormatter.date(from: date)
}

func timeStringFromDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func datetimeNow() -> Date {
    let dateInSeconds = Date().timeIntervalSinceReferenceDate
    return Date(timeIntervalSinceReferenceDate: dateInSeconds)
}
