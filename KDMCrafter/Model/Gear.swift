//
//  Gear.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/21/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

struct Gear: Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "Gear"
        case qtyAvailable = "Qty Available"
        case resourceTypeRequirements = "Resource Type Requirements"
        case resourceSpecialRequirements = "Resource Special Requirements"
        case innovationRequirement = "Innovation Requirement"
        case locationRequirement = "Location Requirement"
        case overlappingResources = "Overlapping Resources"
    }
    public init(from decoder: Decoder) throws {
        let gear = try decoder.container(keyedBy: CodingKeys.self)
        name = try gear.decode(String.self, forKey: .name)
        description = try gear.decode(GearDescription.self, forKey: .description)
        qtyAvailable = try gear.decode(Int.self, forKey: .qtyAvailable)
        resourceTypeRequirements = try gear.decode([resourceType:Int]?.self, forKey: .resourceTypeRequirements)
        resourceSpecialRequirements = try gear.decode([resourceType:Int]?.self, forKey: .resourceSpecialRequirements)
        
        do {
            innovationRequirement = try gear.decode(Innovation.self, forKey: .innovationRequirement)
        } catch {
            innovationRequirement = nil
        }
        
        locationRequirement = try gear.decode(Location.self, forKey: .locationRequirement)
        overlappingResources = try gear.decode([resourceType].self, forKey: .overlappingResources)
    }
    func encode(to encoder: Encoder) throws {
        var data = encoder.container(keyedBy: CodingKeys.self)
        try data.encode(name, forKey: .name)
        try data.encode(description, forKey: .description)
        try data.encode(qtyAvailable, forKey: .qtyAvailable)
        try data.encode(resourceTypeRequirements, forKey: .resourceTypeRequirements)
        try data.encode(resourceSpecialRequirements, forKey: .resourceSpecialRequirements)
        try data.encode(innovationRequirement, forKey: .innovationRequirement)
        try data.encode(locationRequirement, forKey: .locationRequirement)
        try data.encode(overlappingResources, forKey: .overlappingResources)
    }
    
    static func == (lhs: Gear, rhs: Gear) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    let description: GearDescription
    let qtyAvailable: Int
    var resourceTypeRequirements: [resourceType:Int]? = nil
    var resourceSpecialRequirements: [resourceType:Int]? = nil
    var innovationRequirement: Innovation? = nil
    var locationRequirement: Location?
    var overlappingResources: [resourceType]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    // Full init
    init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [resourceType:Int], innovationRequirement: Innovation, locationRequirement: Location, overlappingResources: [resourceType]) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.resourceSpecialRequirements = resourceSpecialRequirements
        self.innovationRequirement = innovationRequirement
        self.locationRequirement = locationRequirement
        self.overlappingResources = overlappingResources
    }
    // Non Innovation init
    init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [resourceType:Int], locationRequirement: Location, overlappingResources: [resourceType]) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.resourceSpecialRequirements = resourceSpecialRequirements
        self.locationRequirement = locationRequirement
        self.overlappingResources = overlappingResources
    }
    // Non Special Resource requirement Has Innovation requirement init
    init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], innovationRequirement: Innovation, locationRequirement: Location, overlappingResources: [resourceType]) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.innovationRequirement = innovationRequirement
        self.locationRequirement = locationRequirement
        self.overlappingResources = overlappingResources
        
    }
    // Non Special Resource requirement Non Innovation requirement init
    init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], locationRequirement: Location, overlappingResources: [resourceType]) {
        
        self.name = name
        self.description = description
        self.qtyAvailable = qtyAvailable
        self.resourceTypeRequirements = resourceTypeRequirements
        self.locationRequirement = locationRequirement
        self.overlappingResources = overlappingResources
    }
    
}



