//
//  Alert.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import Foundation
import UIKit

func alert(title: String,ok: String,cancel: String ,okHandler: (()->Void)? ,cancelHandler: (()->Void)? ){
    let vc = UIApplication.shared.topMostVisibleViewController!
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
  
    let okAction = UIAlertAction(title: ok, style: .default) { action in
        guard okHandler != nil else { return }
        DispatchQueue.main.async { okHandler!() }
    }
    let cancelAction = UIAlertAction(title: cancel, style: .cancel) { action in
        guard cancelHandler != nil else { return }
        DispatchQueue.main.async { cancelHandler!() }
    }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    DispatchQueue.main.async {
        vc.present(alert, animated: true, completion: nil)
    }
    
}


extension UIViewController {
    /// Top most ViewController
    func topMostViewController() -> UIViewController {
        
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        
        return (self.presentedViewController?.topMostViewController())!
    }
    
}

extension UIApplication {
    
    /// Top most ViewController
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
    
    /// Top visible viewcontroller
    var topMostVisibleViewController : UIViewController? {
        
        // 這一段會報警示但可以正常使用
        if UIApplication.shared.keyWindow?.rootViewController is UINavigationController {
            return (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).visibleViewController
        }
        return nil
    }
    
}
