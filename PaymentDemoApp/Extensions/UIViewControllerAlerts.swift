//
//  UIViewControllerAlerts.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/12/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit


//basic alert
extension UIViewController {
    
    func showAlert(_ error:Error? ) {
        let description = error.debugDescription
        
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (result:UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ message:String? ) {
        
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (result:UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorDialogWithAction(_ message:String?, _ okAction:UIAlertAction ) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
