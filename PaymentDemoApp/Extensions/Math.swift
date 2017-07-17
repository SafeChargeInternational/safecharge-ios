//
//  Math.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/14/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
