//
//  BankAccount.swift
//  thebankappdeneme
//
//  Created by Berke Kesgin on 20.06.2024.
//

import Foundation

struct BankAccount{
    
    var accountType: String
    var currency: Currency
    var amount: Double
    var iban: Int
    
}

enum Currency: String, CaseIterable{
    case usd = "usd"
    case euro = "euro"
    case tl = "tl"
    case gbp = "gbp"
}
