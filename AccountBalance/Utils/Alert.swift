//
//  Alert.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 25/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit

class Alert {
    
    static func show(title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

    static func confirm(title: String, message: String, viewController: UIViewController, ok: (Void -> ())) {
        let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            ok()
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        viewController.presentViewController(confirmAlert, animated: true, completion: nil)
    }
}