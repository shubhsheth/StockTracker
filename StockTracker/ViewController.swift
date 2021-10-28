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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.`
        
        // STYLES
        // Total Holdings
        totalHoldingsView.layer.cornerRadius = 13
        
        // Day Gains
        dayGainsView.layer.cornerRadius = 13
        totalGainsView.layer.cornerRadius = 13
    }


}

