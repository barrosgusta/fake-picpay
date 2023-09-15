//
//  utils.swift
//  fake-picpay
//
//  Created by Gustavo Barros da Silveira on 14/09/23.
//

import Foundation

struct CurrencyFormatter {
    static let shared: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "R$" // Set the currency symbol to "R$" for Brazilian Real
        formatter.locale = Locale(identifier: "pt_BR") // Set the locale to Portuguese (Brazil)
        return formatter
    }()
}
