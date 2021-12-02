//
//  FinanceAPI.swift
//  StockTracker
//
//  Created by student on 12/1/21.
//
import UIKit
import Foundation

struct RequestContainer: Decodable {
    struct RequestResults: Decodable {
        struct RequestQuote: Decodable {
            let quoteType: String
            let symbol: String
            let regularMarketPrice: Double
        }
        let result: [RequestQuote]
    }
    let quoteResponse: RequestResults
}

class API {
    
    static func getQuote(ticker: String, callback: ((_ price:Double,_ type:String) -> Void) ) {
        let url = URL(string: "https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&symbols=\(ticker)")
        
        var resultData = Quote(ticker: ticker, price: 0.00, type: "None")
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: url!) {
                (data, response, error) in
                if let downloadedData = data {
                    if let decodedData = self.decodeQuoteData(data: downloadedData) {
                        resultData.type = decodedData.quoteResponse.result[0].quoteType
                        resultData.price = decodedData.quoteResponse.result[0].regularMarketPrice
                        resultData.ticker = decodedData.quoteResponse.result[0].symbol
                    }
                    group.leave()
                } else if let error=error {
                    print(error.localizedDescription)
                }
            }
            
            task.resume()
        }
        group.wait()
        callback(resultData.price, resultData.type)
    }
    
    static private func decodeQuoteData(data: Data) -> RequestContainer? {
        do {
//            let downloadedInfo = try JSONDecoder().decode([String: [String: [Quote]]].self, from: data)
            let downloadedInfo = try JSONDecoder().decode(RequestContainer.self, from: data)
            
            return downloadedInfo
//            if let s = downloadedInfo["quoteResponse"] {
//                print("\(s.count)")
//            }
        } catch {
            print("Error while decoding \(error)")
        }
        
        return nil
    }
    
        
}
