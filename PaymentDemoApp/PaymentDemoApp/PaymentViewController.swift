//
//  ViewController.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var payActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var childHolderView: UIView!
    @IBOutlet weak var cardIconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.checkAndUpdateButton), name: Notification.Name.init("updatePaymentButtonStatus"), object: nil)
        
        SharedViewContext.shared.sharedCardIcon = self.cardIconView
        self.payButton.isEnabled = false
        
        //initialize card io
        CardIOUtilities.preload()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //update the pay button if everything is entered
    @objc func checkAndUpdateButton() {
        if SharedViewContext.shared.cvv != nil &&
           SharedViewContext.shared.ccardNumber != nil &&
           SharedViewContext.shared.expirationMonth != nil &&
           SharedViewContext.shared.expirationYear != nil {
            self.payButton.isEnabled = true
        } else {
            self.payButton.isEnabled = true
        }
        
    }
    
    @IBAction func onCamera(_ sender: Any) {
        let overlay:OverlayView = OverlayView.init(frame: self.view.frame)
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)        
        cardIOVC?.modalPresentationStyle = .formSheet
        cardIOVC?.hideCardIOLogo = true
        cardIOVC?.scanOverlayView = overlay
        
        self.present(cardIOVC!, animated: true) {
            
        }
    }
    
    
 
    @IBAction func onPay(_ sender: Any) {
        self.authorizeAction()
    }
    
    private func authorizeAction() {
        payActivity.startAnimating()
        payButton.isEnabled = false
        
        guard
            ServiceContext.merchantId != nil &&
            ServiceContext.merchantSiteId != nil &&
            ServiceContext.secretKey != nil &&
            ServiceContext.clientRequestId != nil else {
                print("error - initialize the context")
                return
        }
        
        SafeChargeAPI.authorize(merchantId: ServiceContext.merchantId!,
                                merchantSiteId: ServiceContext.merchantSiteId!,
                                clientRequestId: ServiceContext.clientRequestId!,
                                secretKey: ServiceContext.secretKey!) { (sessionToken, error) in
                                    if sessionToken != nil {
                                        self.tokenizeAction(sessionToken: sessionToken!)
                                    } else {
                                        self.payActivity.stopAnimating()
                                        self.payButton.isEnabled = true
                                        
                                        self.showAlert(error)
                                    }
        }
    }
    
    private func tokenizeAction(sessionToken:String) {
        let cardData = ["cardNumber" : SharedViewContext.shared.ccardNumber,
                        "cardHolderName" : "Sara Brawn",
                        "expirationMonth" : SharedViewContext.shared.expirationMonth,
                        "expirationYear" : SharedViewContext.shared.expirationYear,
                        "CVV" : SharedViewContext.shared.cvv]
        
        let billingAddress = ["firstName" : "Sara",
                              "lastName" : "Brawn ",
                              "address" : "stre1",
                              "email":"testthat@mail.com",
                              "phone" : "889214935",
                              "city" : "Darnassus",
                              "country" : "DE",
                              "state":"CA",
                              "zip" : "CA1234"]
        
        
        let dict:[String:Any] = ["sessionToken":sessionToken,
                                 "userTokenId":"Test_0065",
                                 "merchantSiteId":"",
                                 "cardData": cardData,
                                 "billingAddress":billingAddress
        ]
        
        let cardInfo = CardModel.init(representation: dict)
        SafeChargeAPI.tokenize(cardInfo: cardInfo!) { (token, error) in
            defer {
                self.payButton.isEnabled = true
                self.payActivity.stopAnimating()
            }
            
            if error != nil {
                self.showAlert(error)
            } else {
                self.showMessage("Temporary Card Token: \n \(String(describing: token))")
            }
        }
    }

    private let childInitialSegueIdent = "initialSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == nil {
            print("segue with unknown identifier")
            return
        }
        
        //initialize default controllers
        if identifier == self.childInitialSegueIdent {
            let pageViewController = segue.destination
            self.addChildViewController(pageViewController)
            pageViewController.didMove(toParentViewController: self)
            pageViewController.view.alpha = 1.0
            self.view.addSubview(pageViewController.view)
            self.view.layoutSubviews()
            return
        }
    }
    
}

extension PaymentViewController : CardIOPaymentViewControllerDelegate {
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            SharedViewContext.shared.ccardNumber = info.cardNumber
            
            let ( ctype,_) = CreditCardValidator2.checkCardType(input: SharedViewContext.shared.ccardNumber!)
            SharedViewContext.shared.ccardType = ctype
            
            SharedViewContext.shared.expirationMonth = StringUtils.formatMonth(month: info.expiryMonth)
            SharedViewContext.shared.expirationYear = String.init(info.expiryYear)
            SharedViewContext.shared.cvv = String.init(info.cvv)
            
            NotificationCenter.default.post(Notification.init(name: Notification.Name.init("updateFieldsAfterCamera")))
            self.resignFirstResponder()
            self.payButton.isEnabled = true
        }
        
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
}

