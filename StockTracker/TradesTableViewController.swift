//
//  TradesTableViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class TradesTableViewController: UITableViewController {

    @IBAction func addTrade(_ sender: Any) {
        performSegue(withIdentifier: "addTradeSegue", sender: self)
    }

    var trades = database.db.getTrades()
    var selectedTrade = Trade()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Deletes empty cells
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trades = database.db.getTrades()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trades.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trade-cell", for: indexPath)

        cell.textLabel?.text = trades[indexPath.row].ticker

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTrade = trades[indexPath.row]
        performSegue(withIdentifier: "showTradeSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTradeSegue" {
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
