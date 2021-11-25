//
//  EditTradeViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class EditTradeViewController: UIViewController {

    @IBOutlet weak var tradeTickerField: UITextField!
    @IBOutlet weak var tradeQuantityField: UITextField!
    @IBOutlet weak var tradePriceField: UITextField!
    @IBOutlet weak var tradeDateField: UIDatePicker!
    
    var id: Int = -1
    var date: String = ""
    var ticker: String = ""
    var price: Double = 0.0
    var quantity: Double = 0.0
    var type: String = ""
    var account: Int = 0
    var fees: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if id != -1 {
            tradeTickerField.text = ticker
            tradePriceField.text = String(price)
            tradeQuantityField.text = String(quantity)
            tradeDateField.date = dateFormatter.date(from:date)!
        }
    }
    
    @IBAction func tradeSave(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.ticker = tradeTickerField.text!
        self.price = Double(tradePriceField.text!) ?? 0.0
        self.quantity = Double(tradeQuantityField.text!) ?? 0.0
        self.date = formatter.string(from: tradeDateField.date)
        
        if id == -1 {
            print("new trade")
            database.db.insertTrade(date: date, ticker: ticker, price: price, quantity: quantity, type: "", account: account, fees: 0.00)
        } else {
            print("edit trade")
            database.db.updateTrade(id: id, date: date, ticker: ticker, price: price, quantity: quantity, type: type, account: account, fees: fees)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
