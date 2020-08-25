//
//  DrawShapesVCExt.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/30/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit



struct BorderRectangle {
    
    let topBorderHeight = CGFloat(160)
    let bottomBorderHeight = CGFloat(160)
    let fullHeight = CGFloat(400)
    let sideWidth = CGFloat(80)
    let fullWidth = UIScreen.main.bounds.width
    let tag = "ScanBorder"
    let fakeCroppingRect = CGRect(x: UIScreen.main.bounds.origin.x + 80, y: UIScreen.main.bounds.origin.y + 160, width: UIScreen.main.bounds.width - 160, height: CGFloat(400) - 320)
    
    func getLeftSideBorderRect() -> CGRect {
        return CGRect(x: UIScreen.main.bounds.width - sideWidth, y: UIScreen.main.bounds.origin.y, width: sideWidth, height: fullHeight)
    }
}


extension ViewController {
    
    
    
    func drawSingeScanModeBorder() {
    
        let leftSideBorderRect = CGRect(x: UIScreen.main.bounds.width - borderRectangle.sideWidth, y: UIScreen.main.bounds.origin.y, width: borderRectangle.sideWidth, height: self.borderRectangle.fullHeight)
        
        let topBorderRect = CGRect(x: UIScreen.main.bounds.origin.x + CGFloat(borderRectangle.sideWidth), y: UIScreen.main.bounds.origin.y, width: borderRectangle.fullWidth - CGFloat(borderRectangle.sideWidth * 2), height: CGFloat(self.borderRectangle.topBorderHeight))
        
        let bottomBorderRect = CGRect(x: UIScreen.main.bounds.origin.x + CGFloat(borderRectangle.sideWidth), y: CGFloat( borderRectangle.fullHeight - borderRectangle.bottomBorderHeight), width: borderRectangle.fullWidth - CGFloat(borderRectangle.sideWidth * 2), height: CGFloat(self.borderRectangle.bottomBorderHeight))
        
        let rightSideBorderRect = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: borderRectangle.sideWidth, height: self.borderRectangle.fullHeight)
        
        let tag = self.borderRectangle.tag
        
        self.drawRect(rectangle: rightSideBorderRect, lineWidth: 0, fillColor: .init(gray: .init(0.5), alpha: 0.5), tag: tag)
        
        self.drawRect(rectangle: leftSideBorderRect, lineWidth: 0, fillColor: .init(gray: .init(0.5), alpha: 0.5), tag: tag)
        
        self.drawRect(rectangle: topBorderRect, lineWidth: 0, fillColor: .init(gray: .init(0.5), alpha: 0.5), tag: tag)
        
        self.drawRect(rectangle: bottomBorderRect, lineWidth: 0, fillColor: .init(gray: .init(0.5), alpha: 0.5), tag: tag)
        
