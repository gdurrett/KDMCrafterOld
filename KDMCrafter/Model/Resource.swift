//
//  Resource.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

enum resourceKind {
    case basic
    case endeavor
    case phoenix
    case screamingAntelope
    case strange
    case vermin
    case gear
    case whiteLion
}
enum resourceType: String {
    case any = "Any Type"
    case beaconShield = "Beacon Shield"
    case bone = "Bone"
    case consumable = "Consumable"
    case endeavor = "Endeavor"
    case herb = "Herb"
    case hide = "Hide"
    case iron = "Iron"
    case finalLantern = "Final Lantern"
    case foundingStone = "Founding Stone"
    case lanternDagger = "Lantern Dagger"
    case lanternGlaive = "Lantern Glaive"
    case lanternHelm = "Lantern Helm"
    case lanternSword = "Lantern Sword"
    case leather = "Leather"
    case organ = "Organ"
    case other = "Other"
    case ringWhip = "Ring Whip"
    case scrap = "Scrap"
    case skull = "Skull"
    case vermin = "Vermin"
}

struct Resource: Hashable {
    
    let name: String
    let kind: resourceKind
    let type: [resourceType]
    
    init(name: String, kind: resourceKind, type: [resourceType]) {
        
        self.name = name
        self.kind = kind
        self.type = type
        
    }
    
}

// Basic Resource declarations
let endeavor = Resource(name: "Endeavor", kind: .basic, type: [.endeavor])
let multi = Resource(name: "???", kind: .basic, type: [.bone, .consumable, .hide, .organ])
let brokenLantern = Resource(name: "Broken Lantern", kind: .basic, type: [.scrap])
let loveJuice = Resource(name: "Love Juice", kind: .basic, type: [.organ])
let monsterBone = Resource(name: "Monster Bone", kind: .basic, type: [.bone])
let monsterHide = Resource(name: "Monster Hide", kind: .basic, type: [.hide])
let monsterOrgan = Resource(name: "Monster Organ", kind: .basic, type: [.organ])
let scrap = Resource(name: "Scrap", kind: .basic, type: [.scrap])
let skull = Resource(name: "Skull", kind: .basic, type: [.bone])

// Gear Resource declarations
let beaconShieldResource = Resource(name: "Beacon Shield", kind: .gear, type: [.beaconShield])
let finalLanternResource = Resource(name: "Final Lantern", kind: .gear, type: [.finalLantern])
let foundingStoneResource = Resource(name: "Founding Stone", kind: .gear, type: [.foundingStone])
let lanternDaggerResource = Resource(name: "Lantern Dagger", kind: .gear, type: [.lanternDagger])
let lanternGlaiveResource = Resource(name: "Lantern Glaive", kind: .gear, type: [.lanternGlaive])
let lanternHelmResource = Resource(name: "Lantern Helm", kind: .gear, type: [.lanternHelm])
let lanternSwordResource = Resource(name: "Lantern Sword", kind: .gear, type: [.lanternSword])
let ringWhipResource = Resource(name: "Ring Whip", kind: .gear, type: [.ringWhip])

// Phoenix Resource declarations
let birdBeak = Resource(name: "Bird Beak", kind: .phoenix, type: [.bone])
let blackSkull = Resource(name: "Black Skull", kind: .phoenix, type: [.bone, .iron, .skull])
let hollowWingBones = Resource(name: "Hollow Wing Bones", kind: .phoenix, type: [.bone])
let muculentDroppings = Resource(name: "Muculent Droppings", kind: .phoenix, type: [.organ])
let phoenixEye = Resource(name: "Phoenix Eye", kind: .phoenix, type: [.organ, .scrap])
let phoenixFinger = Resource(name: "Phoenix Finger", kind: .phoenix, type: [.bone])
let phoenixWhisker = Resource(name: "Phoenix Whisker", kind: .phoenix, type: [.hide])
let pustules = Resource(name: "Pustules", kind: .phoenix, type: [.consumable, .organ])
let rainbowDroppings = Resource(name: "Rainbow Droppings", kind: .phoenix, type: [.consumable, .organ])
let shimmeringHalo = Resource(name: "Shimmering Halo", kind: .phoenix, type: [.organ])
let smallFeathers = Resource(name: "Small Feathers", kind: .phoenix, type: [.hide])
let smallHandParasites = Resource(name: "Small Hand Parasites", kind: .phoenix, type: [.organ])
let tailFeathers = Resource(name: "Tail Feathers", kind: .phoenix, type: [.hide])
let wishbone = Resource(name: "Wishbone", kind: .phoenix, type: [.bone])

