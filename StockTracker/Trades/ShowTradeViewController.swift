//
//  ShowTradeViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class ShowTradeViewController: UIViewController {

    var id: Int = -1
    var date: String = ""
    var ticker: String = ""
    var price: Double = 0.0
    var quantity: Double = 0.0
    var type: String = ""
    var account: Int = 0
    var fees: Double = 0.0
    
    @IBOutlet weak var tradeTickerLabel: UILabel!
    @IBOutlet weak var tradePriceLabel: UILabel!
    @IBOutlet weak var tradeQuantityLabel: UILabel!
    @IBOutlet weak var tradeDateLabel: UILabel!    
    
    @IBAction func editTrade(_ sender: Any) {
        performSegue(withIdentifier: "editTradeSegue", sender: self)
    }
    
    @IBOutlet weak var tradeInfoView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.id != -1
        {
            let trade = database.db.getTrade(id: self.id)
            self.date = trade.date
            self.ticker = trade.ticker
            self.price = trade.price
            self.quantity = trade.quantity
            self.type = trade.type
            self.account = trade.account
            self.fees = trade.fees
        }
        
        tradeTickerLabel.text = self.ticker
        tradePriceLabel.text = "$\(self.price)"
        tradeQuantityLabel.text = "x\(self.quantity)"
        tradeDateLabel.text = self.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tradeTickerLabel.text = self.ticker
        tradePriceLabel.text = "$\(self.price)"
        tradeQuantityLabel.text = "x\(self.quantity)"
        tradeDateLabel.text = self.date
        // Do any additional setup after loading the view.
        // STYLES
        tradeInfoView.layer.cornerRadius = 13
    }
    
    @IBAction func deleteTrade(_ sender: Any) {
        database.db.deleteTrade(id: self.id)
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTradeSegue" {
            let editView = segue.destination as! EditTradeViewController
            editView.id = self.id
            editView.date = self.date
            editView.ticker = self.ticker
            editView.price = self.price
            editView.quantity = self.quantity
            editView.type = self.type
            editView.account = self.account
            editView.fees = self.fees
        }
    }
    
}
