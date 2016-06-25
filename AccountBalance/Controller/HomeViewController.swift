//
//  ViewController.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 25/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit

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
            updateAccountBalance()
        }
    }
    
    func showRefreshImage() {
        refreshButton.enabled = false
    }
    
    func showAccountBalance(accountBalance: AccountBalance) {
        refreshButton.enabled = true
        
        providerImage.image = preferences.getProvider().image
        userLabel.text = accountBalance.username
        balanceLabel.text = accountBalance.currentBalance
    }
    
    // MARK: - Private functions
    
    private func updateAccountBalance() {
        showRefreshImage()
        
        Service.fetchData(
            failure: { error in
                switch error {
                case .Unauthorized:
                    self.showLoginWindow()
                case .Other(let error):
                    if let message = error.userInfo["NSLocalizedDescription"] as? String {
                        Alert.show(message, viewController: self)
                    } else {
                        Alert.show("Erreur lors du rafraîchissement du solde", viewController: self)
                    }
                    print(error)
                }
            },
            success: { accountBalance in
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

}

