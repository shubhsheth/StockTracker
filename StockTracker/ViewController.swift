//
//  ViewController.swift
//  StockTracker
//
//  Created by student on 10/14/21.
//

import UIKit
import Charts

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
    
    lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        return chartView
    }()
    
    var yvalues: [PieChartDataEntry] = []
    
    func setData() {
        let set1 = PieChartDataSet(entries: yvalues)
        set1.colors = [UIColor(red: 67/255, green: 194/255, blue: 235/255, alpha: 1.0),UIColor(red: 255/255, green: 136/255, blue: 27/255, alpha: 1.0),UIColor(red: 141/255, green: 27/255, blue: 255/255, alpha: 1.0)]
        let data = PieChartData(dataSet: set1)
        pieChartView.data = data
    }
    
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
        pieChartView.layer.cornerRadius = 13
        pieChartView.frame.size.height = dailyTrendView.frame.size.height
        pieChartView.frame.size.width = dailyTrendView.frame.size.width
        
        // Calculations
        calculateTotalHoldings()
        
        portfolioBreakdownView.addSubview(pieChartView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calculateTotalHoldings()
    }
    
    func calculateTotalHoldings() {
        var totalAmount:Double = 0.00
        var stocks = [String:Int]()
        var types = [String:Double]()
        
        types["Cash"] = 0
        let fundings = database.db.getFundings()
        for funding in fundings {
            if funding.type == "Deposit" {
                totalAmount += funding.amount
                types["Cash"]! += funding.amount
            } else {
                totalAmount -= funding.amount
                types["Cash"]! -= funding.amount
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
            API.getQuote(ticker: stock.key) { price, type in
                totalAmount += (price * Double(stock.value))
                if types[type] == nil {
                    types[type] = 0.00
                }
                types[type]! += (price * Double(stock.value))
            }
        }
        
        yvalues = []
        for type in types {
            let v = type.value
            let t = type.key
            yvalues.append(PieChartDataEntry(value: v, data: t))
        }
        
        setData()
        
        totalHoldingsLabel.text = "$\(totalAmount)"
    }


}

