//
// Created by Alex Martinez on 24/2/22.
//

import Foundation

func decode<T: Decodable>(_ json: [String: Any]) throws -> T {
    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    return try JSONDecoder().decode(T.self, from: data)
}
