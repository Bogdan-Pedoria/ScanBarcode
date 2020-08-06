//
//  Globals.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 5/31/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit



/////////////////////////////// SOCKET CONNECTION //////////////////////////////////
let socketClient = SocketClient()
//////////////////////////////////////////////////////////////////////////////////////

// RECTANGLES TO IMAGE RATIO
var screenToImageRatio: (_ imageSize: CGSize) -> Ratio = { imageSize in
            
    let xRatio = UIScreen.main.bounds.maxX / imageSize.width
    let yRatio = UIScreen.main.bounds.maxY / imageSize.height
    
    return Ratio(xRatio: xRatio, yRatio: yRatio)
}

enum cells: String {
    case barcodeCell = "barcodeCell"
}

enum ShutDownReason {
    case serverConnectionError
    case serverErrorAfterConnectionRetries
}


struct Ratio {
    
    var xRatio = CGFloat()
    var yRatio = CGFloat()
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
        Alert.showAlertForServerErrorAfterConnectionRetries(buttonText: "EXIT", completion: { _ in
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


