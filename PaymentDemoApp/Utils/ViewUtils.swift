//
//  ViewUtils.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/12/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

struct ViewUtils {
    static func traverseAndHidePayPal( ccontroller:UIViewController ) -> UIView? {
        
        var foundView:UIView? = nil
        for cchild in ccontroller.childViewControllers {
            foundView = ViewUtils.traverseAndHidePayPal(ccontroller: cchild)
            if foundView != nil {
                break
            }
        }
        
        return foundView
    }
    
    static func traverseAndFindPayPalView( rootView:UIView ) -> UIView? {
        
        for ccview in rootView.subviews {
            print(ccview.description)
            if (ccview is UIImageView)  {
                return ccview
            } else {
                if ccview.subviews.count > 0 {
                    return ViewUtils.traverseAndFindPayPalView(rootView: ccview)
                }
            }
            
        }
        
        return nil
    }
}
