//
//  EditAccountViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class EditAccountViewController: UIViewController {

    @IBOutlet weak var accountNameField: UITextField!

    var id: Int = -1
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountNameField.text = name
    }
    
    @IBAction func accountSave(_ sender: Any) {
        if self.id == -1 {
            database.db.insertAccount(name: accountNameField.text!)
        }
        else {
            database.db.updateAccount(id: self.id, name: accountNameField.text!)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}
