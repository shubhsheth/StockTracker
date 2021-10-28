//
//  ViewController.swift
//  StockTracker
//
//  Created by student on 10/14/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var totalHoldingsView: UIView!
    @IBOutlet weak var dayGainsView: UIView!
    @IBOutlet weak var totalGainsView: UIView!
    @IBOutlet weak var dailyTrendView: UIView!
    @IBOutlet weak var portfolioBreakdownView: UIView!
    @IBOutlet weak var latestTradesView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.`
        
        // STYLES
        totalHoldingsView.layer.cornerRadius = 13
        dayGainsView.layer.cornerRadius = 13
        totalGainsView.layer.cornerRadius = 13
        dailyTrendView.layer.cornerRadius = 13
        portfolioBreakdownView.layer.cornerRadius = 13
        latestTradesView.layer.cornerRadius = 13
    }


}

