//
//  EditAccountViewController.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import UIKit

class EditAccountViewController: UIViewController {

    @IBOutlet weak var accountNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func accountSave(_ sender: Any) {
        database.db.insertAccount(name: accountNameField.text!)
        accountNameField.text = ""
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
