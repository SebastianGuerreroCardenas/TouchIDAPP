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
    //Perform salted hash. Short method because it simply ties together tokens being passed in from various locations
    func createHash(handshakeString: String, rngString: String) -> Data {

        let data = handshakeString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let edata = RNCryptor.encrypt(data: data!, withPassword: rngString)

        return edata
    }
}
