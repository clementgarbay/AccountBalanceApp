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
    
    fileprivate var selectedProvider: Provider? = Provider.allProviders[0]
    
    var showAccountBalance: ((_ accountBalance: AccountBalance) -> ())!
    
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Provider.allProviders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Provider.getAllProvidersValues()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProvider = Provider.getProviderFromName(Provider.getAllProvidersValues()[row])
    }
    
    // MARK: - Private functions
    
    fileprivate func showSpinner() {
        SwiftSpinner.show("Connexion...")
        loginButton.isEnabled = false
    }
    
    fileprivate func hideSpinner() {
        SwiftSpinner.hide()
        loginButton.isEnabled = true
    }
    
    fileprivate func resetLoginForm() {
        providerPicker.selectedRow(inComponent: 0)
        identifierField.text = ""
        passwordField.text = ""
    }
    
    // MARK: - IBAction
    
    @IBAction func login(_ sender: UIButton) {
        let identifier = identifierField.text!
        let password = passwordField.text!
        
        guard selectedProvider != nil && !identifier.isEmpty && !password.isEmpty else { return }
        
        showSpinner()
        
        Service.fetchData(identifier, password: password, provider: selectedProvider!,
            failure: { error in
                let message: (_ error: RequestError) -> String = { error in
                    switch error {
                    case .unauthorized:
                        return "Identifiant ou mot de passe incorrect"
                    case .other(let error):
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
                self.dismiss(animated: true, completion: nil)
            }
        )
    }

}
