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
//        socket.connect()
        return true
    }
    
    //It should url, username, token, (locaiton)
    /**
     Pings the server to start the handshake
     - parameter parameters: List of credentials to establish handshake
    */
    func startHandshake(parameters: [String: AnyObject]) -> Bool {
        socket.emit("handshake", parameters)
        return true
    }
    
    /**
    Provides the handlers the socket should be acting upon
     - parameter inst: The instance of the SocketConnectionViewController so we know how to move next in certain cases
    */
    func loadHandlers(inst: SocketConnectionViewController) -> Bool {
        //Running handlers method allows these to be stored in socket
        socket.on("handShake") {data, ack in
            print("Here")
            print(data)
        }
        
        socket.on("backFromHandshake") {data, ack in
            print("Here")
            print(data)
            inst.handleHandshake(data: data)
        }
        
        socket.on("connection") {data, ack in
            print(data)
            print("WOOOOOO")
        }
        
        socket.on("login") {data, ack in
            print(data)
        }
        
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
        return true
    }
    
    func loadLoginHandlers(inst: LoginViewController) -> Bool {
        socket.on("connect") {data, ack in
            print(data)
            print("WOOOOOO")
            inst.handleConnection()
        }
        
        socket.on("login") {data, ack in
            print(data)
        }
        
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
        return true
    }
    
    /**
     Pings the server to perform a login
     - parameter parameters: The user's credentials to sign in
    */
    func login(parameters: [String: String]) -> Bool {
        socket.emit("login", parameters)
        return true
    }
    
//  Below function deprecated to be moved to above
//    func loginResponse() -> Bool {
//        
//        return true
//    }
    
    
    
    
    
}
