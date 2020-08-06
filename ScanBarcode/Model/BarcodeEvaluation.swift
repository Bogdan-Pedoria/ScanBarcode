//
//  BarcodeEvaluationModel.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 8/5/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation



struct BarcodesFilter {
    
    
//    var filteredBarcodes: [Int: Int]?
    
    
    static func filterAllThatBelowHalfOfBestRating(barcodeNumbersWithRating: [Int: Int]) -> [Int: Int] {
        var bestRating = BarcodesRatingEvaluator.evaluateBestRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        var halfBestRating = bestRating / 2
        return barcodeNumbersWithRating.filter{ $0.value >= halfBestRating }
    }
    
    
    static func filterAllThatBelowErrorTreshold(barcodeNumbersWithRating: [Int: Int], errorPercent: Int) -> [Int: Int] {
        
//        var aveRating = BarcodesRatingEvaluator.evaluateAverageRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
//        var tresholdValue = (aveRating * Double(errorPercent) / 100)
//        return barcodeNumbersWithRating.filter { Double($0.value) >= tresholdValue}
        
        //replacing aveRating with AveBestRating: did not filter errors
        var aveBestRating = BarcodesRatingEvaluator.evaluateAverageBestRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        var tresholdValue = (aveBestRating * Double(errorPercent) / 100)
        return barcodeNumbersWithRating.filter { Double($0.value) >= tresholdValue}
    }
}

struct BarcodesRatingEvaluator {
    
    
    var bestRating: Int // [barcodeNo: Rating]
//    var worstRating: [Int: Int] // [barcodeNo: Rating}
    var averageRating: Double
    var averageBestRating: Double // average rating of ratings above average
    
    
    init(barcodeNumbersWithRating: [Int: Int]) {
        
        bestRating = BarcodesRatingEvaluator.evaluateBestRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        averageRating = BarcodesRatingEvaluator.evaluateAverageRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        averageBestRating = BarcodesRatingEvaluator.evaluateAverageBestRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
    }
    
    
    static func evaluateBestRating(barcodeNumbersWithRating: [Int: Int]) -> Int {
        
        var bestRating = Int()
        var bestBarcode = Int()
        for (barcode, rating) in barcodeNumbersWithRating {
            if bestRating < rating {
                bestRating = rating
                bestBarcode = barcode
            }
        }
        return bestRating
    }
    
    
    static func evaluateAverageRating(barcodeNumbersWithRating: [Int: Int]) -> Double {
        
        var aveRating = Double()
        var ratingSum = Int()
        for (barcode, rating) in barcodeNumbersWithRating {
            ratingSum += rating
        }
        aveRating = Double(ratingSum) / Double(barcodeNumbersWithRating.count)
        return aveRating
    }
    
    
    static func evaluateAverageBestRating(barcodeNumbersWithRating: [Int: Int]) -> Double {
        
        var averageBestRating = Double()
        var sumBestRating = Int()
        var countBestRating = Int()
        var aveRating = evaluateAverageRating(barcodeNumbersWithRating: barcodeNumbersWithRating)
        for (barcode, rating) in barcodeNumbersWithRating {
            if Double(rating) >= aveRating {
                sumBestRating += rating
                countBestRating += 1
            }
        }
        averageBestRating = Double(sumBestRating) / Double(countBestRating)
        return averageBestRating
    }
}
