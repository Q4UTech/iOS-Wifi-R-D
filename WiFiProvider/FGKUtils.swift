//
//  FGKUtils.swift
//  WiFiProvider
//
//  Created by gautam  on 12/05/23.
//

import Foundation
class FGKUtils {

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
}






