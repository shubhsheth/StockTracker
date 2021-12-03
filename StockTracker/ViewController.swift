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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
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
    
    var trades = [Trade]()
    var selectedTrade = Trade()
    var yvalues: [PieChartDataEntry] = []
    
    func setData() {
        let set1 = PieChartDataSet(entries: yvalues)
        set1.colors = [UIColor(red: 67/255, green: 194/255, blue: 235/255, alpha: 1.0),UIColor(red: 255/255, green: 136/255, blue: 27/255, alpha: 1.0),UIColor(red: 141/255, green: 27/255, blue: 255/255, alpha: 1.0)]
        let data = PieChartData(dataSet: set1)
        pieChartView.data = data
        pieChartView.legend.enabled = true
        pieChartView.legend.orientation = .vertical
        
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
        
        dailyTrendView.addSubview(pieChartView)
        portfolioBreakdownView.addSubview(pieChartView)
        latestTradesView.delegate = self
        latestTradesView.dataSource = self
        trades = database.db.getTrades()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calculateTotalHoldings()
        
        self.latestTradesView.reloadData()
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
            yvalues.append(PieChartDataEntry(value: v, label: t))
        }
        
        setData()
        
        totalHoldingsLabel.text = "$\(totalAmount)"
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trades.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latest-trade-cell", for: indexPath)
        let ticker = trades[indexPath.row].ticker
        cell.textLabel?.text = ticker
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTrade = trades[indexPath.row] 
        performSegue(withIdentifier: "showLatestTradeSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLatestTradeSegue" {
            let detailsView = segue.destination as! ShowTradeViewController
            detailsView.id = selectedTrade.id
            detailsView.date = selectedTrade.date
            detailsView.ticker = selectedTrade.ticker
            detailsView.price = selectedTrade.price
            detailsView.quantity = selectedTrade.quantity
            detailsView.type = selectedTrade.type
            detailsView.account = selectedTrade.account
            detailsView.fees = selectedTrade.fees
        }
    }

}

