//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Sam Kortekaas on 28/11/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
