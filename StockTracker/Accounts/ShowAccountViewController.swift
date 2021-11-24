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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountName.text = name

        // Do any additional setup after loading the view.
        // STYLES
        totalValueView.layer.cornerRadius = 13
    }
    
    @IBAction func closeAccount(_ sender: Any) {
        database.db.deleteAccount(id: self.id)
        _ = navigationController?.popViewController(animated: true)
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
