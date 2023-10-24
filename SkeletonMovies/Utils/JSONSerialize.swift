//
//  JSONSerialize.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import Foundation

class JSONSerialize {
    
    class func parser(string: String) -> Any {
        guard let data = string.data(using: .utf8) else {
            print("data is nil parsing json")
            return [:]
        }
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                return jsonArray
            } else if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                return jsonArray
            } else {
                print("Json bad formet")
                return [:]
            }
        } catch let error as NSError {
            print("When set serialize json: \(error)")
            return [:]
        }
    }
}
