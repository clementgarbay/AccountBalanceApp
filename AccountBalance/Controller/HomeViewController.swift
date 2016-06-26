//
//  ViewController.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 25/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit
import SwiftSpinner

class HomeViewController: UIViewController {

    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let preferences = AppPreferences.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !preferences.hasLoggedAccount() {
            showLoginWindow()
        } else {
            showAccountBalance()
            updateAccountBalance()
        }
    }
    
    func showAccountBalance(accountBalance: AccountBalance) {
        providerImage.image = preferences.getProvider().image
        userLabel.text = accountBalance.username
        balanceLabel.text = accountBalance.currentBalance
    }
    
    func showAccountBalance() {
        providerImage.image = preferences.getProvider().image
        if let accountBalance = preferences.getAccountBalance() {
            userLabel.text = accountBalance.username
            balanceLabel.text = accountBalance.currentBalance
        }
    }
    
    // MARK: - Private functions
    
    private func showSpinner() {
        SwiftSpinner.show("Récupération des informations...")
        refreshButton.enabled = false
    }
    
    private func hideSpinner() {
        SwiftSpinner.hide()
        refreshButton.enabled = true
    }
    
    private func updateAccountBalance() {
        showSpinner()
        
        Service.fetchData(
            failure: { error in
                switch error {
                case .Unauthorized:
                    self.showLoginWindow()
                case .Other(let error):
                    let message = error.userInfo["NSLocalizedDescription"] as? String ?? "Erreur lors du rafraîchissement du solde :("
                    SwiftSpinner.show(message, animated: false).addTapHandler({
                        self.hideSpinner()
                    }, subtitle: "Tapez pour cacher")
                    print(error)
                }
            },
            success: { accountBalance in
                self.hideSpinner()
                self.showAccountBalance(accountBalance)
            }
        )
    }
    
    private func showLoginWindow() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("homeToLoginSegue", sender: self)
        })
    }
    
    // MARK: - IBAction

    @IBAction func refresh(sender: UIBarButtonItem) {
        updateAccountBalance()
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        preferences.clear()
        showLoginWindow()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let loginViewController = segue.destinationViewController as? LoginViewController {
            loginViewController.showAccountBalance = showAccountBalance
        }
    }

}

