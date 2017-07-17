//
//  CreditCardTextField.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit


protocol CreditCardTextFieldProtocol : NSObjectProtocol {
    func onInvalidCard()
    func onUnknownCard()
    func onVisa(isValid:Bool)
    func onMasterCard(isValid:Bool)
    func onAmex(isValid:Bool)
    func onDiners(isValid:Bool)
    func onDiscover(isValid:Bool)
    func onEntropyMaster(isValid:Bool)
    func onEntryopyVisa(isValid:Bool)
    func onJCB(isValid:Bool)
    func onMaestro(isValid:Bool)
}

class CreditCardTextField : UITextField {
    open weak var creditCardDelegate:CreditCardTextFieldProtocol? = nil
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
 
    public func forceCardCheck() {
        self.textFieldEdited(aNotificaiton: Notification.init(name: Notification.Name.init(""), object: self, userInfo: nil) as NSNotification)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(CreditCardTextField.textFieldEdited(aNotificaiton:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    private func cutLastSymbol(str:String) -> String {
        if str.characters.count == 0 {
            return ""
        }
        let cutIndex = str.index(str.endIndex, offsetBy: String.IndexDistance.init(-1))
        let cutted = str.substring(to: cutIndex)
        return CreditCardValidator.formatBy4(input:cutted)
    }
    @objc func textFieldEdited(aNotificaiton: NSNotification) {
        if self == aNotificaiton.object! as? CreditCardTextField {
            //let (type,formatted,valid,complete,exactMatch) = CreditCardValidator.checkCardNumber(input: self.text!)
            //let type = CreditCardValidator2.checkCardType(input: self.text!)
            let (type, exactMatch) = CreditCardValidator2.checkCardType(input: self.text!)
            
            let valid = CreditCardValidator.luhnCheck(number: self.text!)
            let complete = false
            //let exactMatch = false
            let formatted = CreditCardValidator.formatBy4(input: self.text!)
            
            print("****************************")
            print(type)
            print("****************************")
            
            if type == CreditCardValidator2.CardType.visa {
                print("sd")
            }
            
            if valid == false { //invalid card                
                if type == CreditCardValidator2.CardType.none {
                    if complete == false {
                        self.creditCardDelegate?.onUnknownCard()
                    } else {
                        self.text = self.cutLastSymbol(str: self.text!)
                        self.creditCardDelegate?.onInvalidCard()
                        return
                    }
                }
                else if type == CreditCardValidator2.CardType.visa {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onVisa(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.master_card {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onMasterCard(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.amex {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onAmex(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.diners_club_international {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onDiners(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.entropay_master_card {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onEntropyMaster(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.entropay_visa {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onEntryopyVisa(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.jcb {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onJCB(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.discover_card {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onDiscover(isValid: valid)
                    }
                } else if type ==  CreditCardValidator2.CardType.maestro {
                    if exactMatch {
                        self.creditCardDelegate?.onInvalidCard()
                    } else {
                        self.creditCardDelegate?.onMaestro(isValid: valid)
                    }
                }

            } else { //valid card
                if type ==  CreditCardValidator2.CardType.none { //unknown
                    //self.text = self.cutLastSymbol(str: formatted)
                    self.creditCardDelegate?.onUnknownCard()
                    return
                    
                } else if type == CreditCardValidator2.CardType.visa {
                    self.creditCardDelegate?.onVisa(isValid: valid)
                } else if type == CreditCardValidator2.CardType.master_card {
                    self.creditCardDelegate?.onMasterCard(isValid: valid)
                } else if type == CreditCardValidator2.CardType.amex {
                    self.creditCardDelegate?.onAmex(isValid: valid)
                } else if type == CreditCardValidator2.CardType.diners_club_international {
                    self.creditCardDelegate?.onDiners(isValid: valid)
                } else if type == CreditCardValidator2.CardType.entropay_master_card {
                    self.creditCardDelegate?.onEntropyMaster(isValid: valid)
                } else if type == CreditCardValidator2.CardType.entropay_visa {
                    self.creditCardDelegate?.onEntryopyVisa(isValid: valid)
                } else if type == CreditCardValidator2.CardType.jcb {
                    self.creditCardDelegate?.onJCB(isValid: valid)
                } else if type == CreditCardValidator2.CardType.discover_card {
                    self.creditCardDelegate?.onDiscover(isValid: valid)
                } else if type == CreditCardValidator2.CardType.maestro {
                    self.creditCardDelegate?.onMaestro(isValid: valid)
                }
            }
            self.text = formatted
        }

    }
}
