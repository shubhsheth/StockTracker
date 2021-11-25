//
//  Models.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import Foundation

class Account: Codable {
    var id: Int = 1
    var name: String = ""
}

class Trade: Codable {
    var id: Int = 1
    var date: String = ""
    var ticker: String = ""
    var price: Double = 0.0
    var quantity: Double = 0.0
    var type: String = ""
    var account: Int = 0
    var fees: Double = 0.0
}
