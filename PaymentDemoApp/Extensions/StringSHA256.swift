//
//  StringSHA256.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation

extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    
    func md5() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
              return hexStringFromData(input: md5Checksum(input: stringData as NSData))
        }
        
        return ""
    }
    

    private func md5Checksum(input: NSData) -> NSData {
        let md5ChecksumLength = Int(CC_MD5_DIGEST_LENGTH)
        var hash = [UInt8](repeating:0,count:md5ChecksumLength)
        CC_MD5(input.bytes,UInt32(input.length),&hash)
        return NSData(bytes: hash, length: md5ChecksumLength)
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
}
