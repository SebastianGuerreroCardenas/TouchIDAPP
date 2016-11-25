//
//  SocketIOManager.swift
//  URLAdding
//
//  Created by Sebastian Guerrero on 11/22/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import SocketIO

let serverPath = "http://127.0.0.1:8080/"

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: serverPath)!, config: [.log(false), .forcePolling(true)])
    
    override init() {
        super.init()
//        socket.connect()
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func changeClient(url: String) -> Bool {
        closeConnection()
        socket = SocketIOClient(socketURL: URL(string: url)!, config: [.log(false), .forcePolling(true)])
        return true
    }
    
    //It should url, username, token, (locaiton)
    func startHandshake(parameters: [String: AnyObject]) -> Bool {
//        print(socket)
//        self.establishConnection()
        socket.emit("handshake", parameters)
        return true
    }
    
    func handShakeResponse() -> Bool {
        //Running handlers method allows these to be stored in socket
        socket.on("handShake") {data, ack in
            print("Here")
            print(data)
        }
        
        socket.on("connection") {data, ack in
            print(data)
            print("WOOOOOO")
        }
        
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
        return true
    }
    
    func login(parameters: [String: AnyObject]) -> Bool {
        socket.emit("login", parameters)
        return true
    }
    
    func loginResponse() -> Bool {
        socket.on("login") {data, ack in
            print(data)
        }
        return true
    }
    
    
    
    
}
