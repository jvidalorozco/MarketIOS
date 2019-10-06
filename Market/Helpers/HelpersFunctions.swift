//
//  HelpersFunctions.swift
//  Market
//
//  Created by jorge on 10/6/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation

func convertToCurrencty(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle           = .currency
    currencyFormatter.locale                = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
    
}
