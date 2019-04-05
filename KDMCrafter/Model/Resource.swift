//
//  Resource.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

enum resourceKind: String, Codable {
    case basic
    case endeavor
    case phoenix
    case screamingAntelope
    case strange
    case vermin
    case gear
    case whiteLion
}
enum resourceType: String, Codable {
    case none = "None"
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

struct Resource: Hashable, Codable {
    
    let name: String
    let kind: resourceKind
    let type: [resourceType]
    
    init(name: String, kind: resourceKind, type: [resourceType]) {
        
        self.name = name
        self.kind = kind
        self.type = type
        
    }
    
}

