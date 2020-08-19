//
//  Point.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 8/15/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation


struct Point: Codable {
    
    let x: Int
    let y: Int
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    /// DISTANCE MEASURED IN POINTS, THAT IS WHY RETURNS INTEGER
    static func measureDistanceBetweenPoints(_ point1: Point, _ point2: Point) -> Int {
        
        let distance = Int() // debug
        #warning("TODO: IMPLEMENT FUNCTION MATHEMATICALLY")
        return distance
    }
    
}
