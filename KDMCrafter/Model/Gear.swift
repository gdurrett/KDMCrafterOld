//
//  Gear.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/21/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

struct Gear: Hashable {
    
    let name: String
    let description: String
    let qtyAvailable: Int
    var resourceTypeRequirements: [resourceType:Int]? = nil
    var resourceSpecialRequirements: [Resource:Int]? = nil
    var innovationRequirement: Innovation? = nil
    var locationRequirement: Location
    
    // Full init
    init(name: String, description: String, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [Resource:Int], innovationRequirement: Innovation, locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.resourceSpecialRequirements = resourceSpecialRequirements
        self.innovationRequirement = innovationRequirement
        self.locationRequirement = locationRequirement
        
    }
    // Non Innovation init
    init(name: String, description: String, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [Resource:Int], locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.resourceSpecialRequirements = resourceSpecialRequirements
        self.locationRequirement = locationRequirement
        
    }
    // Non Special Resource requirement Has Innovation requirement init
    init(name: String, description: String, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], innovationRequirement: Innovation, locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.innovationRequirement = innovationRequirement
        self.locationRequirement = locationRequirement
        
    }
    // Non Special Resource requirement Non Innovation requirement init
    init(name: String, description: String, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.locationRequirement = locationRequirement
        
    }
    
}



