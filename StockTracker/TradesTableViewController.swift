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
    
    var trades = ["Trade 1", "Trade 2", "Trade 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Deletes empty cells
        tableView.tableFooterView = UIView()
        

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

        cell.textLabel?.text = trades[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTradeSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
