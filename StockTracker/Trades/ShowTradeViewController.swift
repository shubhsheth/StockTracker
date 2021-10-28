//
//  ShowTradeViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class ShowTradeViewController: UIViewController {

    @IBAction func editTrade(_ sender: Any) {
        performSegue(withIdentifier: "editTradeSegue", sender: self)
    }
    
    @IBOutlet weak var tradeInfoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // STYLES
        tradeInfoView.layer.cornerRadius = 13
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
