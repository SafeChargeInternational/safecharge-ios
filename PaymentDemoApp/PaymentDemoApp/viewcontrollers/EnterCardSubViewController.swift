//
//  EnterCardSubViewController.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

protocol EnterCardProtocol:NSObjectProtocol {
    func onValidCard()
}

class EnterCardSubViewController : UIViewController {

    open var delegate:EnterCardProtocol? = nil
    @IBOutlet weak var creditCardTextField: CreditCardTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creditCardTextField.creditCardDelegate = self
        self.creditCardTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(EnterCardSubViewController.updateAfterCamera), name: Notification.Name.init("updateFieldsAfterCamera"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateAfterCamera() {
        if SharedViewContext.shared.ccardNumber != nil {
            creditCardTextField.text = CreditCardValidator.formatBy4(input:SharedViewContext.shared.ccardNumber!)
        }
        if SharedViewContext.shared.ccardType != nil {
            switch SharedViewContext.shared.ccardType! {
            case .amex:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "American_Express")
                break
            case .visa:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "visa-blue")
                break
            case .master_card:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "mc-color")
                break
            case .diners_club_international:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "diners-club-international")
                break
            case .discover_card:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Discover-2")
                break
            case .entropay_master_card:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Entropy_master")
                break
            case .entropay_visa:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Entropy_visa")
                break
            case .jcb:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "jcb")
                break
            case .maestro:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Maestro-Card-01 [Converted]")
                break
            
            default:
                SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "unknown-number")
                break
            }
        }
    }
    
    fileprivate func updateSharedContext() {
        let str = self.creditCardTextField.text
        let cutIndex = str?.index(str!.endIndex, offsetBy: String.IndexDistance.init(-4))
        SharedViewContext.shared.last4CardDigits = str?.substring(from: cutIndex!)
        SharedViewContext.shared.ccardNumber = self.creditCardTextField.text?.replacingOccurrences(of: "[^0-9]",
                                                                                                   with: "",
                                                                                                   options: .regularExpression)
        
        let ( ctype,_) = CreditCardValidator2.checkCardType(input: SharedViewContext.shared.ccardNumber!)
        SharedViewContext.shared.ccardType = ctype
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SharedViewContext.shared.ccardShouldResign = false
    }
    
    public func becomeVisibleAfterBack() {
        if SharedViewContext.shared.ccardNumber != nil {
            
            let str = self.creditCardTextField.text
            let cutIndex = str?.index((str!.endIndex), offsetBy: String.IndexDistance.init(-1))
            self.creditCardTextField.text = str?.substring(to: cutIndex!)
            self.updateSharedContext()
            self.creditCardTextField.becomeFirstResponder()
        }
    }
}

extension EnterCardSubViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //return SharedViewContext.shared.ccardShouldResign
        return true
    }
}

extension EnterCardSubViewController : CreditCardTextFieldProtocol {
    
    
    func onInvalidCard() {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "wrong-number")
    }
    
    func onUnknownCard() {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "unknown-number")
    }
    
    func onVisa(isValid: Bool)
    {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "visa-blue")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    
    func onMasterCard(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "mc-color")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    
    func onAmex(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "American_Express")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    func onDiners(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "diners-club-international")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }

    }
    
    func onDiscover(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Discover-2")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    
    func onEntryopyVisa(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Entropy_visa")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    
    func onEntropyMaster(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Entropy_master")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    
    func onJCB(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "jcb")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }
    }
    
    func onMaestro(isValid: Bool) {
        SharedViewContext.shared.sharedCardIcon?.image = UIImage.init(named: "Maestro-Card-01 [Converted]")
        if isValid {
            self.updateSharedContext()
            self.delegate?.onValidCard()
        }

    }
}