        self.drawRect(rectangle: self.borderRectangle.fakeCroppingRect, lineWidth: 1, lineColor: .init(gray: .init(1), alpha: 0.5), fillColor: nil, tag: tag)
    }
    
    // RECTANGLES TO IMAGE RATIO
    func screenToImageRatio (_ imageSize: CGSize) -> Ratio {
                
        let xRatio = UIScreen.main.bounds.maxX / imageSize.width
        let yRatio = UIScreen.main.bounds.maxY / imageSize.height
        
        return Ratio(xRatio: xRatio, yRatio: yRatio)
    }
    
    // RECTANGLES TO IMAGE RATIO
    func imageToScreenRatio(_ imageSize: CGSize) -> Ratio {
                
        let xRatio = imageSize.width / UIScreen.main.bounds.maxX
        let yRatio = imageSize.height / UIScreen.main.bounds.maxY
        
        return Ratio(xRatio: xRatio, yRatio: yRatio)
    }
    
    
    func markDetectedArea(barcodeFrame: CGRect, barcodeNo: Int) {
        
        let newRatio = screenToImageRatio(CGSize(width: 1080, height: 1920))
        var rectResizedAccordingToScreenSize = self.resizeRect(barcodeFrame, withRatio: newRatio)
        
        // important: manually resizing rectangle because trying to finish fast
        #warning("TODO: Stop resizing rectangle manually. Remove the following and replace with better logic")
        if self.singleScanMode {
            rectResizedAccordingToScreenSize = CGRect(x: rectResizedAccordingToScreenSize.origin.x + 80, y: rectResizedAccordingToScreenSize.origin.y + 120, width: rectResizedAccordingToScreenSize.width, height: rectResizedAccordingToScreenSize.height)
        }
        
        if let barcode = MLBarcodes[barcodeNo] {
            var barcodePrice = Double(barcode.barcodePrice)
            barcodePrice = roundToHundredth(number: barcodePrice)
            self.addPriceLabel(withText: String(barcodePrice), in: rectResizedAccordingToScreenSize, barcodeNo: barcodeNo)
        }
        self.drawRectangleForBarcode(rectangle: rectResizedAccordingToScreenSize, barcodeNo: barcodeNo)
    }
    
    
    
    func drawRect(rectangle: CGRect, lineWidth: CGFloat, lineColor: CGColor? = nil, fillColor: CGColor? = nil, tag: String?=nil) {
        
        DispatchQueue.main.async {
            let rectLayer = CAShapeLayer()
            rectLayer.path = UIBezierPath(roundedRect: rectangle, cornerRadius: 0).cgPath
            rectLayer.strokeColor = lineColor
            rectLayer.lineWidth = lineWidth
            rectLayer.fillColor = fillColor
            rectLayer.accessibilityValue = tag
            self.view.layer.insertSublayer(rectLayer, below: self.scanBtn.layer)
            self.view.layer.insertSublayer(rectLayer, below: self.counterButton.layer)
        }
    }
    
    
    func drawRectangleForBarcode(rectangle: CGRect, barcodeNo: Int) {
        
        #warning("TODO: very wrong, did it trying to finish fast: HAS TO REDO ALL LAYOUTS BY USING CONSTRAINTS AND RESTORE THEIR SIZES")
        var rect = rectangle
        DispatchQueue.main.async {
            let rectLayer = CAShapeLayer()
            rectLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).cgPath
            rectLayer.strokeColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    //        rectLayer.backgroundColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.0)
    //        rectLayer.fillColor = nil
            rectLayer.fillColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 0.3)
            
            for (i, subView) in self.view.subviews.enumerated() {
                // a way to make sure a price label is gone, because all of them have barcodeNo in tag
                if /*self.barcodeNumbersWithRating[subView.tag] != nil &&*/ self.rectanglesForBarcodes[subView.tag] != nil {
                    self.view.layer.insertSublayer(rectLayer, below: subView.layer/*self.previewLayer*/)
                }
            }
            //to save rectangle to be able to remove it later
            self.rectanglesForBarcodes[barcodeNo] = rectLayer.hashValue
