//
//  StringUtils.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/12/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


struct StringUtils {
    public static func formatMonth(month:UInt) -> String {
        var result = String.init(month)
        if ( month < 10 ) {
            result = "0\(result)"
        }
        return result
    }
    
    public static func formatYearTo2Digits(inputYear:String) -> String {
        if inputYear.characters.count == 2 {
            return inputYear
        } else if inputYear.characters.count == 4 {
            
            let str = inputYear
            let cutIndex = str.index(str.endIndex, offsetBy: String.IndexDistance.init(-2))
            return str.substring(from: cutIndex)

        }
        assert(false)
        return ""
    }
}
