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
        let queryTrades = "CREATE TABLE IF NOT EXISTS trades(id INTEGER PRIMARY KEY AUTOINCREMENT, date DATE, ticker TEXT, price DECIMAL(5,2), quantity DECIMAL(5,4), type TEXT, account TEXT, fees DECIMAL(5,2))"
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
    }
    
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
}
