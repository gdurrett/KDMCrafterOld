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
    let resourceTypeRequirements: [resourceType:Int]
    var resourceSpecialRequirements: [Resource:Int]? = nil
    var innovationRequirement: Innovation? = nil
    var locationRequirement: Location
    
    // Full init
    init(name: String, description: String, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [Resource:Int], innovationRequirement: Innovation, locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.resourceTypeRequirements = resourceTypeRequirements
        self.resourceSpecialRequirements = resourceSpecialRequirements
        self.innovationRequirement = innovationRequirement
        self.locationRequirement = locationRequirement
        
    }
    // Non Innovation init
    init(name: String, description: String, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [Resource:Int], locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.resourceTypeRequirements = resourceTypeRequirements
        self.resourceSpecialRequirements = resourceSpecialRequirements
        self.locationRequirement = locationRequirement
        
    }
    // Non Special Resource requirement Has Innovation requirement init
    init(name: String, description: String, resourceTypeRequirements: [resourceType:Int], innovationRequirement: Innovation, locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.resourceTypeRequirements = resourceTypeRequirements
        self.innovationRequirement = innovationRequirement
        self.locationRequirement = locationRequirement
        
    }
    // Non Special Resource requirement Non Innovation requirement init
    init(name: String, description: String, resourceTypeRequirements: [resourceType:Int], locationRequirement: Location) {
        
        self.name = name
        self.description = description
        self.resourceTypeRequirements = resourceTypeRequirements
        self.locationRequirement = locationRequirement
        
    }
}

// Gear declarations
// Barber Surgeon Gear
let almanac = Gear(name: "Almanac", description: "When you depart, gain +2 insanity. You cannot gain disorders.", resourceTypeRequirements: [.leather:2], innovationRequirement: pictograph, locationRequirement: barberSurgeon)
let bugTrap = Gear(name: "Bug Trap", description: "At the start of the showdown, roll 1d10. On a roll of 3+, add a Bug Patch terrain to the showdown board.", resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [musclyGums:1], locationRequirement: barberSurgeon)
let brainMint = Gear(name: "Brain Mint", description: "Spend an action to Consume: Remove all your tokens and stand up. You may use this while knocked down, once per showdown.", resourceTypeRequirements: [:], resourceSpecialRequirements: [screamingBrain:1], locationRequirement: barberSurgeon)
let elderEarrings = Gear(name: "Elder Earrings", description: "At the start of showdown, gain +2 survival. Gain +1 Hunt XP after showdown.", resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [shankBone:1], locationRequirement: barberSurgeon)
let firstAidKit = Gear(name: "First Aid Kit", description: "On arrival, all survivors gain +3 survival. Spend an action: remove 1 bleeding or negative attribute token from yourself or an adjacent survivor.", resourceTypeRequirements: [.bone:2, .leather:1], locationRequirement: barberSurgeon)
