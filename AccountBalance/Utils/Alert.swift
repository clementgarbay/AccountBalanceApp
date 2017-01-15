//
//  Alert.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 25/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit

class Alert {
    
    static func show(_ title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

    static func confirm(_ title: String, message: String, viewController: UIViewController, ok: @escaping ((Void) -> ())) {
        let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            ok()
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(confirmAlert, animated: true, completion: nil)
    }
}
