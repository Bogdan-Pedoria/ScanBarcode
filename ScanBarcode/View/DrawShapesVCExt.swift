//
//  DrawShapesVCExt.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/30/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit



extension ViewController {
    
    
    func markDetectedArea(barcodeFrame: CGRect, barcodeNo: String) {
        
        let newRatio = screenToImageRatio(CGSize(width: 1080, height: 1920))
        let rectResizedAccordingToScreenSize = self.resizeRect(barcodeFrame, withRatio: newRatio)
            
        self.drawRectangle(rectangle: rectResizedAccordingToScreenSize)
        if let barcode = MLBarcodes[Int(barcodeNo)!] {
            var barcodePrice = Double(barcode.barcodePrice)
            barcodePrice = roundToHundredth(number: barcodePrice)
            self.drawPriceAbove(rectangle: rectResizedAccordingToScreenSize, price: barcodePrice)
        }
    }
    
    
    func drawRectangle(rectangle: CGRect) {
        
//        print(self.view.layer.sublayers)
        
        let rectLayer = CAShapeLayer()
        rectLayer.path = UIBezierPath(roundedRect: rectangle, cornerRadius: 0).cgPath
        rectLayer.strokeColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 0.5)
//        rectLayer.backgroundColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.0)
        rectLayer.fillColor = nil
        self.view.layer.insertSublayer(rectLayer, above: previewLayer)
    }
    
    
    func drawPriceAbove(rectangle: CGRect, price: Double) {
        
        let annotationRect = makeAnnotationRect(from: rectangle)
        addAnnotationLabel(withText: String(price), rect: annotationRect)
    }
    
    
    func makeAnnotationRect(from rect: CGRect) -> CGRect {
        
        let newRectHeight = CGFloat(self.annotationRectangleHeight)
        let newRectWidth = rect.width
        let newRectY = rect.origin.y - newRectHeight
        let newRectX = rect.origin.x
        let newRect = CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
        
        return newRect
    }
        
        
    func addAnnotationLabel(withText text: String, rect: CGRect) {
        
        //CREATING LABEL
        let label = UILabel(frame: rect)
        
        // SETTING TEXT
        label.text = text
//        label.numberOfLines = 0 // WRAPING TEXT
        label.textAlignment = .left
        label.sizeToFit()
        
        // COLORING
        let labelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        label.backgroundColor = labelColor
        label.textColor = .white
        label.tag = 100
        
        // ADDING LABEL
        self.view.insertSubview(label, aboveSubview: self.previewView)
    }
    

    func removeMarkingRectangles() {
        
        DispatchQueue.main.async {
            if let sublayers = self.view.layer.sublayers {
                for (i, layer) in sublayers.enumerated() {
                    if layer.isKind(of: CAShapeLayer.self) {
//                        self.view.layer.sublayers![i].removeFromSuperlayer()
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    
    func removePriceAnnotations() {
    
        DispatchQueue.main.async {
            for (i, subView) in self.view.subviews.enumerated() {
                if (subView.viewWithTag(self.subviewDeletionTag) != nil) {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    
    ////////////////// JUST A TRY FUNC TO SHOW HOW AN OBJECT CAN BE DRAWN /////////////
    func addPointlessCircle() {
        
        // ADD CIRCLE
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = 50.0
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: 200, y: 200)
//            circleLayer.fillColor = UIColor.blue.cgColor
        self.view.layer.insertSublayer(circleLayer, above: previewLayer)
    }
    ///////////////////////////////////////////////////////////////////////////////
    
    
    func resizeRect(_ rect: CGRect, withRatio ratio: Ratio) -> CGRect {
        
        // GETTING NEW RECT DIMENSIONS
        let newWidth = rect.width * ratio.xRatio
        let newHeight = rect.height * ratio.yRatio
        let newXOrigin = rect.origin.x * ratio.xRatio
        let newYOrigin = rect.origin.y * ratio.yRatio
        
        //CREATING NEW RECTANGLE
        let newRect = CGRect(x: newXOrigin, y: newYOrigin, width: newWidth, height: newHeight)
        
        return newRect
    }
}
