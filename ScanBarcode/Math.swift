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
