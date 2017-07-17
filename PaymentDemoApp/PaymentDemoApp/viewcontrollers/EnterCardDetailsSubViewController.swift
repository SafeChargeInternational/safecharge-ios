//
//  EnterCardDetailsSubViewController.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

protocol EnterCardDetailsProtocol:NSObjectProtocol {
    func onMoveBackwards()
}

class EnterCardDetailsSubViewController : UIViewController {
    open weak var delegate:EnterCardDetailsProtocol? = nil
    
    @IBOutlet weak var last4DigitsField: UITextField!
    @IBOutlet weak var expField: DetailsTextField!
    @IBOutlet weak var cvcField: DetailsTextField!
    
    fileprivate var month:String? = nil
    fileprivate var year:String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        last4DigitsField.delegate = self
        expField.delegate = self
        cvcField.delegate = self
        
        expField.backDelegate = self
        cvcField.backDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(EnterCardDetailsSubViewController.updateOnEntry),
                                               name: Notification.Name.init("updateFieldsAfterCamera"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func updateOnEntry() {
        if SharedViewContext.shared.ccardNumber != nil {
            self.last4DigitsField.text = CreditCardValidator.extractLast4Digits(input: SharedViewContext.shared.ccardNumber!)
        }
        
        if SharedViewContext.shared.expirationMonth != nil && SharedViewContext.shared.expirationYear != nil {
            let twoDigitsYear = StringUtils.formatYearTo2Digits(inputYear: SharedViewContext.shared.expirationYear!)
            self.expField.text = "\(SharedViewContext.shared.expirationMonth!)/\(twoDigitsYear)"
            self.month = SharedViewContext.shared.expirationMonth
            self.year = twoDigitsYear
        } else {
            self.month = nil
            self.year = nil
        }
        
        if SharedViewContext.shared.cvv != nil {
            self.cvcField.text = SharedViewContext.shared.cvv
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //update on appear
        self.updateOnEntry()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.expField.text?.characters.count == 0 {
            self.expField.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.2)
        }
    }
    
    fileprivate func updateMMYYField(insertCharacter:String) -> Bool {
        let integerValue = Int.init(insertCharacter)
        if self.month == nil {
            if  ((integerValue == 1 || integerValue == 0) && self.expField.text?.characters.count == 0) {
                
            } else {
                if (self.expField.text?.characters.count)! > 0 {
                    let str = self.expField.text!
                    let cutIndex = str.index((str.startIndex), offsetBy: String.IndexDistance.init(1))
                    
                    let prevNumber = str.substring(to: cutIndex)
                    let prevValue = Int.init(prevNumber)
                    
                    if prevValue == 1 && (integerValue! <= 2 && integerValue! >= 0) {
                        let firstPart = self.expField.text!
                        self.expField.text = "\(firstPart)\(insertCharacter)/"
                        self.month = "\(firstPart)\(insertCharacter)"
                    } else if prevValue == 0 {
                        let firstPart = self.expField.text!
                        self.expField.text = "\(firstPart)\(insertCharacter)/"
                        self.month = "\(firstPart)\(insertCharacter)"
                    } else {
                        return false
                    }
                } else {
                    self.expField.text = "0\(insertCharacter)/"
                    self.month = "0\(insertCharacter)"
                    return false
                }
            }
        } else if self.year == nil {
            if integerValue == 0 {
                return false
            } else {
                let cnum = self.expField.text?.characters.count

                if cnum == 3 {
                    return true
                }
                if cnum == 4 { //extract it
                    let str = self.expField.text!.appending(insertCharacter)
                    let cutIndex = str.index(str.endIndex, offsetBy: String.IndexDistance.init(-2))
                    self.year = str.substring(from: cutIndex)
                    
                    SharedViewContext.shared.expirationMonth = self.month
                    SharedViewContext.shared.expirationYear = self.year
                    
                    self.expField.text?.append(insertCharacter)
                    self.cvcField.becomeFirstResponder()
                    return false
                }
            }
        } else {
            return false
        }
        
        
        return true
    }
    
}

extension EnterCardDetailsSubViewController : DetailsTextFieldProtocol {
    func onBackButton(caller: UITextField) {
        if caller == self.expField {
            if caller.text?.characters.count == 0 {
                SharedViewContext.shared.expirationMonth = nil
                SharedViewContext.shared.expirationYear = nil
                delegate?.onMoveBackwards()
                return
            } else if caller.text?.characters.count == 5 { //cut expiration
                self.year = nil
                SharedViewContext.shared.expirationYear = nil
            } else if caller.text?.characters.count == 3 {
                self.month = nil
                SharedViewContext.shared.expirationMonth = nil
                
                let str = caller.text
                let cutIndex = str?.index((str?.endIndex)!, offsetBy: String.IndexDistance.init(-2))
                caller.text = str?.substring(to: cutIndex!)

                return
            }
            
        } else if caller == self.cvcField && caller.text?.characters.count == 0 {
            SharedViewContext.shared.cvv = nil
            self.expField.becomeFirstResponder()
            return
        }
        
        let str = caller.text
        let cutIndex = str?.index((str?.endIndex)!, offsetBy: String.IndexDistance.init(-1))
        caller.text = str?.substring(to: cutIndex!)
    }
}

extension EnterCardDetailsSubViewController : UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {
            if textField == self.expField {
                if string.characters.count == 0 { //backspace
                    if (self.expField.text?.characters.count)! - 1 == 0 {
                        self.month = nil
                        return true
                    } else if (self.expField.text?.characters.count)! - 1 == 3 {
                        self.year = nil
                        return true
                    }
                }
            }
            return true
        }
        if textField == self.expField {
            if string.characters.count > 0 {
                return self.updateMMYYField(insertCharacter: string)
            }
            
        } else if textField == self.cvcField {
            var maxCVV = SharedViewContext.shared.ccardType?.cardCVVLength
            if maxCVV == nil {
                maxCVV = 4
            }
            if ((textField.text?.characters.count)! + 1 ) > (maxCVV!) {
                return false
            }
            
            if (textField.text?.characters.count)! == (maxCVV! - 1) {
                textField.text?.append(string)
                textField.resignFirstResponder()
                
                SharedViewContext.shared.expirationMonth = self.month
                SharedViewContext.shared.expirationYear = self.year
                SharedViewContext.shared.cvv = self.cvcField.text
                
                NotificationCenter.default.post(name: Notification.Name.init("updatePaymentButtonStatus"),object: nil)
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
}
