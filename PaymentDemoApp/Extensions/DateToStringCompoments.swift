//
//  DateToStringCompoments.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation



extension Date {
    
    
    public func toStringComponents() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        // String(format: "%02d", 10) // returns "10"
        let month = String(format:"%02d",calendar.component(.month, from: date))
        let day = String(format:"%02d",calendar.component(.day, from: date))
        
        let hour = String(format:"%02d",calendar.component(.hour, from: date))
        let minutes = String(format:"%02d",calendar.component(.minute, from: date))
        let seconds = String(format:"%02d",calendar.component(.second, from: date))
        
        
        
        return "\(year)\(month)\(day)\(hour)\(minutes)\(seconds)"
    }
    
    
}
