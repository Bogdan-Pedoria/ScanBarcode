//
//  Math.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/5/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation


///////////////////////////////////// func: roundToHundredth /////////////////////////
func roundToHundredth(number: Float) -> Float {
    return (number * 1000000 / 10000).rounded() / 100
}
//////////////////////////////////////////////////////////////////////////////////////


func roundToHundredth(number: Double) -> Double {
    return (number * 1000000 / 10000).rounded() / 100
}


func makeIntThatIsOldButAllDigitsAreZerosWith1InFront(oldInt: Int) -> Int {
    
    let strOldInt = String(oldInt)
    var strNewInt = "1"
    for _ in strOldInt {
        strNewInt.append("0")
    }
    let newInt = Int(strNewInt)!
    return newInt
}