// Screaming Antelope Resource declarations
let beastSteak = Resource(name: "Beast Steak", kind: .screamingAntelope, type: [.consumable, .organ])
let bladder = Resource(name: "Bladder", kind: .screamingAntelope, type: [.consumable, .organ])
let largeFlatTooth = Resource(name: "Large Flat Tooth", kind: .screamingAntelope, type: [.bone])
let musclyGums = Resource(name: "Muscly Gums", kind: .screamingAntelope, type: [.consumable, .organ])
let pelt = Resource(name: "Pelt", kind: .screamingAntelope, type: [.hide])
let screamingBrain = Resource(name: "Screaming Brain", kind: .screamingAntelope, type: [.consumable, .organ])
let shankBone = Resource(name: "Shank Bone", kind: .screamingAntelope, type: [.bone])
let spiralHorn = Resource(name: "Spiral Horn", kind: .screamingAntelope, type: [.bone])

// Strange Resource declarations
let blackLichen = Resource(name: "Black Lichen", kind: .strange, type: [.bone, .consumable, .hide, .organ, .other])
let cocoonMembrane = Resource(name: "Cocoon Membrane", kind: .strange, type: [.organ, .other])
let elderCatTeeth = Resource(name: "Elder Cat Teeth", kind: .strange, type: [.bone])
let freshAcanthus = Resource(name: "Fresh Acanthus", kind: .strange, type: [.herb])
let iron = Resource(name: "Iron", kind: .strange, type: [.iron, .scrap])
let lanternTube = Resource(name: "Lantern Tube", kind: .strange, type: [.organ, .scrap])
let leather = Resource(name: "Leather", kind: .strange, type: [.hide, .leather])
let legendaryHorns = Resource(name: "Legendary Horns", kind: .strange, type: [.bone, .scrap])
let perfectCrucible = Resource(name: "Perfect Crucible", kind: .strange, type: [.iron])
let phoenixCrest = Resource(name: "Phoenix Crest", kind: .strange, type: [.organ])
let secondHeart = Resource(name: "Second Heart", kind: .strange, type: [.bone, .organ])

// Vermin Resource declarations
let crabSpider = Resource(name: "Crab Spider", kind: .vermin, type: [.consumable, .hide, .vermin])
let cyclopsFly = Resource(name: "Cyclops Fly", kind: .vermin, type: [.consumable, .vermin])
let hissingCockroach = Resource(name: "Hissing Cockroach", kind: .vermin, type: [.consumable, .vermin])
let lonelyAnt = Resource(name: "Lonely Ant", kind: .vermin, type: [.consumable, .vermin])
let nightmareTick = Resource(name: "Nightmare Tick", kind: .vermin, type: [.consumable, .vermin])
let swordBeetle = Resource(name: "Sword Beetle", kind: .vermin, type: [.consumable, .vermin])

// White Lion Resource declarations
let curiousHand = Resource(name: "Curious Hand", kind: .whiteLion, type: [.hide])
let eyeOfCat = Resource(name: "Eye of Cat", kind: .whiteLion, type: [.consumable, .organ])
let goldenWhiskers = Resource(name: "Golden Whiskers", kind: .whiteLion, type: [.organ])
let greatCatBone = Resource(name: "Great Cat Bone", kind: .whiteLion, type: [.bone])
let lionClaw = Resource(name: "Lion Claw", kind: .whiteLion, type: [.bone])
let lionTail = Resource(name: "Lion Tail", kind: .whiteLion, type: [.hide])
let lionTestes = Resource(name: "Lion Testes", kind: .whiteLion, type: [.consumable, .organ])
let shimmeringMane = Resource(name: "Shimmering Mane", kind: .whiteLion, type: [.hide])
let sinew = Resource(name: "Sinew", kind: .whiteLion, type: [.organ])
let whiteFur = Resource(name: "White Fur", kind: .whiteLion, type: [.hide])
