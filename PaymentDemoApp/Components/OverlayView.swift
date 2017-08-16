//
//  OverlayView.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/13/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

class OverlayView : UIView {
    
    private var logoView:UIImageView? = nil
    private let logoViewWidth:CGFloat = 128.0
    private let logoViewHeight:CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLogo()
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayView.handleOrientationChange(notification:)),
                                               name: NSNotification.Name.CardIOScanningOrientationDidChange,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLogo() {
        self.logoView = UIImageView.init(frame: CGRect.init(x: self.frame.size.width - self.logoViewWidth,
                                                            y: 100.0,
                                                            width: self.logoViewWidth,
                                                            height: self.logoViewHeight))
        self.logoView?.image = UIImage.init(named: "sc-logo-white-transparent-128x20")
        self.logoView?.contentMode = .scaleAspectFit
        
        self.addSubview(self.logoView!)
    }
    
    @objc private func handleOrientationChange(notification:Notification) {
        print("orientation change.")
        
        let orientation = notification.userInfo?["CardIOCurrentScanningOrientation"]
        var scanningOrientation = UIDeviceOrientation.portrait
        (orientation as? NSValue)?.getValue(&scanningOrientation)
        
        guard let _iunwrapped = orientation as? Int else {
            return
        }
        let _unwrapped = UIDeviceOrientation.init(rawValue: _iunwrapped)!
        var rotationDegrees:Int = 0
        var yAlign:CGFloat = 100
        switch _unwrapped {
        case .landscapeLeft:
            rotationDegrees = 90
            yAlign = 0
            break
        case .landscapeRight:
            rotationDegrees = -90
            yAlign = 0
            break
        case .portrait:
            rotationDegrees = 0
            yAlign = 100
            break
        case .portraitUpsideDown:
            rotationDegrees = -180
            yAlign = 100
            break
        default:
            break
        }
        
        let rads = rotationDegrees.degreesToRadians
        
        UIView.beginAnimations("rotateAnimation", context: nil)
        
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationCurve(.easeInOut)
        
        let transform:CGAffineTransform = CGAffineTransform.init(rotationAngle: CGFloat(rads))
        
        self.logoView?.transform = transform
        if _unwrapped.isPortrait {
            self.logoView?.center = CGPoint.init(x: self.bounds.size.width - self.logoViewWidth/2 - 10, y: yAlign)
        } else {
            self.logoView?.center = CGPoint.init(x:self.bounds.size.width - 25.0, y: self.logoViewWidth + 30)
        }
        UIView.commitAnimations()
    }
    
}
