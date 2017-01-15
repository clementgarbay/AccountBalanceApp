//
//  AppPreferences.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 14/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import Foundation
import KeychainSwift

class AppPreferences {
    
    static let sharedInstance = AppPreferences()
    
    fileprivate let preferences = UserDefaults.standard
    fileprivate let keychain = KeychainSwift
    
    fileprivate init() {}
    
    /**
     Checks if an account is logged.
     
     - Returns: True if an account is logged, false otherwise.
     */
    func hasLoggedAccount() -> Bool {
        return self.preferences.bool(forKey: "hasLoggedAccount") && self.keychain.get("AccountBalance") != nil
    }
    
    /**
     Set user informations in preferences
     
     - Parameters:
        - email:     The string of the email for the login.
        - password:  The string of the password for the login.
        - provider:  The corresponding Provider.
     */
    func setUser(_ email: String, password: String, provider: Provider) {
        preferences.set(true, forKey: "hasLoggedAccount")
        preferences.setValue(email, forKey: "email")
        preferences.set(provider.rawValue, forKey: "provider")
        // TODO : encrypt it with public key
        keychain.set(password, forKey: "AccountBalance")
    }
    
    /**
     Set last account balance known in preferences
     
     - Todo: Saving history
     
     - Parameter accountBalance: The concerned account balance object.
     */
    func setAccountBalance(_ accountBalance: AccountBalance) {
        preferences.setValue(accountBalance.username, forKey: "username")
        preferences.setValue(accountBalance.currentBalance, forKey: "balance")
    }
    
    /**
     Get the saved account balance.
     
     - Returns: An account balance object.
     */
    func getAccountBalance() -> AccountBalance? {
        if hasLoggedAccount() {
            guard let username = self.preferences.value(forKey: "username") as? String else { return nil }
            guard let balance = self.preferences.value(forKey: "balance") as? String else { return nil }
            
            return AccountBalance(username: username, currentBalance: balance, history: [])
        }
        
        return nil
    }
    
    /**
     Get the preferences useful for request API.
     
     - Returns: A dictionary of preferences.
     */
    func getPreferencesForRequest() -> [String: Any]? {
        
        guard let email = self.preferences.value(forKey: "email") as? String else { return nil }
        guard let password = self.keychain.get("AccountBalance") else { return nil }
        guard let provider = Provider.getProviderFromId(self.preferences.integer(forKey: "provider")) else { return nil }
        guard hasLoggedAccount() else { return nil }
        
        var pref = [String: Any]()
        pref["email"] = email
        pref["password"] = password
        pref["provider"] = provider
        
        return pref
    }
    
    /**
     Remove all preferences.
     */
    func clear() {
        let appDomain = Bundle.main.bundleIdentifier!
        preferences.removePersistentDomain(forName: appDomain)
        keychain.clear()
    }
    
    // MARK: - Getters
    
    func getProvider() -> Provider {
        return Provider.getProviderFromId(self.preferences.integer(forKey: "provider"))!
    }
    
}
