//
//  Location.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/21/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

struct Location: Hashable {
    
    let name: String
    let locationRequirement: String
    let resourceRequirements: [resourceType:Int]
    
    init(name: String, locationRequirement: String, resourceRequirement: [resourceType:Int]) {
        
        self.name = name
        self.locationRequirement = locationRequirement
        self.resourceRequirements = resourceRequirement
        
    }
}

// Location declarations
let barberSurgeon = Location(name: "Barber Surgeon", locationRequirement: "Special: Defeat L2 Screaming Antelope with Pottery innovated", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
let blackSmith = Location(name: "Blacksmith", locationRequirement: "Special: Innovate Scrap Smelting", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
let boneSmith = Location(name: "Bone Smith", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1])
let catarium = Location(name: "Catarium", locationRequirement: "Special: Defeat White Lion", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
let exhaustedLanternHoard = Location(name: "Exhausted Lantern Hoard", locationRequirement: "Special: Archive Lantern Hoard at endgame", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
let lanternHoard = Location(name: "Lantern Hoard", locationRequirement: "Special: Enabled by default", resourceRequirement: [:]) // Enabled by default
let leatherWorker = Location(name: "Leather Worker", locationRequirement: "Skinnery", resourceRequirement: [.hide:3, .organ:1])
let maskMaker = Location(name: "Mask Maker", locationRequirement: "Special: Acquire Forsaker Mask", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
let organGrinder = Location(name: "Organ Grinder", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1])
let plumery = Location(name: "Plumery", locationRequirement: "Special: Defeat Phoenix", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
let skinnery = Location(name: "Skinnery", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1])
let stoneCircle = Location(name: "Stone Circle", locationRequirement: "Organ Grinder", resourceRequirement: [.organ:3, .hide:1])
let weaponCrafter = Location(name: "Weapon Crafter", locationRequirement: "Bone Smith", resourceRequirement: [.bone:3, .hide:1])
