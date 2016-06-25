//
//  LoginViewController.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 25/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var providerPicker: UIPickerView!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var selectedProvider: Provider? = Provider.allProviders[0]
    private var accountBalance: AccountBalance? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.providerPicker.delegate = self
        self.providerPicker.dataSource = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Provider.allProviders.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Provider.getAllProvidersValues()[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProvider = Provider.getProviderFromName(Provider.getAllProvidersValues()[row])
    }
    
    // MARK: - Private functions
    
    private func resetLoginForm() {
        providerPicker.selectedRowInComponent(0)
        identifierField.text = ""
        passwordField.text = ""
    }
    
    // MARK: - IBAction
    
    @IBAction func login(sender: UIButton) {
        let identifier = identifierField.text!
        let password = passwordField.text!
        
        guard selectedProvider != nil && !identifier.isEmpty && !password.isEmpty else { return }
        
        sender.enabled = false
        loader.hidden = false
        
        Service.fetchData(identifier, password: password, provider: selectedProvider!,
            failure: { error in
                sender.enabled = true
                self.loader.hidden = true
                            
                switch error {
                    case .Unauthorized:
                        Alert.show("Identifiant ou mot de passe incorrect", viewController: self)
                    case .Other(let error):
                        Alert.show("Une erreur est survenue", viewController: self)
                        print(error)
                }
            },
            success: { accountBalance in
                sender.enabled = true
                self.loader.hidden = true
                self.resetLoginForm()
                
                self.accountBalance = accountBalance
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let homeViewController = segue.destinationViewController as? HomeViewController {
            homeViewController.showAccountBalance(accountBalance!)
        }
    }

}
