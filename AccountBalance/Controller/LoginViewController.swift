//
//  LoginViewController.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 25/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit
import SwiftSpinner

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var providerPicker: UIPickerView!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var selectedProvider: Provider? = Provider.allProviders[0]
    
    var showAccountBalance: ((accountBalance: AccountBalance) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.providerPicker.delegate = self
        self.providerPicker.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
 
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    private func showSpinner() {
        SwiftSpinner.show("Connexion...")
        loginButton.enabled = false
    }
    
    private func hideSpinner() {
        SwiftSpinner.hide()
        loginButton.enabled = true
    }
    
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
        
        showSpinner()
        
        Service.fetchData(identifier, password: password, provider: selectedProvider!,
            failure: { error in
                let message: (error: RequestError) -> String = { error in
                    switch error {
                    case .Unauthorized:
                        return "Identifiant ou mot de passe incorrect"
                    case .Other(let error):
                        print(error)
                        return "Une erreur est survenue"
                    }
                }
                
                SwiftSpinner.show(message(error: error), animated: false).addTapHandler({
                    self.hideSpinner()
                }, subtitle: "Tapez pour cacher")
            },
            success: { accountBalance in
                self.hideSpinner()
                self.resetLoginForm()
                
                self.showAccountBalance(accountBalance: accountBalance)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
    }

}
