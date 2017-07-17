//
//  SharedViewContext.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

class SharedViewContext {
    class var shared: SharedViewContext {
        struct Static {
            static let instance: SharedViewContext = SharedViewContext()
        }
        return Static.instance
    }
    
    
    
    public var sharedCardIcon:UIImageView? = nil
    public var last4CardDigits:String? = nil
    
    public var ccardShouldResign:Bool = false
    
    public var ccardNumber:String? = nil
    public var ccardType:CreditCardValidator2.CardType? = nil
    
    public var expirationYear:String? = nil
    public var expirationMonth:String? = nil
    
    public var cvv:String? = nil
    
    

}
