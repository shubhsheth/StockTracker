//
//  EditFundingViewController.swift
//  StockTracker
//
//  Created by student on 11/25/21.
//

import UIKit

class EditFundingViewController: UIViewController {

    var fundingType = "Deposit"
    var account = -1
    var id = -1
    var amount = 0.00
    var fees = 0.00
    var date = ""
    
    @IBOutlet weak var dateContainerView: UIView!
    
    @IBOutlet weak var fundingAmountField: UITextField!
    @IBOutlet weak var fundingFeesField: UITextField!
    @IBOutlet weak var fundingDateField: UIDatePicker!
    @IBOutlet weak var fundingTypeField: UISegmentedControl!
    
    @IBAction func saveFundingButton(_ sender: Any) {
        saveFunding()
    }
    
    @IBAction func fundingTypeControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            fundingType = "Deposit"
        }
        else if sender.selectedSegmentIndex == 1
        {
            fundingType = "Withdraw"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if id != -1 {
            fundingAmountField.text = String(amount)
            fundingFeesField.text = String(fees)
            fundingDateField.date = dateFormatter.date(from:date)!
            if fundingType == "Deposit" {
                fundingTypeField.selectedSegmentIndex = 0
            } else {
                fundingTypeField.selectedSegmentIndex = 1
            }
        }
        
        print(database.db.getFundings())

        // Styles
        dateContainerView.layer.cornerRadius = 13
    }
    
    func saveFunding() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.amount = Double(fundingAmountField.text!) ?? 0.00
        self.fees = Double(fundingFeesField.text!) ?? 0.00
        self.date = formatter.string(from: fundingDateField.date)
        
        if id == -1 {
            print("new funding")
            database.db.insertFunding(date: date, amount: amount, type: fundingType, account: account, fees: fees)
        } else {
            print("edit funding")
//            database.db.updateTrade(id: id, date: date, ticker: ticker, price: price, quantity: quantity, type: type, account: account, fees: fees)
        }
        
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
