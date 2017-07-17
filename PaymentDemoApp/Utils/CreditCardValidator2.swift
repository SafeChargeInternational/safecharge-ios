//
//  CreditCardValidator2.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/17/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


class CreditCardValidator2 {
    enum CardType {
        case none,master_card,visa,diners_club_international,amex,jcb,discover_card,maestro,cc_switch,solo,laser,paydotcom,entropay_master_card,entropay_visa,israeli_card
        
        var cardCVVLength: Int {
            switch self {
            case .amex:
                return 4
            default:
                return 3
            }
        }

    }
    
    
    
    class func extractFirst6(input: String,maxOffset:Int) -> String {
        let str = input
        let cutIndex = str.index(str.startIndex, offsetBy: String.IndexDistance.init(maxOffset))
        return str.substring(to: cutIndex)
    }
    
    class func extractRangeFromString(input:String,maxOffset:Int) -> Int {
        let result = self.extractFirst6(input: input, maxOffset: min(maxOffset, input.characters.count))
        let parsed = Int.init(result)
        if parsed != nil {
            return parsed!
        } else {
            print("invalid result produced from extractRangeFromString")
            return 0
        }
    }
    
    class func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            print("--------match regex")
            print(regex)
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }


    
    class func checkCardType(input:String) -> (type:CardType,exactMatch:Bool) {
        var company = CardType.none;
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
       
        //input = input.replace(/[^\d]/g, '');
        
        let creditCardLength = numberOnly.characters.count;
        let cardNumber = numberOnly;
        
        //var range = parseInt(input.substring(0, 6));
        let range = self.extractRangeFromString(input: numberOnly, maxOffset: 6)
        var exactMatch:Bool = false
        switch (creditCardLength) {
            case 8:
                company = CardType.israeli_card
                exactMatch = true
                break
            case 9:
                if (self.isMasterCard(range: range)) {
                    company = CardType.master_card
                    exactMatch = true
                break
                }
                company = CardType.israeli_card
                exactMatch = true
                break
            case 13:
                if (self.startsWith(str: cardNumber, prefix: "4")) {
                    company = CardType.visa
                    exactMatch = true
                }
                break
            case 14:
                //var number = parseInt(input.substring(0, 3))// Convert.ToInt32(cardNumber.Substring(0,// 3));
                let number = self.extractRangeFromString(input:numberOnly,maxOffset:3)
                if (self.startsWith(str: cardNumber, prefix: "36") || self.startsWith(str: cardNumber, prefix: "38") || (number >= 300 && number <= 305)) {
                    company = CardType.diners_club_international
                    exactMatch = true
                    break;
                }
            break
            case 15:
                if (self.startsWith(str: cardNumber, prefix: "37") || self.startsWith(str: cardNumber, prefix: "34")) {
                    company = CardType.amex
                    exactMatch = true
                    break;
                } else if (self.startsWith(str: cardNumber, prefix: "2131") || self.startsWith(str: cardNumber, prefix: "1800")) {
                    company = CardType.jcb
                    exactMatch = true
                    break;
                }
            case 16:
                //number = parseInt(input.substring(0, 2));// Convert.ToInt32(cardNumber.Substring(0, 2));
                //->//var number = self.extractRangeFromString(input:numberOnly,maxOffset:2)
                if (self.startsWith(str: cardNumber, prefix: "542703")) {
                    company = CardType.paydotcom
                    exactMatch = true
                } else if (self.startsWith(str: cardNumber, prefix: "459061") || self.startsWith(str: cardNumber, prefix: "410162") || self.startsWith(str: cardNumber, prefix: "431380") || self.startsWith(str: cardNumber, prefix: "406742")) {
                    company = CardType.entropay_visa
                    exactMatch = true
                } else if (self.startsWith(str: cardNumber, prefix: "533805")) {
                    company = CardType.entropay_master_card
                    exactMatch = true
                } else if (self.startsWith(str: cardNumber, prefix: "6011")) {
                    company = CardType.discover_card
                    exactMatch = true
                } else if (self.startsWith(str: cardNumber, prefix: "3")) {
                    company = CardType.jcb
                    exactMatch = true
                } else if (isMasterCard(range: range)) {
                    company = CardType.master_card
                    exactMatch = true
                } else if (checkMaestroRange16(range: range)) {
                    company = CardType.maestro
                    exactMatch = true
                } else if (checkSwitchRange16(range: range)) {
                    company = CardType.cc_switch
                    exactMatch = true
                } else if (checkSoloRange16(range: range)) {
                    company = CardType.solo
                    exactMatch = true
                } else if (startsWith(str: cardNumber, prefix: "4")) {
                    company = CardType.visa
                    exactMatch = true
                }
                break;
        
        case 18:
            if (range == 490303) {
                company = CardType.maestro
                exactMatch = true
            } else if (self.checkSwitchRange18(range: range)) {
                company = CardType.cc_switch
                exactMatch = true
            } else if (self.checkSoloRange18(range: range)) {
                company = CardType.solo
                exactMatch = true
            }
            break;
        
        case 19:
            if (self.checkMaestroRange19(range: range)) {
                company = CardType.maestro
                exactMatch = true
            } else if (self.checkSwitchRange19(range: range)) {
                company = CardType.cc_switch
                exactMatch = true
            } else if (self.checkSoloRange19(range: range)) {
                company = CardType.solo
                exactMatch = true
            } else if (self.startsWith(str: cardNumber, prefix: "4")) {
                company = CardType.visa
                exactMatch = true
            }
        break;
        
        default:
            
            
            if (self.matchesRegex(regex: "^3[47][0-9]{0,13}$", text:cardNumber )) {
                company = CardType.amex
            } else if (self.matchesRegex(regex: "^3(0[0-5]|[68][0-9])[0-9]{0,11}$",text:cardNumber )) {
                company = CardType.diners_club_international
            } else if (self.matchesRegex(regex:"^4[0-9]{0,15}$",text:cardNumber )) {
                company = CardType.visa
                if (self.matchesRegex(regex:"^459061[0-9]*",text:cardNumber ) ||
                    self.matchesRegex(regex:"^410162[0-9]*",text:cardNumber ) ||
                    self.matchesRegex(regex:"^431380[0-9]*",text:cardNumber ) ||
                    self.matchesRegex(regex:"^406742[0-9]*",text:cardNumber )) {
                    company = CardType.entropay_visa
                }
            } else if ( creditCardLength < 6 ) {
                if self.matchesRegex(regex: "^(5|2)[0-9]{0,15}$", text: cardNumber) {
                    company = CardType.master_card
                    let check = self.checkIsPayDotcom(cardNumber: cardNumber)
                    if check != CardType.none {
                        company = check
                    }
                } else {
                    company = CardType.none
                }
            } else if isMasterCard(range:range) {
                company = CardType.master_card
                let check = self.checkIsPayDotcom(cardNumber: cardNumber)
                if check != CardType.none {
                    company = check
                }
            } else {
                company = CardType.none
            }
        break;
        }
        
        if (self.checkLaserCard(range: range)) {
            company = CardType.laser;
        }
        
        // Maestro: we don't know the length so we check only according to
        // the initial numbers
        // Switch/Solo ranges take place precedence over Maestro ranges i.e
        // use Switch rules
        if (company == CardType.none) { // 'not determined yet
            //var tmpRange = parseInt(input.substring(0, 2));// Convert.ToInt32(cardNumber.Substring(0, // 2));
            let tmpRange = self.extractRangeFromString(input: numberOnly, maxOffset: 2)
            if (self.checkAdditionalDiscoverRange(range: range)) {
                company = CardType.discover_card
            } else if (self.startsWith(str: cardNumber, prefix: "50") || self.checkAdditionalMaestroRange(range: tmpRange)) {
                company = CardType.maestro
            } else {
                company = CardType.none
            }
        }
        
        //var cctype = CCTypes.Credit;
        // ############# Missing method IsDebitCard
        /*
         * if (IsDebitCard(range)) { cctype = CCTypes.Debit; }
         */
        //} catch (e) {
        //}
        // input.CCType = cctype;
        // input.CCCID = company;
        
        return (company,exactMatch);
    }
    
    class func checkIsPayDotcom(cardNumber:String) -> CardType {
        var company = CardType.none
        if (self.matchesRegex(regex:"^542703[0-9]*", text:cardNumber)) {
            company = CardType.paydotcom
        } else if (self.matchesRegex(regex:"^533805[0-9]*", text:cardNumber)) {
            company = CardType.entropay_visa
        }
        return company
    }

    class func checkAdditionalDiscoverRange(range:Int) -> Bool{
        return 644000 <= range && range <= 659999
    }
    
    class func checkSoloRange19(range:Int) -> Bool {
        return 676705 == range || 676718 == range || 676750 <= range
            && range <= 676762 || 676770 == range || 676798 == range;
    }
    
    class func checkSwitchRange19(range:Int) -> Bool {
        return 493600 <= range && range <= 493699 || 675905 == range;
    }
    
    class func checkMaestroRange19(range:Int) -> Bool {
        return 493698 <= range && range <= 493699 || 633498 == range;
    }
    
    class func checkSoloRange18(range:Int) -> Bool {
        return 633461 == range || 633473 == range || 633478 == range
            || 633494 == range || 633499 == range || 676703 == range
            || 676740 == range || 676774 == range || 676779 == range
            || 676782 == range || 676795 == range;
    }
    
    class func checkSwitchRange18(range:Int) -> Bool {
        return 490302 <= range && range <= 490309 || 490335 <= range
            && range <= 490339 || 491174 <= range && range <= 491182
            || 675938 <= range && range <= 675940;
    }
    
    class func checkAdditionalMaestroRange(range:Int) -> Bool {
        return 56 <= range && range <= 58 || 60 <= range && range <= 69
    }
    
    class func checkSoloRange16(range:Int) -> Bool {
        return 633490 <= range && range <= 633493 || 633495 <= range
            && range <= 633497 || 676700 <= range && range <= 676702
            || 676706 <= range && range <= 676717 || 676719 <= range
            && range <= 676739 || 676741 <= range && range <= 676749
            || 676763 <= range && range <= 676769 || 676771 <= range
            && range <= 676773 || 676775 <= range && range <= 676778
            || 676780 <= range && range <= 676781 || 676783 <= range
            && range <= 676794 || 676796 <= range && range <= 676797
            || 676799 == range || 676704 == range
    }
    
    class func checkSwitchRange16(range:Int) -> Bool {
        return 491101 <= range && range <= 491102 || 675900 <= range
            && range <= 675904 || 675906 <= range && range <= 675937
            || 675941 <= range && range <= 675999 || 633300 == range
            || 564182 == range;
    }
    
    class func checkMaestroRange16(range:Int) -> Bool {
        return 633302 <= range && range <= 633360 || 633450 <= range
            && range <= 633460 || 633462 <= range && range <= 633472
            || 633474 <= range && range <= 633475 || 633479 <= range
            && range <= 633480 || 633482 <= range && range <= 633489
            || 633477 == range;
    }
    
    class func startsWith(str:String, prefix:String) -> Bool { // ??
        return str.hasPrefix(prefix)
        //return str.slice(0, prefix.length) == prefix;
    }
    
    class func isMasterCard(range:Int) -> Bool {
        return (range >= 222100 && range <= 272099) || ( range >= 510000 && range <= 559999);
    }
    
    class func checkLaserCard(range:Int) -> Bool {
    return 630477 <= range && range <= 630481 ||   // Reserved for future use
            630483 <= range && range <= 630484 ||   // Reserved for future use
            630485 == range ||                      // First Active                18
            630487 == range ||                      // EBS                         19
            630490 == range ||                      // Bank of Ireland             19
            630491 <= range && range <= 630492 ||   // Reserved for future use
            630493 == range ||                      // Allied Irish Bank (AIB)     19
            630494 == range ||                      // Allied Irish Bank (AIB)     19
            630495 <= range && range <= 630496 ||   // National Irish Bank         18
            630497 == range ||                      // Reserved for future use
            630498 == range ||                      // Ulster Bank Ireland Limited 19
            630499 == range ||                      // Permanent TSB               16
            677117 == range ||                      //Ulster Bank Ireland Limited 16
            677120 == range ||                      //First Active 16
            670695 == range;                        // Allied Irish Bank (AIB)     19
    }
    
}
