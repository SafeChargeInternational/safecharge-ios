//
//  DetailsTextField.
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/13/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsTextFieldProtocol : NSObjectProtocol {
    func onBackButton(caller:UITextField)
}

class DetailsTextField : UITextField {
    
    open weak var backDelegate:DetailsTextFieldProtocol? = nil
    
    override func deleteBackward() {
        self.backDelegate?.onBackButton(caller: self)
    }
}
