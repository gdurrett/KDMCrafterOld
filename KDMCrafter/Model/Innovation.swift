//
//  Innovation.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/21/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

struct Innovation: Hashable, Codable {
    
    let name: String
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
//            self.name = name
//        } else {
//            self.name = "None"
//        }
//    }
    
    init(name: String) {
        self.name = name
    }
}
