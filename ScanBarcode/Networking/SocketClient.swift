//
//  SocketServer.swift
//  Restaurant
//
//  Created by Bohdan Pedoria on 1/24/19.
//  Copyright © 2019 Bohdan Pedoria. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation

class SocketClient: NSObject, StreamDelegate{
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    var MAX_READ_LENGTH = 2048
    var PORT = 8018
    var IP = "192.168.137.1"
    private var reconnect_tries = 1 // CHANGE TO FIVE
    private var lastSentData: Data?
    var connectionIsEstablished = Bool()
    var timer = Timer()
    
    init(ip: String?=nil) {
        super.init()
//        self.ip = ip
//        self.ip = self.ip
//        self.checkIfConnectionIsNotEstablishedInFiveSeconds()
    }
    
//    init(ip: String, port: Int, maxReadLength: Int, appName: String){
//        self.ip = ip
//        self.port = port
//        self.maxReadLength = maxReadLength
//        self.appName = appName
//        self.socketURL = URL(string: "\(ip):\(port)")!
//        print("DEBUG: SOCKET url = \(self.socketURL)")
//        debug(String(describing: socketURL))
//    }
    
    @objc private func checkIfConnectionIsNotEstablished() {
debug("DEBUG: outputStream \(outputStream?.streamStatus),\n inputStream \(inputStream?.streamStatus)")
debug("DEBUG: outputStream \(outputStream?.streamStatus.rawValue),\n inputStream \(inputStream?.streamStatus.rawValue)")
        if !self.connectionIsEstablished {
            if !timer.isValid {
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.askToReconnectOrExit), userInfo: nil, repeats: false)
            }
            else {
            }
        }
        else if self.connectionIsEstablished {
            timer.invalidate()
        }
        else {
            
        }
    }
    
    func setupNetworkCommunication() {
        // 1
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           IP as CFString,
                                           UInt32(PORT),
                                           &readStream,
                                           &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        inputStream.open()
        outputStream.open()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.checkIfConnectionIsNotEstablished), userInfo: nil, repeats: false)
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            debug("new message received")
            readAvailableBytes(inputStream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            debug("new message received")
        case Stream.Event.errorOccurred:
            debug("\nCONNECTION ERROR OCCURED\n PROBABLY SERVER IS DOWN")
            self.askToReconnectOrExit()
        case Stream.Event.hasSpaceAvailable:
            debug("has space available")
        default:
//            Alert.connectionIsEstablishedAlert()
            debug("CONNECTION IS ESTABLISHED")
            self.connectionIsEstablished = true
            self.reconnect_tries = 1
            break
        }
    }
    
    private func readAvailableBytes(inputStream: InputStream) {
        //1
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: MAX_READ_LENGTH)
        //2
        while inputStream.hasBytesAvailable {
            //3
            let numberOfBytesRead = inputStream.read(buffer, maxLength: MAX_READ_LENGTH)
            
            //4
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    break
                }
            }
            
            //Construct the Message object
            guard let stringArray = String(bytesNoCopy: buffer,
                                           length: numberOfBytesRead,
                                           encoding: .utf8,
                                           freeWhenDone: true)?.components(separatedBy: "&")
                else {
                    break
            }
            
