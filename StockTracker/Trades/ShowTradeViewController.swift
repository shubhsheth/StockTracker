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
    
    @IBAction func optionsTrade(_ sender: Any) {
        let alert = UIAlertController(title: self.ticker, message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            self.editTrade()
        }))

        alert.addAction(UIAlertAction(title: "Delete Trade", style: .destructive , handler:{ (UIAlertAction)in
            self.deleteTrade()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tradeTickerLabel: UILabel!
    @IBOutlet weak var tradePriceLabel: UILabel!
    @IBOutlet weak var tradeQuantityLabel: UILabel!
    @IBOutlet weak var tradeDateLabel: UILabel!
    
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
    
    func editTrade() {
        performSegue(withIdentifier: "editTradeSegue", sender: self)
    }
    
    func deleteTrade() {
        database.db.deleteTrade(id: self.id)
        _ = navigationController?.popViewController(animated: true)
    }
    
}
