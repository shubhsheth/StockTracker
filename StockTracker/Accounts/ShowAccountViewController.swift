//
//  ShowAccountViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class ShowAccountViewController: UIViewController {

    var id: Int = -1
    var name: String = ""
    
    @IBAction func editAccount(_ sender: Any) {
        performSegue(withIdentifier: "editAccountSegue", sender: self)
    }
    
    @IBOutlet weak var totalValueView: UIView!
    @IBOutlet weak var accountName: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.id != -1
        {
            let account = database.db.getAccount(id: self.id)
            self.name = account.name
        }
        
        accountName.text = self.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountName.text = self.name
        // Do any additional setup after loading the view.
        // STYLES
        totalValueView.layer.cornerRadius = 13
    }
    
    @IBAction func closeAccount(_ sender: Any) {
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
    }

}
