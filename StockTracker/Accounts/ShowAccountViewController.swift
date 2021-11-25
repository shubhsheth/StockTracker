//
//  ShowAccountViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class ShowAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var id: Int = -1
    var name: String = ""
    var trades = [Trade]()
    var selectedTrade = Trade()
    
    @IBAction func optionsAccount(_ sender: Any) {
        let alert = UIAlertController(title: self.name, message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Deposit", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Withdraw", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            self.editAccount()
        }))

        alert.addAction(UIAlertAction(title: "Close Account", style: .destructive , handler:{ (UIAlertAction)in
            self.closeAccount()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var totalValueView: UIView!
    @IBOutlet weak var accountName: UILabel!
    
    @IBOutlet weak var tradesView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let account = database.db.getAccount(id: self.id)
        trades = database.db.getTradesByAccount(account: self.id)
        self.name = account.name
        
        accountName.text = self.name
        
        self.tradesView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trades = database.db.getTradesByAccount(account: self.id)
        accountName.text = self.name
        
        // STYLES
        totalValueView.layer.cornerRadius = 13
        tradesView.layer.cornerRadius = 13
        
        // Table View
        tradesView.delegate = self
        tradesView.dataSource = self
        tradesView.tableFooterView = UIView()
        
    }
    
    func editAccount() {
        performSegue(withIdentifier: "editAccountSegue", sender: self)
    }
    
    func closeAccount() {
        database.db.deleteAccount(id: self.id)
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAccountSegue" {
            let editView = segue.destination as! EditAccountViewController
            editView.id = self.id
            editView.name = self.name
        }
        
        if segue.identifier == "createAccountTradeSegue" {
            let tradeView = segue.destination as! EditTradeViewController
            tradeView.account = self.id
        }
        
        if segue.identifier == "showAccountTradeSegue" {
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
    
    // MARK: - Trades
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "account-trade-cell", for: indexPath)
        cell.textLabel?.text = trades[indexPath.row].ticker
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTrade = trades[indexPath.row]
        performSegue(withIdentifier: "showAccountTradeSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func addAccountTrade(_ sender: Any) {
        performSegue(withIdentifier: "createAccountTradeSegue", sender: self)
    }
    
    
}
