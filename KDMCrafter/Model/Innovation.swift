//
//  Innovation.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/21/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

struct Innovation: Hashable {
    
    let name: String
    
    init(name: String) {
        
        self.name = name
        
    }
}

// Innovation declarations

let ammonia = Innovation(name: "Ammonia")
let drums = Innovation(name: "Drums")
let heat = Innovation(name: "Heat")
let paint = Innovation(name: "Paint")
let pictograph = Innovation(name: "Pictograph")
let pottery = Innovation(name: "Pottery")
