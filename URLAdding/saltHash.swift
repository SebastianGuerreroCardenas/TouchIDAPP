//
//  saltHash.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 12/5/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import Foundation
import RNCryptor
import CryptoSwift

class saltHashManager {
    func createHash(handshakeString: String, rngString: String) -> Data {
        //let ciphertext = RNCryptor.encryptData(handshakeString + rngString, password: "15")
        let password = "16"

        let data = handshakeString.data(using: String.Encoding.utf8,      allowLossyConversion: false)
        //let e: NSError = NSError()
        //let st = "taco".dataUsingEncoding(NSUTF8StringEncoding)! as NSData
        let edata = RNCryptor.encrypt(data: data!, withPassword: rngString)
//        let st = NSString(data: edata, encoding: String.Encoding.utf8.rawValue)
//        do {
//            let originalData = try RNCryptor.decrypt(data: edata, withPassword: password)
//            print(NSString(data: originalData, encoding: String.Encoding.utf8.rawValue))
//        } catch {
//            print(error)
//        }
        //print(RNCryptor.decrypt(data: edata, withPassword: password))

        //let data: NSData = "taco".data(using: .utf8)
//        let password2 = [message dataUsingEncoding:NSUTF8StringEncoding];
        //let data: NSData = "string"
        //let password = "Secret password"
        //let ciphertext2 = RNCryptor.encryptData(data, password: password)
        //let encryptor = RNCryptor.Encryptor(password: password)
        let ciphertext = NSMutableData()
        
        // ... Each time data comes in, update the encryptor and accumulate some ciphertext ...
        //ciphertext.appendData(encryptor.updateWithData("16"))
        
        // ... When data is done, finish up ...
        //ciphertext.append(encryptor.finalData())
        //print(ciphertext)
//        print(NSString(data: ciphertext as Data, encoding: String.Encoding.utf8.rawValue))
        return edata
    }
}