//remove
debug("\nstringArray = \(stringArray[0])")
            
            // 503 service unavailable
            // The server cannot handle the request (because it is overloaded or down for maintenance) (Wikipedia)
            if stringArray[0] == "503" { // LENGTH OF DATA GOT MESSED UP and got decoded as MORE THAN 9.99 MB
                Alert.showAlert(withTitle: "DATA DID NOT SEND", message: "Internal Server Error. Try rescanning")
                self.askToReconnectOrExit()
            }
            
            // 500 Internal Server Error
            //A generic error message, given when an unexpected condition was encountered and no more specific message is suitable (WIKIPEDIA)
            else if stringArray[0] == "500" { //SERVER COULD NOT DECODE JSON
                // TODO: REVIEW AND ADD TRY CATCH OR THROW ERROR OR MAKE SERVER SENT BETTER ERROR MESSAGES OR DO ANYTHING TO MAKE IT BETTER
                // RESEND ON YOUR OWN -- BECAUSE IT HAPPENS SOMETIMES, AND AFTER RESENDING, ASK USER TO RESAND OR RESCAN
                if let sentData = lastSentData {
                    self.sendData(sentData)
                    lastSentData = nil
                }
                else {
                    //TODO: SHOW ALERT -- update Alert to have relative to this case alert
                    Alert.showAlert(withTitle: "DATA DID NOT SEND", message: "Try rescanning")
                }
            }
            else { //success? probably ot
                
            }
        }
    }
  
    func sendData(_ data: Data) {
        
        lastSentData = data
        ///////////// SENDING  WITH LENGTH /////////////
        ////////////////////
debug("DEBUG: SENDING SIZE.\nDEBUG: in Socket.sendData(): data weight = \(data.count)\n data = \(data)")
        /////////////////////
        let dataSize: Int = data.count
        var size = withUnsafeBytes(of: dataSize.bigEndian, Array.init)//MAC AND WINDOWS HAS LITTLE ENDIAN. JUST NOTICE. SENDING AND RECEIVING BIG ENDIAN JUST BECAUSE.
        let Size = Data(bytes: &size, count: MemoryLayout.size(ofValue: dataSize))

        let lengthDataArray = [UInt8](Size)
//        outputStream.write(lengthDataArray, maxLength: lengthDataArray.count)

        let dataArray = [UInt8](data)
        let altogether = lengthDataArray + dataArray
//        outputStream.write(altogether, maxLength: dataArray.count) //SUCH A COVARD ERROR. LEFT FOR MEMORY.
        outputStream.write(altogether, maxLength: altogether.count)
        
//        AudioServicesPlayAlertSound(SystemSoundID(1211))
        //SIMPLE WAY no length is being sent -- unreliable
//        let dataArray = [UInt8](data)
//        outputStream.write(dataArray, maxLength: dataArray.count)
    }
    
    
    func closeSocket() {
        debug("DEBUG: outputStream \(outputStream?.streamStatus),\n inputStream \(inputStream?.streamStatus)")
        debug("DEBUG: outputStream \(outputStream?.streamStatus.rawValue),\n inputStream \(inputStream?.streamStatus.rawValue)")
        if connectionIsEstablished {
            let closingKey = "\0\0\0\0".data(using: .utf8)!
            self.sendData(closingKey)
        }
        inputStream.close()
        outputStream.close()
        inputStream.remove(from: .current, forMode: .common)
        outputStream.remove(from: .current, forMode: .common)
        if !((outputStream?.streamStatus) != nil) && !((inputStream?.streamStatus) != nil) {
        }
    }
    
    @objc func askToReconnectOrExit() {
        
        
//            shutAppDown(reason: ShutDownReason.serverErrorAfterConnectionRetries)
        Alert.alert(title: "Connection Error", message: "Could Not Connect To Your Register", accept: "Retry", cancel: "EXIT", acceptAction: { [self](UIAlertAction) in
            self.reconnect_tries += 1
            self.tryToReconnect()
            debug("IN ALERT ACCEPT BUTTON: TryingToReconnect()")
        }, cancelAction: { (UIAlertAction) in
            exit(SYS_exit)
        })
    }
    
    func tryToReconnect() {
        
        
        debug("TRYING TO RECONNECT...")
//        self.connectionIsEstablished = false
        if self.reconnect_tries > 0 {
            self.closeSocket()
            self.setupNetworkCommunication()
            self.reconnect_tries -= 1
            debug("Reconnect tries left: \(socketClient.reconnect_tries)\n")
        }
        else {
            Alert.alert(title: "Could Not Reconnect", message: "Could Not Reconnect To Your Register", cancel: "EXIT", cancelAction: { (UIAlertAction) in
                exit(SYS_exit)
            })
        }
    }
    
    deinit {
        debug("IN DEINIT: Closing socket")
        self.closeSocket()
    }
    
}


