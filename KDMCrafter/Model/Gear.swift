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
    var resourceTypeRequirements: [resourceType:Int]
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

// Gear declarations
// Barber Surgeon Gear
let almanac = Gear(name: "Almanac", description: "When you depart, gain +2 insanity. You cannot gain disorders.", qtyAvailable: 3, resourceTypeRequirements: [.leather:2], innovationRequirement: pictograph, locationRequirement: barberSurgeon)
let bugTrap = Gear(name: "Bug Trap", description: "At the start of the showdown, roll 1d10. On a roll of 3+, add a Bug Patch terrain to the showdown board.", qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [musclyGums:1], locationRequirement: barberSurgeon)
let brainMint = Gear(name: "Brain Mint", description: "Spend an action to Consume: Remove all your tokens and stand up. You may use this while knocked down, once per showdown.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [screamingBrain:1], locationRequirement: barberSurgeon)
let elderEarrings = Gear(name: "Elder Earrings", description: "At the start of showdown, gain +2 survival. Gain +1 Hunt XP after showdown.", qtyAvailable: 3, resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [shankBone:1], locationRequirement: barberSurgeon)
let firstAidKit = Gear(name: "First Aid Kit", description: "On arrival, all survivors gain +3 survival. Spend an action: remove 1 bleeding or negative attribute token from yourself or an adjacent survivor.", qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .leather:1], locationRequirement: barberSurgeon)
let muskBomb = Gear(name: "Musk Bomb", description: "If adjacent to monster when it draws an AI card, you may spend 2 survival and archive Musk Bomb to roll 1d10. On a 3+, discard the AI card without playing it.", qtyAvailable: 3, resourceTypeRequirements: [.any : 7], innovationRequirement: pottery, locationRequirement: barberSurgeon)
let scavengerKit = Gear(name: "Scavenger Kit", description: "When you defeat a monster, gain either 1 random basic resource or 1 random monster resource from that monster's resource deck.", qtyAvailable: 1,  resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [pelt:1], locationRequirement: barberSurgeon)
let speedPowder = Gear(name: "Speed Powder", description: "Spend 1 activation to suffer 2 brain damage. Gain 1 speed token. Use once per showdown.", qtyAvailable: 3, resourceTypeRequirements: [.organ:2], resourceSpecialRequirements: [secondHeart:1], locationRequirement: barberSurgeon)

// Blacksmith Gear
let beaconShield = Gear(name: "Beacon Shield", description: "Add 2 to all hit locations. Block 2: Spend an activation to ignore 2 hits the next time you are attacked. Lasts until your next act. You cannot use block more than once per attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [iron:2, leather:3], locationRequirement: blackSmith)
let dragonSlayer = Gear(name: "Dragon Slayer", description: "Frail, Slow, Sharp, Devastating 1. Early Iron: When an attack roll result is 1, cancel any hits and end the attack.", qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [iron:5], innovationRequirement: paint, locationRequirement: blackSmith)