//            rectLayer.accessibilityValue = String(barcodeNo)
//    debug(" accessebility value \(String(describing: rectLayer.accessibilityValue))")
        }
    }
    
    
    func makeAnnotationRect(from rect: CGRect) -> CGRect {
        
        let newRectHeight = CGFloat(self.annotationRectangleHeight)
        let newRectWidth = rect.width
        let newRectY = rect.origin.y - newRectHeight + 120
        let newRectX = rect.origin.x + 80
        let newRect = CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
        
        return newRect
    }
        
        
    func addPriceLabel(withText text: String, in rect/*angle*/: CGRect, barcodeNo: Int) {
        
        DispatchQueue.main.async {
//            let rect = self.makeAnnotationRect(from: rectangle)
            //CREATING LABEL
            let label = UILabel(frame: rect)
            
            // SETTING TEXT
            label.text = "$\(text)"
            label.font = UIFont.boldSystemFont(ofSize: 20)
    //        label.numberOfLines = 0 // WRAPING TEXT
            label.textAlignment = .left
            label.sizeToFit()
            
            // COLORING
            let labelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            label.backgroundColor = labelColor
            label.textColor = .white
            label.tag = barcodeNo
            
            // ADDING LABEL
            self.view.insertSubview(label, belowSubview: self.tableView)
//            for (i, layer) in self.view.layer.sublayers!.enumerated() {
//                for (barcodeNo, hashValue) in self.rectanglesForBarcodes {
//                    if hashValue == layer.hashValue {
//                        self.view.insertSubview(label, belowSubview: self.tableView)
//                    }
//                }
//            }
        }
    }
    
    
    func removeVisualBarcodeMarks(barcodeNo: Int/*, layerHashValue: Int*/) {
        
        if let layerHashValue = rectanglesForBarcodes[barcodeNo] {
            self.removeBarcodeRectangle(layerHashValue: layerHashValue)
            self.removePriceAnnotation(barcodeNo: barcodeNo)
        }
    }

    
    func removeBarcodeRectangle(layerHashValue: Int) {
        
        DispatchQueue.main.async {
            if let sublayers = self.view.layer.sublayers {
                for (i, layer) in sublayers.enumerated() {
                    if layer.isKind(of: CAShapeLayer.self) {
//                        self.view.layer.sublayers![i].removeFromSuperlayer()
                        if layer.hashValue == layerHashValue {
                            layer.removeFromSuperlayer()
//                            self.view.layoutSubviews()
//                            self.view.layoutIfNeeded()
//                            self.rectanglesForBarcodes.removeValue(forKey: barcodeNo)
                        }
                    }
                }
            }
        }
    }
    
    
    func removePriceAnnotation(barcodeNo: Int) {
    
        DispatchQueue.main.async {
            for (i, subView) in self.view.subviews.enumerated() {
                if (subView.viewWithTag(barcodeNo) != nil) {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    
   @objc func removeAllDrawings() {
        
        DispatchQueue.main.async {
//            if self.isScanning {
                // DELETING PRICE LABELS
                for (i, subView) in self.view.subviews.enumerated() {
                    // a way to make sure a price label is gone, because all of them have barcodeNo in tag
                    if self.barcodeNumbersWithRating[subView.tag] != nil {
                        subView.removeFromSuperview()
                    }
                }
                // DELETING BARCODE RECRTNGLES
            if let sublayers = self.view.layer.sublayers {
                for (i, layer) in sublayers.enumerated() {
                    if layer.isKind(of: CAShapeLayer.self) {
                        if !self.singleScanMode {
                            layer.removeFromSuperlayer()
                            continue
                        }
                        for (No, hashValue) in self.rectanglesForBarcodes {
                            if hashValue == layer.hashValue {
                                layer.removeFromSuperlayer()
                            }
                        }
                    }
                }
//                }
            }
        }
    }
    
    
    func removeScanBorder() {
        DispatchQueue.main.async { [weak self] in
            if let sublayers = self?.view.layer.sublayers {
                for (i, layer) in sublayers.enumerated() {
                    if layer.isKind(of: CAShapeLayer.self) {
                        if self?.borderRectangle.tag == layer.accessibilityValue {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
        }
    }
    
    
//    ////////////////// JUST A TRY FUNC TO SHOW HOW AN OBJECT CAN BE DRAWN /////////////
//    func addPointlessCircle() {
//
//        // ADD CIRCLE
//        let circleLayer = CAShapeLayer()
//        let radius: CGFloat = 50.0
//        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
//        circleLayer.position = CGPoint(x: 200, y: 200)
////            circleLayer.fillColor = UIColor.blue.cgColor
//        self.view.layer.insertSublayer(circleLayer, above: previewLayer)
//    }
//    ///////////////////////////////////////////////////////////////////////////////
    
    
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
    
    
    func drawActualScanningArea() {
        
        self.drawRect(rectangle: self.singleScanModeCroppingRect, lineWidth: CGFloat(2), lineColor: CGColor(red: 0, green: 1, blue: 0, alpha: 0.5))
    }
}
