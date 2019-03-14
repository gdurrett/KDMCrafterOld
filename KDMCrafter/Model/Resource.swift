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
    case beaconShieldResource = "Beacon Shield"
    case beastSteak = "Beast Steak"
    case birdBeak = "Bird Beak"
    case blackLichen = "Black Lichen"
    case bladder = "Bladder"
    case bone = "Bone"
    case cocoonMembrane = "Cocoon Membrane"
    case consumable = "Consumable"
    case crabSpider = "Crab Spider"
    case curiousHand = "Curious Hand"
    case cyclopsFly = "Cyclops Fly"
    case elderCatTeeth = "Elder Cat Teeth"
    case endeavor = "Endeavor"
    case eyeOfCat = "Eye Of Cat"
    case finalLanternResource = "Final Lantern"
    case foundingStoneResource = "Founding Stone"
    case freshAcanthus = "Fresh Acanthus"
    case goldenWhiskers = "Golden Whiskers"
    case greatCatBone = "Great Cat Bone"
    case herb = "Herb"
    case hide = "Hide"
    case hissingCockroach = "Hissing Cockroach"
    case hollowWingBones = "Hollow Wing Bones"
    case iron = "Iron"
    case lanternDaggerResource = "Lantern Dagger"
    case lanternGlaiveResource = "Lantern Glaive"
    case lanternHelmResource = "Lantern Helm"
    case lanternSwordResource = "Lantern Sword"
    case lanternTube = "Lantern Tube"
    case largeFlatTooth = "Large Flat Tooth"
    case leather = "Leather"
    case legendaryHorns = "Legendary Horns"
    case lonelyAnt = "Lonely Ant"
    case lionClaw = "Lion Claw"
    case lionTail = "Lion Tail"
    case lionTestes = "Lion Testes"
    case muculentDroppings = "Muculent Droppings"
    case musclyGums = "Muscly Gums"
    case nightmareTick = "Nightmare Tick"
    case organ = "Organ"
    case other = "Other"
    case pelt = "Pelt"
    case perfectCrucible = "Perfect Crucible"
    case phoenixCrest = "Phoenix Crest"
    case phoenixEye = "Phoenix Eye"
    case phoenixFinger = "Phoenix Finger"
    case phoenixWhisker = "Phoenix Whisker"
    case pustules = "Pustules"
    case rainbowDroppings = "Rainbow Droppings"
    case ringWhipResource = "Ring Whip"
    case scrap = "Scrap"
    case screamingBrain = "Screaming Brain"
    case secondHeart = "Second Heart"
    case shankBone = "Shank Bone"
    case shimmeringHalo = "Shimmering Halo"
    case shimmeringMane = "Shimmering Mane"
    case sinew = "Sinew"
    case skull = "Skull"
    case smallFeathers = "Small Feathers"
    case smallHandParasites = "Small Hand Parasites"
    case spiralHorn = "Spiral Horn"
    case swordBeetle = "Sword Beetle"
    case tailFeathers = "Tail Feathers"
    case vermin = "Vermin"
    case whiteFur = "White Fur"
    case wishBone = "Wishbone"
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
let skull = Resource(name: "Skull", kind: .basic, type: [.bone, .skull])

// Gear Resource declarations
let beaconShieldResource = Resource(name: "Beacon Shield", kind: .gear, type: [.beaconShieldResource])
let finalLanternResource = Resource(name: "Final Lantern", kind: .gear, type: [.finalLanternResource])
let foundingStoneResource = Resource(name: "Founding Stone", kind: .gear, type: [.foundingStoneResource])
let lanternDaggerResource = Resource(name: "Lantern Dagger", kind: .gear, type: [.lanternDaggerResource])
let lanternGlaiveResource = Resource(name: "Lantern Glaive", kind: .gear, type: [.lanternGlaiveResource])
let lanternHelmResource = Resource(name: "Lantern Helm", kind: .gear, type: [.lanternHelmResource])
let lanternSwordResource = Resource(name: "Lantern Sword", kind: .gear, type: [.lanternSwordResource])
let ringWhipResource = Resource(name: "Ring Whip", kind: .gear, type: [.ringWhipResource])

// Phoenix Resource declarations
let birdBeak = Resource(name: "Bird Beak", kind: .phoenix, type: [.birdBeak, .bone])
let blackSkull = Resource(name: "Black Skull", kind: .phoenix, type: [.bone, .iron, .skull])
let hollowWingBones = Resource(name: "Hollow Wing Bones", kind: .phoenix, type: [.bone, .hollowWingBones])
let muculentDroppings = Resource(name: "Muculent Droppings", kind: .phoenix, type: [.muculentDroppings, .organ])
let phoenixEye = Resource(name: "Phoenix Eye", kind: .phoenix, type: [.organ, .phoenixEye, .scrap])
let phoenixFinger = Resource(name: "Phoenix Finger", kind: .phoenix, type: [.bone, .phoenixFinger])
let phoenixWhisker = Resource(name: "Phoenix Whisker", kind: .phoenix, type: [.phoenixWhisker, .hide])
let pustules = Resource(name: "Pustules", kind: .phoenix, type: [.consumable, .organ, .pustules])
let rainbowDroppings = Resource(name: "Rainbow Droppings", kind: .phoenix, type: [.consumable, .organ, .rainbowDroppings])
let shimmeringHalo = Resource(name: "Shimmering Halo", kind: .phoenix, type: [.organ, .shimmeringHalo])
let smallFeathers = Resource(name: "Small Feathers", kind: .phoenix, type: [.hide, .smallFeathers])
let smallHandParasites = Resource(name: "Small Hand Parasites", kind: .phoenix, type: [.organ, .smallHandParasites])
let tailFeathers = Resource(name: "Tail Feathers", kind: .phoenix, type: [.hide, .tailFeathers])
let wishbone = Resource(name: "Wishbone", kind: .phoenix, type: [.bone, .wishBone])

