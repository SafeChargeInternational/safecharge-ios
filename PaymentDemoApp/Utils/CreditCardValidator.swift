//
//  CreditCardValidator.swift
//  pay-com
//
//  Created by Miroslav Chernev on 6/20/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


class CreditCardValidator {
    
    enum CardType: String {
        case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
        
        static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
        
        var regex : String {
            switch self {
            case .Amex:
                return "^3[47][0-9]{5,}$"
            case .Visa:
                return "^4[0-9]{6,}([0-9]{3})?$"
            case .MasterCard:
                return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
            case .Diners:
                return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
            case .Discover:
                return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
            case .JCB:
                return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
            case .UnionPay:
                return "^(62|88)[0-9]{5,}$"
            case .Hipercard:
                return "^(606282|3841)[0-9]{5,}$"
            case .Elo:
                return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
            default:
                return ""
            }
        }
        
        var suggested_regex : String  {
            switch self {
            case .Amex:
                return "^3\\d{0,15}$"
            case .Diners:
                return "^3(?:0[0-5]|[68][0-9])[0-9]+$"
            case .Discover:
                return "^6(?:011|5[0-9]{2})[0-9]+$"
            case .JCB:
                return "^(?:2131|1800|35[0-9]{3})[0-9]+$"
            case .MasterCard:
                return "^5[1-5][0-9]+$"
            case .Visa:
                return "^4\\d{0,15}$"
            default :
                return ""
            }
        }
        
        
        var cardDigitsLength: Int {
            switch self {
            case .Amex:
                return 15
            case .Visa:
                return 16
            case .MasterCard:
                return 16
            default:
                return 16
            }
        }
        
        var cardCVVLength: Int {
            switch self {
            case .Amex:
                return 4
            default:
                return 3
            }
        }
    }
    
    class func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    class func luhnCheck(number: String) -> Bool {
        
        let numbersOnly = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if numbersOnly.characters.count < 12 {
            return false
        }
        
        var sum = 0
        let digitStrings = numbersOnly.characters.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            guard let digit = Int(tuple.element) else
            {
                return false
            }
            let odd = tuple.offset % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
    
    class func precheckIfNotValid(input:String) -> CardType {
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var type: CardType = .Unknown
        
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        return type
    }
    
    class func checkIfComplete( input:String, cardType:CardType ) -> Bool {
        if input.characters.count < cardType.cardDigitsLength - 1 {
            return false
        }
        return true
    }
    
    class func formatBy4(input: String) -> String {
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        // format
        var formatted = ""
        var formatted4 = ""
        for character in numberOnly.characters {
            if formatted4.characters.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        return formatted
    }
    
    class func extractLast4Digits(input: String) -> String {
        let str = input
        let cutIndex = str.index(str.endIndex, offsetBy: String.IndexDistance.init(-4))
        return str.substring(from: cutIndex)
    }
    
    class func checkCardNumber(input: String) -> (type: CardType, formatted: String, valid: Bool, complete: Bool,exactMatch: Bool) {
        // Get only numbers from the input string
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        var type: CardType = .Unknown
        var valid = false
        
        // check validity
        valid = luhnCheck(number: numberOnly)
        
        if valid == false {
            for card in CardType.allCards {
                if (matchesRegex(regex: card.suggested_regex, text: numberOnly)) {
                    type = card
                    break
                }
            }
        } else {
            // detect card type
            for card in CardType.allCards {
                if (matchesRegex(regex: card.regex, text: numberOnly)) {
                    type = card
                    break
                }
            }
        }
        
        let formatted = CreditCardValidator.formatBy4(input: numberOnly)
        let complete = self.checkIfComplete(input: input, cardType:type)
        let exactMatch = (numberOnly.characters.count == type.cardDigitsLength)
        
        return (type, formatted, valid,complete,exactMatch)
    }
    
    class func validateCreditCard(input: String) -> Bool {
        let ( _ ,_ , valid,_,_) = CreditCardValidator.checkCardNumber(input: input)
        return valid
    }
}
