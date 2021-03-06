//
//  DB.swift
//  StockTracker
//
//  Created by student on 10/28/21.
//

import Foundation
import SQLite3

class DB {
    var db: OpaquePointer?
    var path: String = "db.sqlite"
    
    init () {
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(path)
        
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error for DB")
            return nil
        } else {
            print("DB Created \(path)")
            return db
        }
    }
    
    func createTable() {
        
        // Trades Table
        let queryTrades = "CREATE TABLE IF NOT EXISTS trades(id INTEGER PRIMARY KEY AUTOINCREMENT, date DATE, ticker TEXT, price DECIMAL(5,2), quantity DECIMAL(5,4), type TEXT, account INTEGER, fees DECIMAL(5,2))"
        var createTradesTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, queryTrades, -1, &createTradesTable, nil) == SQLITE_OK {
            if sqlite3_step(createTradesTable) == SQLITE_DONE {
                print("Trades Table Created")
            } else {
                print("Error Creating Table")
                return
            }
        } else {
            print("Error Preparing Table")
            return
        }
        
        // Accounts Table
        let queryAccounts = "CREATE TABLE IF NOT EXISTS accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
        var createAccountsTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, queryAccounts, -1, &createAccountsTable, nil) == SQLITE_OK {
            if sqlite3_step(createAccountsTable) == SQLITE_DONE {
                print("Accounts Table Created")
            } else {
                print("Error Creating Table")
                return
            }
        } else {
            print("Error Preparing Table")
            return
        }
        
        // Funding Table
        let queryFundings = "CREATE TABLE IF NOT EXISTS fundings(id INTEGER PRIMARY KEY AUTOINCREMENT, date DATE, amount DECIMAL(5,2), type TEXT, account INTEGER, fees DECIMAL(5,2))"
        var createFundingsTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, queryFundings, -1, &createFundingsTable, nil) == SQLITE_OK {
            if sqlite3_step(createFundingsTable) == SQLITE_DONE {
                print("Fundings Table Created")
            } else {
                print("Error Creating Table")
                return
            }
        } else {
            print("Error Preparing Table")
            return
        }
        
        // Daily Gains Table
        let queryGains = "CREATE TABLE IF NOT EXISTS gains(id INTEGER PRIMARY KEY AUTOINCREMENT, date DATE, gain DECIMAL(5,2), percent DECIMAL(5,2))"
        var createGainsTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, queryGains, -1, &createGainsTable, nil) == SQLITE_OK {
            if sqlite3_step(createGainsTable) == SQLITE_DONE {
                print("Gains Table Created")
            } else {
                print("Error Creating Table")
                return
            }
        } else {
            print("Error Preparing Table")
            return
        }
    }
    // MARK: - Accounts
    func insertAccount(name:String) {
        let query = "INSERT INTO accounts (id, name) VALUES (?, ?)"
        var statement:OpaquePointer? = nil
        
        var isEmpty = false
        if getAccounts().isEmpty {
            isEmpty = true
        }
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if isEmpty {
                sqlite3_bind_int(statement,1,1)
            }
            sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Account Created")
            } else {
                print("Account Creation Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getAccounts() -> [Account] {
        
        print("Accounts Sent")
        var list = [Account]()

        let query = "SELECT * FROM accounts;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Account()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        return list
    }
    
    func deleteAccount(id:Int) {
        
        let query = "DELETE FROM accounts WHERE id=?;"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement,1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Account Deleted")
            } else {
                print("Account Deletion Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func updateAccount(id:Int, name:String) {
        
        let query = "UPDATE accounts SET name=? WHERE id=?;"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement,2, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Account Updated")
            } else {
                print("Account Updating Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getAccount(id: Int) -> Account {
        let account = Account()

        let query = "SELECT * FROM accounts WHERE id=?;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement,1, Int32(id))

            while sqlite3_step(statement) == SQLITE_ROW {
                account.id = Int(sqlite3_column_int(statement, 0))
                account.name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        return account
    
    }
    
    // MARK: - Trades
    func insertTrade(date:String, ticker:String, price:Double, quantity:Double, type:String, account:Int, fees:Double) {
        let query = "INSERT INTO trades (id, date, ticker, price, quantity, type, account, fees) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        var statement:OpaquePointer? = nil
        print("Add Trade for \(Int32(account))")
        var isEmpty = false
        if getTrades().isEmpty {
            isEmpty = true
        }
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if isEmpty {
                sqlite3_bind_int(statement,1, 1)
            }
            sqlite3_bind_text(statement, 2, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (ticker as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 4, price)
            sqlite3_bind_double(statement, 5, quantity)
            sqlite3_bind_text(statement, 6, (type as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 7, Int32(account))
            sqlite3_bind_double(statement, 8, fees)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Trade Created")
            } else {
                print("Trade Creation Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getTrades() -> [Trade] {
        
        print("Trades Sent")
        var list = [Trade]()

        let query = "SELECT * FROM trades;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Trade()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.ticker = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                model.price = Double(sqlite3_column_double(statement, 3))
                model.quantity = Double(sqlite3_column_double(statement, 4))
                model.type = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                model.account = Int(sqlite3_column_int(statement, 6))
                model.fees = Double(sqlite3_column_double(statement, 7))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        return list
    }
    
    func getTradesByAccount(account:Int) -> [Trade] {
        
        print("Trades Sent By Account \(account)")
        var list = [Trade]()

        let query = "SELECT * FROM trades WHERE account=?;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement,1, Int32(account))

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Trade()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.ticker = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                model.price = Double(sqlite3_column_double(statement, 3))
                model.quantity = Double(sqlite3_column_double(statement, 4))
                model.type = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                model.account = Int(sqlite3_column_int(statement, 6))
                model.fees = Double(sqlite3_column_double(statement, 7))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        return list
    }
    
    func deleteTrade(id:Int) {
        
        let query = "DELETE FROM trades WHERE id=?;"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement,1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Trade Deleted")
            } else {
                print("Trade Deletion Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func updateTrade(id:Int, date:String, ticker:String, price:Double, quantity:Double, type:String, account:Int, fees:Double) {
        
        let query = "UPDATE trades SET date=?,ticker=?,price=?,quantity=?,type=?,account=?,fees=? WHERE id=?;"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (ticker as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, price)
            sqlite3_bind_double(statement, 4, quantity)
            sqlite3_bind_text(statement, 5, (type as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 6, Int32(account))
            sqlite3_bind_double(statement, 7, fees)
            sqlite3_bind_int(statement, 8, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Account Updated")
            } else {
                print("Account Updating Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getTrade(id: Int) -> Trade {
        let trade = Trade()

        let query = "SELECT * FROM trades WHERE id=?;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement,1, Int32(id))

            while sqlite3_step(statement) == SQLITE_ROW {
                trade.id = Int(sqlite3_column_int(statement, 0))
                trade.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                trade.ticker = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                trade.price = Double(sqlite3_column_double(statement, 3))
                trade.quantity = Double(sqlite3_column_double(statement, 4))
                trade.type = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                trade.account = Int(sqlite3_column_int(statement, 6))
                trade.fees = Double(sqlite3_column_double(statement, 7))                
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        return trade
    }
    
    // MARK: - Funding
    func insertFunding(date:String, amount:Double, type:String, account:Int, fees:Double) {
        let query = "INSERT INTO fundings (id, date, amount, type, account, fees) VALUES (?, ?, ?, ?, ?, ?)"
        var statement:OpaquePointer? = nil
        print("Add Trade for \(Int32(account))")
        var isEmpty = false
        if getFundings().isEmpty {
            isEmpty = true
        }
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if isEmpty {
                sqlite3_bind_int(statement,1, 1)
            }
            sqlite3_bind_text(statement, 2, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, amount)
            sqlite3_bind_text(statement, 4, (type as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 5, Int32(account))
            sqlite3_bind_double(statement, 6, fees)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Funding Created")
            } else {
                print("Funding Creation Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getFundings() -> [Funding] {
        
        print("Fundings Sent")
        var list = [Funding]()

        let query = "SELECT * FROM fundings;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Funding()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.amount = Double(sqlite3_column_double(statement, 2))
                model.type = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                model.account = Int(sqlite3_column_int(statement, 4))
                model.fees = Double(sqlite3_column_double(statement, 5))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        return list
    }
    
    func getFundingsByAccount(account:Int) -> [Funding] {
        
        print("Fundings Sent By Account \(account)")
        var list = [Funding]()

        let query = "SELECT * FROM fundings WHERE account=?;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement,1, Int32(account))

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Funding()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.amount = Double(sqlite3_column_double(statement, 2))
                model.type = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                model.account = Int(sqlite3_column_int(statement, 4))
                model.fees = Double(sqlite3_column_double(statement, 5))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        return list
    }
    
    // MARK: - Gains
    func insertGain(date:String, gain:Double, percent:Double) {
        let query = "INSERT INTO gains (id, date, gain, percent) VALUES (?, ?, ?, ?)"
        var statement:OpaquePointer? = nil
        var isEmpty = false
        let gains = getGains()
        print(gains)
        if gains.isEmpty {
            isEmpty = true
        } else {
            if date == gains[0].date {
                // update gain
                updateGain(date: date, gain: gain, percent: percent)
                return
            }
        }
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if isEmpty {
                sqlite3_bind_int(statement,1, 1)
            }
            sqlite3_bind_text(statement, 2, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, gain)
            sqlite3_bind_double(statement, 4, percent)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Gain Created")
            } else {
                print("Gain Creation Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getGains() -> [Gain] {
        
        print("Gains Sent")
        var list = [Gain]()

        let query = "SELECT * FROM gains;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Gain()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.gain = Double(sqlite3_column_double(statement, 2))
                model.percent = Double(sqlite3_column_double(statement, 3))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        return list
    }
    
    func updateGain(date:String, gain:Double, percent:Double) {
        
        let query = "UPDATE gains SET gain=?,percent=? WHERE date=?;"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_double(statement, 1, gain)
            sqlite3_bind_double(statement, 2, percent)
            sqlite3_bind_text(statement, 3, (date as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Gain Updated")
            } else {
                print("Gain Updating Failed")
            }
            
        } else {
            print("Query Prep Failed")
        }
    }
    
    func getYesterdaysGains() -> Gain? {
        
        print("Gains Sent")
        var list = [Gain]()

        let query = "SELECT * FROM gains;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Gain()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.gain = Double(sqlite3_column_double(statement, 2))
                model.percent = Double(sqlite3_column_double(statement, 3))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        if list.count > 1 {
            return list[1]
        } else {
            return nil
        }
    }
    
    func getLastWeeksGains() -> Gain? {
        
        print("Gains Sent")
        var list = [Gain]()

        let query = "SELECT * FROM gains;"
        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {

            while sqlite3_step(statement) == SQLITE_ROW {
                let model = Gain()
                model.id = Int(sqlite3_column_int(statement, 0))
                model.date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                model.gain = Double(sqlite3_column_double(statement, 2))
                model.percent = Double(sqlite3_column_double(statement, 3))
                
                list.append(model)
            }
            
        } else {
            print("Query Prep Failed")
        }
        
        if list.count > 7 {
            return list[6]
        } else {
            return nil
        }
    }
    
    
    
    
}
