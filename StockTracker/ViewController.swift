//
//  ViewController.swift
//  StockTracker
//
//  Created by student on 10/14/21.
//

import UIKit

struct database {
    static var db = DB()
}

class HomeViewController: UIViewController {

    
    @IBOutlet weak var totalHoldingsView: UIView!
    @IBOutlet weak var dayGainsView: UIView!
    @IBOutlet weak var totalGainsView: UIView!
    @IBOutlet weak var dailyTrendView: UIView!
    @IBOutlet weak var portfolioBreakdownView: UIView!
    @IBOutlet weak var latestTradesView: UITableView!
    
    @IBOutlet weak var totalHoldingsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.`
        
        // STYLES
        totalHoldingsView?.layer.cornerRadius = 13
        dayGainsView?.layer.cornerRadius = 13
        totalGainsView?.layer.cornerRadius = 13
        dailyTrendView?.layer.cornerRadius = 13
        portfolioBreakdownView?.layer.cornerRadius = 13
        latestTradesView?.layer.cornerRadius = 13
        
        // Calculations
        calculateTotalHoldings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calculateTotalHoldings()
    }
    
    func calculateTotalHoldings() {
        var totalAmount:Double = 0.00
        var stocks = [String:Int]()
        
        let fundings = database.db.getFundings()
        for funding in fundings {
            if funding.type == "Deposit" {
                totalAmount += funding.amount
            } else {
                totalAmount -= funding.amount
            }
        }
        
        let trades = database.db.getTrades()
        for trade in trades {
            if !stocks.keys.contains(trade.ticker) {
                stocks[trade.ticker] = 0
            }
            
            if trade.type == "Buy" {
                stocks[trade.ticker]! += 1
                totalAmount -= (trade.price * trade.quantity)
                totalAmount -= trade.fees
            } else {
                stocks[trade.ticker]! -= 1
                totalAmount += (trade.price * trade.quantity)
                totalAmount -= trade.fees
            }
        }
        
        for stock in stocks {
            API.getQuote(ticker: stock.key) { price in
                totalAmount += (price * Double(stock.value))
            }
        }
        
        totalHoldingsLabel.text = "$\(totalAmount)"
    }


}

