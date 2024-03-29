//
//  Location.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/21/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

struct Location: Hashable, Codable {
    
    let name: String
    let locationRequirement: String
    let resourceRequirements: [resourceType:Int]
    var innovationRequirement: Innovation? = nil
    
    init(name: String, locationRequirement: String, resourceRequirement: [resourceType:Int]) {
        
        self.name = name
        self.locationRequirement = locationRequirement
        self.resourceRequirements = resourceRequirement
    }
    init(name: String, locationRequirement: String, resourceRequirement: [resourceType:Int], innovationRequirement: Innovation) {
        
        self.name = name
        self.locationRequirement = locationRequirement
        self.resourceRequirements = resourceRequirement
        self.innovationRequirement = innovationRequirement
    }
}
