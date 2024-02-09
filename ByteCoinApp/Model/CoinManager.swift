//
//  CoinManager.swift
//  ByteCoinApp
//
//  Created by Дмитрий on 08.02.2024.
//

import Foundation
protocol CoinManagerDelegate {
    func didUpdatedPrice(rate: Float)
    func didFailWithError(error: Error?)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "AD84CC93-6D13-43C5-99E1-2B6BC3147BA4"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        //1 create url
        if let url = URL(string: "\(baseURL)/\(currency)?apikey=\(apiKey)") {
            //2 create urlsession
            let session = URLSession(configuration: .default)
            //3 give task session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error)
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    if let finalRate = self.parseJSON(safeData) {
                        self.delegate?.didUpdatedPrice(rate: finalRate.rate)
                    }
                }
            }
            //4 start task
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: data)
            let rate = decodedData.rate
            let coinModel = CoinModel(rate: rate)
            return coinModel
        } catch {
            print(error)
            return nil
        }
        
    }
}
