//
//  Provider.swift
//  AccountBalance
//
//  Created by Clément GARBAY on 14/06/2016.
//  Copyright © 2016 Clément GARBAY. All rights reserved.
//

import UIKit

enum Provider: Int, CustomStringConvertible {
    case moneweb = 1
    case melchior = 2
    
    var description: String {
        switch self {
        case .moneweb:
            return "Moneweb (EMN)"
        case .melchior:
            return "Melchior"
        }
    }
    
    var image: UIImage {
        switch self {
        case .moneweb:
            return UIImage(named: "Moneweb-EMN")!
        case .melchior:
            return UIImage(named: "Melchior")!
        }
    }
    
    static let allProviders = [melchior, moneweb]
    
    static func getAllProvidersValues() -> [String] {
        return Provider.allProviders
            .map { $0.description }
    }
    
    static func getProviderFromId(_ id: Int) -> Provider? {
        return allProviders
            .filter { $0.rawValue == id }
            .first
    }
    
    static func getProviderFromName(_ name: String) -> Provider? {
        return allProviders
            .filter { $0.description == name }
            .first
    }
}
