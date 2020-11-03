//
//  DirectionResponse.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import Foundation

typealias LngLatPosition = [Double]

struct DirectionPath : Codable {
    var list: [LngLatPosition]?
    
    init(from decoder: Decoder) throws {
        list = try decoder.singleValueContainer().decode([LngLatPosition].self)
    }
}