// Screaming Antelope Resource declarations
let beastSteak = Resource(name: "Beast Steak", kind: .screamingAntelope, type: [.beastSteak, .consumable, .organ])
let bladder = Resource(name: "Bladder", kind: .screamingAntelope, type: [.bladder, .consumable, .organ])
let largeFlatTooth = Resource(name: "Large Flat Tooth", kind: .screamingAntelope, type: [.bone, .largeFlatTooth])
let musclyGums = Resource(name: "Muscly Gums", kind: .screamingAntelope, type: [.consumable, .musclyGums, .organ])
let pelt = Resource(name: "Pelt", kind: .screamingAntelope, type: [.hide, .pelt])
let screamingBrain = Resource(name: "Screaming Brain", kind: .screamingAntelope, type: [.consumable, .organ, .screamingBrain])
let shankBone = Resource(name: "Shank Bone", kind: .screamingAntelope, type: [.bone, .shankBone])
let spiralHorn = Resource(name: "Spiral Horn", kind: .screamingAntelope, type: [.bone, .spiralHorn])

// Strange Resource declarations
let blackLichen = Resource(name: "Black Lichen", kind: .strange, type: [.blackLichen, .bone, .consumable, .hide, .organ, .other])
let cocoonMembrane = Resource(name: "Cocoon Membrane", kind: .strange, type: [.cocoonMembrane, .organ, .other])
let elderCatTeeth = Resource(name: "Elder Cat Teeth", kind: .strange, type: [.bone, .elderCatTeeth])
let freshAcanthus = Resource(name: "Fresh Acanthus", kind: .strange, type: [.freshAcanthus, .herb])
let iron = Resource(name: "Iron", kind: .strange, type: [.iron, .scrap])
let lanternTube = Resource(name: "Lantern Tube", kind: .strange, type: [.lanternTube, .organ, .scrap])
let leather = Resource(name: "Leather", kind: .strange, type: [.hide, .leather])
let legendaryHorns = Resource(name: "Legendary Horns", kind: .strange, type: [.bone, .legendaryHorns, .scrap])
let perfectCrucible = Resource(name: "Perfect Crucible", kind: .strange, type: [.iron, .perfectCrucible])
let phoenixCrest = Resource(name: "Phoenix Crest", kind: .strange, type: [.organ, .phoenixCrest])
let secondHeart = Resource(name: "Second Heart", kind: .strange, type: [.bone, .organ, .secondHeart])

// Vermin Resource declarations
let crabSpider = Resource(name: "Crab Spider", kind: .vermin, type: [.consumable, .crabSpider, .hide, .vermin])
let cyclopsFly = Resource(name: "Cyclops Fly", kind: .vermin, type: [.consumable, .cyclopsFly, .vermin])
let hissingCockroach = Resource(name: "Hissing Cockroach", kind: .vermin, type: [.consumable, .hissingCockroach, .vermin])
let lonelyAnt = Resource(name: "Lonely Ant", kind: .vermin, type: [.consumable, .lonelyAnt, .vermin])
let nightmareTick = Resource(name: "Nightmare Tick", kind: .vermin, type: [.consumable, .nightmareTick, .vermin])
let swordBeetle = Resource(name: "Sword Beetle", kind: .vermin, type: [.consumable, .swordBeetle, .vermin])

// White Lion Resource declarations
let curiousHand = Resource(name: "Curious Hand", kind: .whiteLion, type: [.curiousHand, .hide])
let eyeOfCat = Resource(name: "Eye of Cat", kind: .whiteLion, type: [.consumable, .eyeOfCat, .organ])
let goldenWhiskers = Resource(name: "Golden Whiskers", kind: .whiteLion, type: [.goldenWhiskers, .organ])
let greatCatBone = Resource(name: "Great Cat Bone", kind: .whiteLion, type: [.bone, .greatCatBone])
let lionClaw = Resource(name: "Lion Claw", kind: .whiteLion, type: [.bone, .lionClaw])
let lionTail = Resource(name: "Lion Tail", kind: .whiteLion, type: [.hide, .lionTail])
let lionTestes = Resource(name: "Lion Testes", kind: .whiteLion, type: [.consumable, .lionTestes, .organ])
let shimmeringMane = Resource(name: "Shimmering Mane", kind: .whiteLion, type: [.hide, .shimmeringMane])
let sinew = Resource(name: "Sinew", kind: .whiteLion, type: [.organ, .sinew])
let whiteFur = Resource(name: "White Fur", kind: .whiteLion, type: [.hide, .whiteFur])
