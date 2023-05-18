//
//  FGKUtils.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation
class FGKUtils {
    var fingData = [ScannedWifiList]()
    static func extract(fromJSON json: String?, forKey key: String) -> Any? {
        guard let json = json else { return nil }
        guard let jsonData = json.data(using: .utf8) else { return nil }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictionary = jsonObject as? [String: Any] {
              
                return dictionary[key]
            }
        } catch {
            // Handle error
        }
        return nil
    }

    static func formatResult(_ result: String?, orError error: Error?) -> Any {
        if let error = error {
            return error.localizedDescription
        }
       
        return result ?? ""
    }
    
   static func extractFromJSON(_ json: String?, forKey key: String) -> Any? {
        // No JSON string given.
        guard let json = json else {
            return nil
        }
        // Parse the given JSON string.
       print("progress \(json)")
        guard let data = json.data(using: .utf8) else {
            
            return nil
        }
       
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            // The originating poster wants to deal with dictionaries;
            // Assuming you do too then something like this is the first validation step:
            
            if let dict = object as? [String: Any] {
                print("datas\(dict[key])")
        
                return dict[key]
            }
          
        } catch {
            // JSON was malformed, act appropriately here
            return nil
        }
        return nil
    }
   







}






