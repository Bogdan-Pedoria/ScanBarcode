//
//  ButtonSetup.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/3/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController {
    

    func setupChangeModeButton(x: Int=0, y: Int=0) {
        
        changeModeButton.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(50), height: CGFloat(self.buttonsHeight))
        changeModeButton.layer.cornerRadius = 0.5 * counterButton.bounds.size.width
        changeModeButton.clipsToBounds = true
        changeModeButton.addTarget(self, action: #selector(changeModeButtonTapped), for: .touchUpInside)
        changeModeButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        changeModeButton.setTitle("M", for: .normal)
        changeModeButton.setTitleColor(.white, for: .normal)
        
//        self.view.addSubview(changeModeButton)
//        self.view.bringSubviewToFront(changeModeButton)
        //REPLACING WITH
//        self.sideMenu.childView.addSubview(changeModeButton)
        //REPLACING WITH
        if self.sideMenu.buttons != nil {
            self.sideMenu.buttons.append(changeModeButton)
        }
    }
    
    @objc func changeModeButtonTapped() {
        
        debug("ChangeModeButtonTapped")
        if self.singleScanMode {
            self.singleScanMode = false
            self.setupFullScreenDetectionModeView()
            
        }
        else {
            self.singleScanMode = true
            self.setupSingleBarcodeDetectionModeView()
        }
        // had to do it here for now
        // TODO: REDO
        self.view.bringSubviewToFront(self.sideMenu)
        self.sideMenu.showOrHide()
    }
    
    
    // TODO: EVERYTHING IS WRONG, USE ANCHORS OR CONSTARINTS (UIVIEWAUTOLAYOUT), NOT FRAMES
    func setupScanButton(x: Int, y: Int, width: Int) {
        self.scanBtn.frame = CGRect(x: x, y: y, width: width, height: self.buttonsHeight)
//        sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        self.scanBtn.layer.cornerRadius = 10
        self.scanBtn.clipsToBounds = true
//        sendButton.setImage(UIImage(named: "NAME"), for: .normal)
        self.scanBtn.addTarget(self, action: #selector(scanButtonPressed), for: .touchDown)
        self.scanBtn.addTarget(self, action: #selector(scanButtonUnpressed), for: .touchUpInside)
        self.scanBtn.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
        self.scanBtn.setTitleColor(.black, for: .normal)
        self.scanBtn.setTitle("HOLD TO SCAN", for: .normal)
        self.scanBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(scanBtn)
        self.view.bringSubviewToFront(scanBtn)
    }
    
    ///////////////////////////// START SCANNING /////////////////////////////////////////
    @objc func scanButtonPressed() {
        
        if !doNotRemoveBarcodes {
            self.removeCurrentBarcodes()
        }
        else {
            self.doNotRemoveBarcodes = false
        }
        self.isScanning = true
    }
    ///////////////////////////////////////////////////////////////////////////////////////
    
    
    ///////////////////////////// STOP SCANNING /////////////////////////////////////////
    @objc func scanButtonUnpressed() {
        
        self.isScanning = false
        if self.singleScanMode {
//            Alert.didYouFinishTransactionAlert(on: self, acceptAction: { [weak self] (UIAlertAction) in
//                self?.saveAndDeleteMLBarcodes()
//                self?.updateCounterButton()
//                }, skipAction: { [weak self] (UIAlertAction) in
//            })
        }
        else {
//            self.sendButtonTapped()
//            self.counterButtonTapped()
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////
    
    
//    func bringButtonsToFront() {
//        
//        self.view.bringSubviewToFront(self.scanBtn)
//    }self
    
//    @objc func startStopButtonTapped() {
//
//        print("StartStopBtnTapped")
//
//        if self.isScanning {
//            self.isScanning = false
////            self.stopCamera()
//            self.startStopButton.setTitle("START", for: .normal)
//            self.startStopButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
//        }
//        else if !self.isScanning {
//            self.isScanning = true
////            self.startCamera()
//            self.startStopButton.setTitle("STOP", for: .normal)
//            self.startStopButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
////            self.startStopButton.setTitleColor(.white, for: .normal)
//        }
//    }

    
    // EVERYTHING IS WRONG, USE ANCHORS OR CONSTARINTS (UIVIEWAUTOLAYOUT), NOT FRAMES
    func setupSendButton(x: Int, y: Int) {
        if self.singleScanMode {
            sendButton.removeFromSuperview()
            return
        }
        sendButton.frame = CGRect(x: x, y: y, width: self.sendButtonWidth, height: self.buttonsHeight)
//        sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        sendButton.layer.cornerRadius = 10
        sendButton.clipsToBounds = true
//        sendButton.setImage(UIImage(named: "NAME"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        sendButton.setTitle("SEND", for: .normal)
        self.view.addSubview(sendButton)
        self.view.bringSubviewToFront(sendButton)
    }
    
    
    @objc func sendButtonTapped() {
        
        print("Send BUtton Tapped")
        AudioServicesPlayAlertSound(SystemSoundID(1211))
        guard socketClient.connectionIsEstablished else { return }
        guard MLBarcodes.count != 0 else { return }
        // TODO: REMOVE DO CATCH OR ALERT BECAUSE IF JSONEncoder FAILS IT MEANS IT IS THE CODE IS WRONG. OTHERWISE IT WONT HAPPEN. DONE!
        
//        do {
        var mlBarcodesCopy = [Int: BarcodeData]()
        if let mlBarcodesCopy = self.filterBarcodesToSend() {
            let jsonData = BarcodeData.encodeBarcodes(barcodes: mlBarcodesCopy)
            
                socketClient.sendData(jsonData)
//            if singleScanMode {
//                AudioServicesPlayAlertSound(SystemSoundID(1211))//touch tone pound('#') key: it is vibrating, but maybe it is good to stop detection that way by messing up focus?
                #warning("DO I NEED THIS?(the following: updateCounter and reloadTable")
//            }
    //            updateCounterButton()
    //            self.reloadTableView()
            for (barcodeNo, barcode) in mlBarcodesCopy {
                self.MLBarcodes[barcodeNo]!.markIsBeingSent()
            }
            self.reloadTableView()
            /// SHOWING BARCODES SENT ALERT
            if !self.singleScanMode {
//                DispatchQueue.global(qos: .background).async {
//                    AudioServicesPlayAlertSound(SystemSoundID(1108))
                    Alert.showBarcodesSentAlert()
//                }
            }
        }
        else {
            
            Alert.showAlert(withTitle: "DATA DID NOT SEND", message: "NothingToSendError. Try rescanning")
        }
            
            /// STOPPING SCANNER
//            self.isScanning = false // was probably messing up scanning process
//            if self.isScanning {
//                self.scanBtn.sendActions(for: .touchUpInside)
//            }
            /// UPDATING TABLE VIEW
//            MLBarcodes.removeAll()
//            MLBarcodes.map { $0.value.isBarcodeSent = true }
//            self.markSentAllBarcodes()
//        }
//        catch {
////            Alert.showAlert(withTitle: "ERROR", message: "COULD NOT ENCODE BARCODE DATA")
//            print(error.localizedDescription)
//            return
//        }
        
    }
    
    
    // EVERYTHING IS WRONG, USE ANCHORS OR CONSTARINTS (UIVIEWAUTOLAYOUT), NOT FRAMES
    func setupCounterButton(x: Int=0, y: Int=0) {
        
//        counterButton.frame = CGRect(x: 0, y: 350, width: 50, height: 50)
        counterButton.frame = CGRect(x: x, y: y, width: 50, height: 50)
        counterButton.layer.cornerRadius = 0.5 * counterButton.bounds.size.width
        counterButton.clipsToBounds = true
        counterButton.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        counterButton.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        counterButton.setTitle(String(MLBarcodes.count), for: .normal)
        counterButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(counterButton)
        self.view.bringSubviewToFront(counterButton)
    }
    
    
    func updateCounterButton() {
        var count = Int()
        if self.singleScanMode {
            #warning("TODO: REDO? count according to number of duplicates too, if you will complete it right")
            for (barcodeNo, barcodeData) in self.MLBarcodes {
                
                if barcodeData.isBeingSentTimes > 1 {
                    count += barcodeData.isBeingSentTimes
                }
                else {
                    count += 1
                }
            }
        }
        else {
            count = self.barcodesForTableView.count
            // DEBUG
            if count > 4 {
                debug("Count > 4")
            }
        }
        counterButton.setTitle(String(count), for: .normal)
//        counterButton.setTitle("?", for: .highlighted)
        counterButton.titleLabel?.text = String(count)
        debug("COUNT = \(count), counterBtn.title = \(counterButton.titleLabel?.text)")
    }
    
    
    /*
     FUNCTION TO LIFT UP TABLE VIEW TO THE TOP OF THE SCREEN
     */
    @objc func counterButtonTapped() {
        
        print("CounterButton tapped")
        // new functionality
        self.saveCurrentBarcodes()
        self.removeCurrentBarcodes()
        self.updateCounterButton()
        
        // old functionality: change scanner modes
//        if self.tableView.frame.origin.y == CGFloat(tableViewSingleScanModeHeight) {
//            self.setupFullScreenDetectionModeView()
//        }
            
        // EVEN TAPS OF THE BUTTON TO FOLD TABLEVIEW DOWN, BACK TO INITIAL POSITION
//        else if self.tableView.frame.origin.y == CGFloat(tableViewFullScreenScanModeHeight) {
//            self.setupSingleBarcodeDetectionModeView()
//        }
        
    }
    

    
    
    func markSentAllBarcodes() {
        
        for (barcodeNo, barcodeData) in MLBarcodes {
            MLBarcodes[barcodeNo]?.markIsBeingSent()
        }
    }
}
