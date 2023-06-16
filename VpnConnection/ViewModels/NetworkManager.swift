//
//  NetworkManager.swift
//  VpnConnection
//
//  Created by gautam  on 15/06/23.
//

import Foundation

class NetworkManager {
    func fetchFilms(completionHandler: @escaping (Film) -> Void) {
        let url = URL(string: "http://ip-api.com/json")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            if let data = data,
               let filmSummary = try? JSONDecoder().decode(Film.self, from: data) {
                completionHandler(filmSummary)
            }
        })
        task.resume()
    }
}
