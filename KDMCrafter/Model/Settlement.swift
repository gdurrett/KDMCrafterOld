//
//  Settlement.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/17/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

enum locationIndex: Int {
    case barberSurgeon = 0
    case blackSmith = 1
    case boneSmith = 2
    case catarium = 3
    case exhaustedLanternHoard = 4
    case lanternHoard = 5
    case leatherWorker = 6
    case maskMaker = 7
    case organGrinder = 8
    case plumery = 9
    case skinnery = 10
    case stoneCircle = 11
    case weaponCrafter = 12
}

class Settlement: Codable, Equatable {
    static func == (lhs: Settlement, rhs: Settlement) -> Bool {
        return lhs.name == rhs.name
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case allResources = "All Resources"
        case resourceStorage = "Resource Storage"
        case allLocations = "All Locations"
        case locationsBuiltDict = "Locations Built Dict"
        case gearCraftedDict = "Gear Crafted Dict"
        case availableLocations = "Available Locations"
        case availableGear = "Available Gear"
        case availableInnovations = "Available Innovations"
        case innovationsAddedDict = "Innovations Added Dict"
        case overrideEnabled = "Override Enabled"
    }
    required public init(from decoder: Decoder) throws {
        let settlement = try decoder.container(keyedBy: CodingKeys.self)
        name = try settlement.decode(String.self, forKey: .name)
        allResources = try settlement.decode([Resource].self, forKey: .allResources)
        resourceStorage = try settlement.decode([Resource:Int].self, forKey: .resourceStorage)
        allLocations = try settlement.decode([Location].self, forKey: .allLocations)
        locationsBuiltDict = try settlement.decode([Location:Bool].self, forKey: .locationsBuiltDict)
        gearCraftedDict = try settlement.decode([Gear:Int].self, forKey: .gearCraftedDict)
        availableLocations = try settlement.decode([Location].self, forKey: .availableLocations)
        availableGear = try settlement.decode([Gear].self, forKey: .availableGear)
        availableInnovations = try settlement.decode([Innovation].self, forKey: .availableInnovations)
        innovationsAddedDict = try settlement.decode([Innovation:Bool].self, forKey: .innovationsAddedDict)
        overrideEnabled = try settlement.decode(Bool.self, forKey: .overrideEnabled)
    }
    func encode(to encoder: Encoder) throws {
        var settlement = encoder.container(keyedBy: CodingKeys.self)
        try settlement.encode(name, forKey: .name)
        try settlement.encode(allResources, forKey: .allResources)
        try settlement.encode(resourceStorage, forKey: .resourceStorage)
        try settlement.encode(allLocations, forKey: .allLocations)
        try settlement.encode(locationsBuiltDict, forKey: .locationsBuiltDict)
        try settlement.encode(gearCraftedDict, forKey: .gearCraftedDict)
        try settlement.encode(availableLocations, forKey: .availableLocations)
        try settlement.encode(availableGear, forKey: .availableGear)
        try settlement.encode(availableInnovations, forKey: .availableInnovations)
        try settlement.encode(innovationsAddedDict, forKey: .innovationsAddedDict)
        try settlement.encode(overrideEnabled, forKey: .overrideEnabled)
    }
    
    // For the settlement object
    let name: String
    var allResources = [Resource]()
    var resourceStorage = [Resource:Int]()
    var allLocations = [Location]()
    var locationsBuiltDict = [Location:Bool]()
    var gearCraftedDict = [Gear:Int]()
    var availableLocations = [Location]()
    var availableGear = [Gear]()
    var availableInnovations = [Innovation]()
    var innovationsAddedDict = [Innovation:Bool]()
    var overrideEnabled = false
    
    //var keyStore = DataModel.sharedInstance.keyStore
    
    init(name: String) {

        // Gotta have a name!
        self.name = name
        
        
        // Innovation declarations
        let ammonia = Innovation(name: "Ammonia")
        availableInnovations.append(ammonia)
        let drums = Innovation(name: "Drums")
        availableInnovations.append(drums)
        let lanternOven = Innovation(name: "Lantern Oven")
        availableInnovations.append(lanternOven)
        let paint = Innovation(name: "Paint")
        availableInnovations.append(paint)
        let pictograph = Innovation(name: "Pictograph")
        availableInnovations.append(pictograph)
        let pottery = Innovation(name: "Pottery")
        availableInnovations.append(pottery)
        let scrapSmelting = Innovation(name: "Scrap Smelting")
        availableInnovations.append(scrapSmelting)
        
        let barberSurgeon = Location(name: "Barber Surgeon", locationRequirement: "Special: Defeat L2 Screaming Antelope with Pottery innovated", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
        allLocations.append(barberSurgeon)
        //let blackSmith = Location(name: "Blacksmith", locationRequirement: "Special: Innovate Scrap Smelting", resourceRequirement: [.bone:6, .endeavor:1, .scrap:3]) // Allow toggle, but pop up message confirming requirement met
        let blackSmith = Location(name: "Blacksmith", locationRequirement:"", resourceRequirement: [.bone:6, .endeavor:1, .scrap:3], innovationRequirement: scrapSmelting) // Allow toggle, but pop up message confirming requirement met
        allLocations.append(blackSmith)
        let boneSmith = Location(name: "Bone Smith", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1])
        allLocations.append(boneSmith)
        let catarium = Location(name: "Catarium", locationRequirement: "Special: Defeat White Lion", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
        allLocations.append(catarium)
        let exhaustedLanternHoard = Location(name: "Exhausted Lantern Hoard", locationRequirement: "Special: Archive Lantern Hoard at endgame", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
        allLocations.append(exhaustedLanternHoard)
        let lanternHoard = Location(name: "Lantern Hoard", locationRequirement: "Special: Enabled by default", resourceRequirement: [:]) // Enabled by default
        allLocations.append(lanternHoard)
        let leatherWorker = Location(name: "Leather Worker", locationRequirement: "Skinnery", resourceRequirement: [.hide:3, .organ:1])
        allLocations.append(leatherWorker)
        let maskMaker = Location(name: "Mask Maker", locationRequirement: "Special: Acquire Forsaker Mask", resourceRequirement: [:]    ) // Allow toggle, but pop up message confirming requirement met
        allLocations.append(maskMaker)
        let organGrinder = Location(name: "Organ Grinder", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1])
        allLocations.append(organGrinder)
        let plumery = Location(name: "Plumery", locationRequirement: "Special: Defeat Phoenix", resourceRequirement: [:]) // Allow toggle, but pop up message confirming requirement met
        allLocations.append(plumery)
        let skinnery = Location(name: "Skinnery", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1])
        allLocations.append(skinnery)
        let stoneCircle = Location(name: "Stone Circle", locationRequirement: "Organ Grinder", resourceRequirement: [.organ:3, .hide:1])
        allLocations.append(stoneCircle)
        let weaponCrafter = Location(name: "Weapon Crafter", locationRequirement: "Bone Smith", resourceRequirement: [.bone:3, .hide:1])
        allLocations.append(weaponCrafter)
        
        // Initialize resources
        // Basic Resource declarations
        let endeavor = Resource(name: "Endeavor", kind: .basic, type: [.endeavor])
        allResources.append(endeavor)
        let multi = Resource(name: "???", kind: .basic, type: [.bone, .consumable, .hide, .organ])
        allResources.append(multi)
        let brokenLantern = Resource(name: "Broken Lantern", kind: .strange, type: [.scrap])
        allResources.append(brokenLantern)
        let loveJuice = Resource(name: "Love Juice", kind: .basic, type: [.organ])
        allResources.append(loveJuice)
        let monsterBone = Resource(name: "Monster Bone", kind: .basic, type: [.bone])
        allResources.append(monsterBone)
        let monsterHide = Resource(name: "Monster Hide", kind: .basic, type: [.hide])
        allResources.append(monsterHide)
        let monsterOrgan = Resource(name: "Monster Organ", kind: .basic, type: [.organ])
        allResources.append(monsterOrgan)
        let scrap = Resource(name: "Scrap", kind: .basic, type: [.scrap])
        allResources.append(scrap)
        let skull = Resource(name: "Skull", kind: .strange, type: [.bone, .skull])
        allResources.append(skull)
        
        // Gear Resource declarations
        let beaconShieldResource = Resource(name: "Beacon Shield", kind: .gear, type: [.beaconShieldResource])
        allResources.append(beaconShieldResource)
        let finalLanternResource = Resource(name: "Final Lantern", kind: .gear, type: [.finalLanternResource])
        allResources.append(finalLanternResource)
        let foundingStoneResource = Resource(name: "Founding Stone", kind: .gear, type: [.foundingStoneResource])
        allResources.append(foundingStoneResource)
        let lanternDaggerResource = Resource(name: "Lantern Dagger", kind: .gear, type: [.lanternDaggerResource])
        allResources.append(lanternDaggerResource)
        let lanternGlaiveResource = Resource(name: "Lantern Glaive", kind: .gear, type: [.lanternGlaiveResource])
        allResources.append(lanternGlaiveResource)
        let lanternHelmResource = Resource(name: "Lantern Helm", kind: .gear, type: [.lanternHelmResource])
        allResources.append(lanternHelmResource)
        let lanternSwordResource = Resource(name: "Lantern Sword", kind: .gear, type: [.lanternSwordResource])
        allResources.append(lanternSwordResource)
        let ringWhipResource = Resource(name: "Ring Whip", kind: .gear, type: [.ringWhipResource])
        allResources.append(ringWhipResource)
        
        // Phoenix Resource declarations
        let birdBeak = Resource(name: "Bird Beak", kind: .phoenix, type: [.birdBeak, .bone])
        allResources.append(birdBeak)
        let blackSkull = Resource(name: "Black Skull", kind: .phoenix, type: [.skull, .bone, .iron])
        allResources.append(blackSkull)
        let hollowWingBones = Resource(name: "Hollow Wing Bones", kind: .phoenix, type: [.hollowWingBones, .bone])
        allResources.append(hollowWingBones)
        let muculentDroppings = Resource(name: "Muculent Droppings", kind: .phoenix, type: [.muculentDroppings, .organ])
        allResources.append(muculentDroppings)
        let phoenixEye = Resource(name: "Phoenix Eye", kind: .phoenix, type: [.phoenixEye, .organ, .scrap])
        allResources.append(phoenixEye)
        let phoenixFinger = Resource(name: "Phoenix Finger", kind: .phoenix, type: [ .phoenixFinger, .bone])
        allResources.append(phoenixFinger)
        let phoenixWhisker = Resource(name: "Phoenix Whisker", kind: .phoenix, type: [.phoenixWhisker, .hide])
        allResources.append(phoenixWhisker)
        let pustules = Resource(name: "Pustules", kind: .phoenix, type: [.pustules, .consumable, .organ])
        allResources.append(pustules)
        let rainbowDroppings = Resource(name: "Rainbow Droppings", kind: .phoenix, type: [.rainbowDroppings, .consumable, .organ])
        allResources.append(rainbowDroppings)
        let shimmeringHalo = Resource(name: "Shimmering Halo", kind: .phoenix, type: [.shimmeringHalo, .organ])
        allResources.append(shimmeringHalo)
        let smallFeathers = Resource(name: "Small Feathers", kind: .phoenix, type: [.smallFeathers, .hide])
        allResources.append(smallFeathers)
        let smallHandParasites = Resource(name: "Small Hand Parasites", kind: .phoenix, type: [.smallHandParasites, .organ])
        allResources.append(smallHandParasites)
        let tailFeathers = Resource(name: "Tail Feathers", kind: .phoenix, type: [.tailFeathers, .hide])
        allResources.append(tailFeathers)
        let wishbone = Resource(name: "Wishbone", kind: .phoenix, type: [.wishBone, .bone])
        allResources.append(wishbone)
        
        // Screaming Antelope Resource declarations
        let beastSteak = Resource(name: "Beast Steak", kind: .screamingAntelope, type: [.beastSteak, .consumable, .organ])
        allResources.append(beastSteak)
        let bladder = Resource(name: "Bladder", kind: .screamingAntelope, type: [.bladder, .consumable, .organ])
        allResources.append(bladder)
        let largeFlatTooth = Resource(name: "Large Flat Tooth", kind: .screamingAntelope, type: [.largeFlatTooth, .bone])
        allResources.append(largeFlatTooth)
        let musclyGums = Resource(name: "Muscly Gums", kind: .screamingAntelope, type: [.musclyGums, .consumable, .organ])
        allResources.append(musclyGums)
        let pelt = Resource(name: "Pelt", kind: .screamingAntelope, type: [.pelt, .hide])
        allResources.append(pelt)
        let screamingBrain = Resource(name: "Screaming Brain", kind: .screamingAntelope, type: [.screamingBrain, .consumable, .organ])
        allResources.append(screamingBrain)
        let shankBone = Resource(name: "Shank Bone", kind: .screamingAntelope, type: [.shankBone, .bone])
        allResources.append(shankBone)
        let spiralHorn = Resource(name: "Spiral Horn", kind: .screamingAntelope, type: [.spiralHorn, .bone])
        allResources.append(spiralHorn)
        
        // Strange Resource declarations
        //let blackLichen = Resource(name: "Black Lichen", kind: .strange, type: [.blackLichen, .bone, .consumable, .hide, .organ, .other])
        let blackLichen = Resource(name: "Black Lichen", kind: .strange, type: [.blackLichen, .bone, .consumable, .hide, .organ])
        allResources.append(blackLichen)
        //let cocoonMembrane = Resource(name: "Cocoon Membrane", kind: .strange, type: [.cocoonMembrane, .organ, .other])
        let cocoonMembrane = Resource(name: "Cocoon Membrane", kind: .strange, type: [.cocoonMembrane, .organ])
        allResources.append(cocoonMembrane)
        let elderCatTeeth = Resource(name: "Elder Cat Teeth", kind: .strange, type: [.elderCatTeeth, .bone])
        allResources.append(elderCatTeeth)
        let freshAcanthus = Resource(name: "Fresh Acanthus", kind: .strange, type: [.freshAcanthus, .herb])
        allResources.append(freshAcanthus)
        let iron = Resource(name: "Iron", kind: .strange, type: [.iron, .scrap])
        allResources.append(iron)
        let lanternTube = Resource(name: "Lantern Tube", kind: .strange, type: [.lanternTube, .organ, .scrap])
        allResources.append(lanternTube)
        let leather = Resource(name: "Leather", kind: .strange, type: [.leather, .hide])
        allResources.append(leather)
        let legendaryHorns = Resource(name: "Legendary Horns", kind: .strange, type: [.legendaryHorns, .bone, .scrap])
        allResources.append(legendaryHorns)
        let perfectCrucible = Resource(name: "Perfect Crucible", kind: .strange, type: [.perfectCrucible, .iron])
        allResources.append(perfectCrucible)
        let phoenixCrest = Resource(name: "Phoenix Crest", kind: .strange, type: [.phoenixCrest, .organ])
        allResources.append(phoenixCrest)
        let secondHeart = Resource(name: "Second Heart", kind: .strange, type: [.secondHeart, .bone, .organ])
        allResources.append(secondHeart)
        
        // Vermin Resource declarations
        let crabSpider = Resource(name: "Crab Spider", kind: .vermin, type: [.crabSpider, .consumable, .hide, .vermin])
        allResources.append(crabSpider)
        let cyclopsFly = Resource(name: "Cyclops Fly", kind: .vermin, type: [.cyclopsFly, .consumable, .vermin])
        allResources.append(cyclopsFly)
        let hissingCockroach = Resource(name: "Hissing Cockroach", kind: .vermin, type: [.hissingCockroach, .consumable, .vermin])
        allResources.append(hissingCockroach)
        let lonelyAnt = Resource(name: "Lonely Ant", kind: .vermin, type: [.lonelyAnt, .consumable, .vermin])
        allResources.append(lonelyAnt)
        let nightmareTick = Resource(name: "Nightmare Tick", kind: .vermin, type: [.nightmareTick, .consumable, .vermin])
        allResources.append(nightmareTick)
        let swordBeetle = Resource(name: "Sword Beetle", kind: .vermin, type: [.swordBeetle, .consumable, .vermin])
        allResources.append(swordBeetle)
        
        // White Lion Resource declarations
        let curiousHand = Resource(name: "Curious Hand", kind: .whiteLion, type: [.curiousHand, .hide])
        allResources.append(curiousHand)
        let eyeOfCat = Resource(name: "Eye of Cat", kind: .whiteLion, type: [.eyeOfCat, .consumable, .organ])
        allResources.append(eyeOfCat)
        let goldenWhiskers = Resource(name: "Golden Whiskers", kind: .whiteLion, type: [.goldenWhiskers, .organ])
        allResources.append(goldenWhiskers)
        let greatCatBone = Resource(name: "Great Cat Bone", kind: .whiteLion, type: [.greatCatBone, .bone])
        allResources.append(greatCatBone)
        let lionClaw = Resource(name: "Lion Claw", kind: .whiteLion, type: [.lionClaw, .bone])
        allResources.append(lionClaw)
        let lionTail = Resource(name: "Lion Tail", kind: .whiteLion, type: [.lionTail, .hide])
        allResources.append(lionTail)
        let lionTestes = Resource(name: "Lion Testes", kind: .whiteLion, type: [.lionTestes, .consumable, .organ])
        allResources.append(lionTestes)
        let shimmeringMane = Resource(name: "Shimmering Mane", kind: .whiteLion, type: [.shimmeringMane, .hide])
        allResources.append(shimmeringMane)
        let sinew = Resource(name: "Sinew", kind: .whiteLion, type: [.sinew, .organ])
        allResources.append(sinew)
        let whiteFur = Resource(name: "White Fur", kind: .whiteLion, type: [.whiteFur, .hide])
        allResources.append(whiteFur)
        
        // Initialize available gear
        // Barber Surgeon Gear
        let almanac = Gear(name: "Almanac", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 insanity. You cannot gain disorders."))), qtyAvailable: 3, resourceTypeRequirements: [.leather:2], innovationRequirement: pictograph, locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(almanac)
        let bugTrap = Gear(name: "Bug Trap", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("At the start of the showdown, roll 1d10. On a roll of 3+, add a ").bold("Bug Patch ").normal("terrain to the showdown board."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [musclyGums:1], locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(bugTrap)
        let brainMint = Gear(name: "Brain Mint", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft, .greenUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an action to ").bold("Consume").normal(": Remove all your tokens and stand up. You may use this while knocked down, once per showdown."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [screamingBrain:1], locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(brainMint)
        let elderEarrings = Gear(name: "Elder Earrings", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.redLeft, .greenRight, .blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("At the start of ").bold("showdown").normal(", gain +2 survival. Gain +1 Hunt XP after showdown."))), qtyAvailable: 3, resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [shankBone:1], locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(elderEarrings)
        let firstAidKit = Gear(name: "First Aid Kit", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.greenLeft, .greenRight, .greenUp, .greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On ").bold("arrival").normal(", all survivors gain +3 survival. Spend an action: remove 1 bleeding or negative attribute token from yourself or an adjacent survivor."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .leather:1], locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(firstAidKit)
        let muskBomb = Gear(name: "Musk Bomb", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("If adjacent to monster when it draws an AI card, you may spend 2 survival and archive Musk Bomb to roll 1d10. On a 3+, discard the AI card without playing it."))), qtyAvailable: 3, resourceTypeRequirements: [.any : 7], innovationRequirement: pottery, locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(muskBomb)
        let scavengerKit = Gear(name: "Scavenger Kit", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Unique").normal("\n\nWhen you defeat a monster, gain either 1 random basic resource or 1 random monster resource from that monster's resource deck."))), qtyAvailable: 1,  resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [pelt:1], locationRequirement: barberSurgeon, overlappingResources: [.none])
        availableGear.append(scavengerKit)
        let speedPowder = Gear(name: "Speed Powder", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend 1 activation to suffer 2 brain damage. Gain 1 speed token. Use once per showdown."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:2], resourceSpecialRequirements: [secondHeart:1], locationRequirement: barberSurgeon, overlappingResources: [.organ])
        availableGear.append(speedPowder)
        // Blacksmith Gear
        let beaconShield = Gear(name: "Beacon Shield", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n5", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Add 2 armor to all hit locations.\n\n").bold("Block 2").normal(": Spend an activation to ignore 2 hits the next time you are attacked. Lasts until your next act. You cannot use ").bold("block").normal(" more than once per attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [iron:2, leather:3], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(beaconShield)
        let dragonSlayer = Gear(name: "Dragon Slayer", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n9", affinities: [.blueUp, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Frail, Slow, Sharp, Devastating 1.\n\nEarly Iron").normal(": When an attack roll result is 1, cancel any hits and end the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [iron:5], innovationRequirement: paint, locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(dragonSlayer)
        let lanternCuirass = Gear(name: "Lantern Cuirass", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "5", affinities: [.greenLeft, .blueUp, .greenRight, .blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("-2 movement.\n\nWith two blue and two green puzzle affinities: When you depart, add 3 to all hit locations with metal armor."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [iron:2, leather:5], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternCuirass)
        let lanternDagger = Gear(name: "Lantern Dagger", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n7+\n1", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Paired.\n\nSharp").normal(": Add 1d10 Strength to each wound attempt. Early Iron: When an attack roll result is 1, cancel any hits and end the attack."))), qtyAvailable: 4, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [iron:2, leather:3], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternDagger)
        let lanternGauntlets = Gear(name: "Lantern Gauntlets", description: GearDescription(type: .armor, statsLeft: "Arms:", statsRight: "5", affinities: [.greenLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With green puzzle affinity, +2 accuracy with club weapons."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [iron:2, leather:6], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternGauntlets)
        let lanternGlaive = Gear(name: "Lantern Glaive", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n4", affinities: [.greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Reach 2.\n\nSharp").normal(": Add 1d10 Strength to each wound attempt. ").bold("Early Iron").normal(": When your attack roll result is 1, cancel any hits and end the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [iron:2, leather:2], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternGlaive)
        let lanternGreaves = Gear(name: "Lantern Greaves", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "5", affinities: [.redLeft, .blueUp, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With two red and one green puzzle affinity, +2 movement."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [iron:1, leather:5], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternGreaves)
        let lanternHelm = Gear(name: "Lantern Helm", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "5", affinities: [.blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With blue puzzle affinity: Ear Plugs. You are ").bold("deaf").normal(". -1 accuracy."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:7], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternHelm)
        let lanternMail = Gear(name: "Lantern Mail", description: GearDescription(type: .armor, statsLeft: "Waist:", statsRight: "5", affinities: [.greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal(""))), qtyAvailable: 3, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternMail)
        let lanternSword = Gear(name: "Lantern Sword", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n5+\n3", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Sharp").normal(": Add 1d10 Strength to each wound attempt. ").bold("Early Iron").normal(": When an attack roll result is 1, cancel any hits and end the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:4, .hide:3], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(lanternSword)
        let perfectSlayer = Gear(name: "Perfect Slayer", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n6+\n14", affinities: [.redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Slow, Sharp, Devastating 2, Irreplaceable").normal(". -2 movement."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [iron:9, perfectCrucible:1], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(perfectSlayer)
        let ringWhip = Gear(name: "Ring Whip", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n5+\n0", affinities: [.blueLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Sharp, Reach 2\n\nEarly Iron").normal(": When an attack roll result is 1, cancel any hits and end the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .organ:3], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(ringWhip)
        let scrapShield = Gear(name: "Scrap Shield", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n7+\n3", affinities: [.redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Add +1 armor to all hit locations.\n\n").bold("Block 1").normal(": Spend an activation to ignore a hit the next time you are attacked. Lasts until your next act. You cannot use ").bold("block").normal(" more than once per attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3], resourceSpecialRequirements: [leather:3, scrap:2], locationRequirement: blackSmith, overlappingResources: [.none])
        availableGear.append(scrapShield)
        // Bonesmith gear
        let boneAxe = Gear(name: "Bone Axe", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n3", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Frail\n\nSavage:").normal(": Once per attack, if you critically wound, cause 1 additional wound. This effect does not apply to impervious hit locations."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .organ:1], locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(boneAxe)
        let boneBlade = Gear(name: "Bone Blade", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n2", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Frail").normal(": When you attempt to wound a super-dense hit location, this weapon breaks. Archive this card at the end of the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(boneBlade)
        let boneClub = Gear(name: "Bone Club", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n5", affinities: [.redLeft, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Cumbersome").normal(": Spend a movement as an additional cost to activate this weapon. Ignore Cumbersome if this weapon is activated indirectly (Pounce, Charge, etc)."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3], locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(boneClub)
        let boneDagger = Gear(name: "Bone Dagger", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n7+\n1", affinities: [.redLeft, .redUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(" (lantern 10), gain +1 survival."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(boneDagger)
        let boneDarts = Gear(name: "Bone Darts", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n7+\n1", affinities: [.redLeft, .redUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Range").normal(": 6.\n\n").bold("Frail").normal(": When you attempt to wound a super-dense hit location, this weapon breaks. Archive this card at the end of the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(boneDarts)
        let bonePickaxe = Gear(name: "Bone Pickaxe", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n8+\n2", affinities: [.greenUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("After Hunt phase setup, place the ").bold("Mineral Gathering").normal(" event on any hunt space."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [leather:1], innovationRequirement: ammonia, locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(bonePickaxe)
        let boneSickle = Gear(name: "Bone Sickle", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n8+\n1", affinities: [.greenUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("After Hunt phase setup, place the ").bold("Herb Gathering").normal(" event on any hunt space."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [leather:1], innovationRequirement: ammonia, locationRequirement: boneSmith, overlappingResources: [.none])
        availableGear.append(boneSickle)
        let skullHelm = Gear(name: "Skull Helm", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "3", affinities: [.redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you suffer a severe head injury, the Skull Helm is destroyed. Archive this card."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [skull:1], locationRequirement: boneSmith, overlappingResources: [.bone])
        availableGear.append(skullHelm)
        // Catarium gear
        let catEyeCirclet = Gear(name: "Cat Eye Circlet", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation to reveal the next 3 monster hit locations and return them in any order."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [eyeOfCat:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(catEyeCirclet)
        let catFangKnife = Gear(name: "Cat Fang Knife", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n6+\n2", affinities: [.redLeft, .redUp, .redRight, .redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With any 3 red affinities: On a ").bold("Perfect hit").normal(", gain +1 strength token. When knocked down, remove all your +1 strength tokens."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:4], resourceSpecialRequirements: [elderCatTeeth:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(catFangKnife)
        let catGutBow = Gear(name: "Cat Gut Bow", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n7+\n3", affinities: [.blueUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Cumbersome. Range 6\n\nAim").normal(": When you attack, before rolling to hit, you may reduce the speed of this weapon by 1 to gain +2 accuracy for this attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [sinew:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(catGutBow)
        let clawHeadArrow = Gear(name: "Claw Head Arrow", description: GearDescription(type: .item, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n6", affinities: [.blueRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Slow, Ammo - Bow").normal(". You must have a bow in your gear grid to activate this.\n\nIf you hit, the monster gains a -1 evasion token. Use once per showdown."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [lionClaw:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(clawHeadArrow)
        let frenzyDrink = Gear(name: "Frenzy Drink", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation to ").bold("Consume").normal(": Suffer ").bold("Frenzy").normal(" brain trauma. Can be used once per showdown"))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [lionTestes:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(frenzyDrink)
        let kingSpear = Gear(name: "King Spear", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n3", affinities: [.redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Reach 2").normal(": May attack from 2 spaces away."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [greatCatBone:1, lionClaw:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(kingSpear)
        let lionBeastKatar = Gear(name: "Lion Beast Katar", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n7+\n3", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Deadly").normal(": +1 luck with this weapon.\n\n").bold("Paired").normal(": When you attack, add the speed of a 2nd Lion Beast Katar in your gear grid."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [lionClaw:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(lionBeastKatar)
        let lionHeaddress = Gear(name: "Lion Headdress", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "1", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Accessory").normal(": You may wear this in addition to 1 armor at this hit location."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [shimmeringMane:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(lionHeaddress)
        let lionSkinCloak = Gear(name: "Lion Skin Cloak", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "0", affinities: [.greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Reduce damage from every hit suffered by 1, to a minimum of 1."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [whiteFur:2], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(lionSkinCloak)
        let whiskerHarp = Gear(name: "Whisker Harp", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", all survivors gain +1 survival.\n\nSpend an action to Strum: Roll 1d10. On a result of 6+, discard 1 ").bold("mood").normal(" currently in play."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [goldenWhiskers:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(whiskerHarp)
        let whiteLionBoots = Gear(name: "White Lion Boots", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "2", affinities: [.redRight, .redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With 2 red puzzle affinities: +1 movement."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [whiteFur:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(whiteLionBoots)
        let whiteLionCoat = Gear(name: "White Lion Coat", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "2", affinities: [.blueUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Pounce").normal(": Spend an activation and a movement to move 3 spaces in a straight line. Then, if you moved 3 spaces, activate a melee weapon with +1 strength."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [whiteFur:1], locationRequirement: catarium, overlappingResources: [.hide])
        availableGear.append(whiteLionCoat)
        let whiteLionGauntlet = Gear(name: "White Lion Gauntlet", description: GearDescription(type: .armor, statsLeft: "Arms:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("Pounce").normal(", gain +1 accuracy for your next attack this turn."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [whiteFur:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(whiteLionGauntlet)
        let whiteLionHelm = Gear(name: "White Lion Helm", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "2", affinities: [.redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With red puzzle and any blue affinity: Spend an action and 1 survival to ").bold("Roar").normal(": Non-Deaf Insane survivors gain +2 strength until the end of round. All other survivors gain +1 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [greatCatBone:1, whiteFur:1], locationRequirement: catarium, overlappingResources: [.none])
        availableGear.append(whiteLionHelm)
        let whiteLionSkirt = Gear(name: "White Lion Skirt", description: GearDescription(type: .armor, statsLeft: "Waist:", statsRight: "2", affinities: [.redLeft, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal(""))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [whiteFur:1], locationRequirement: catarium, overlappingResources: [.hide])
        availableGear.append(whiteLionSkirt)
        // Exhausted Lantern Hoard Gear
        let oxidizedBeaconShield = Gear(name: "Oxidized Beacon Shield", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n6", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("+2 armor to all hit locations.\n\n").bold("Deflect 2").normal(": Spend an activation - you now have exactly 2 deflect tokens. The next 2 times you are hit, ignore a hit and lose 1 deflect token."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .endeavor:1, .hide:1, .organ:3], resourceSpecialRequirements: [beaconShieldResource:1, blackLichen:1, cocoonMembrane:1, iron:2, leather:3], locationRequirement: exhaustedLanternHoard, overlappingResources: [.bone, .organ, .hide])
        availableGear.append(oxidizedBeaconShield)
        let oxidizedLanternDagger = Gear(name: "Oxidized Lantern Dagger", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n6+\n4", affinities: [.redLeft, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Sharp, Paired").normal("\n\nWith 1 red puzzle affinity and any other red affinity: On a ").bold("Perfect hit").normal(", gain +1 survival."))), qtyAvailable: 4, resourceTypeRequirements: [.bone:3, .endeavor:1, .hide:4, .organ:3], resourceSpecialRequirements: [blackLichen:1, cocoonMembrane:1, iron:1, lanternDaggerResource:1, leather:3], locationRequirement: exhaustedLanternHoard, overlappingResources: [.bone, .hide, .organ])
        availableGear.append(oxidizedLanternDagger)
        let oxidizedLanternGlaive = Gear(name: "Oxidized Lantern Glaive", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n5+\n6", affinities: [.greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Sharp, Reach 2").normal("\n\nWith a green puzzle and any red affinity: On a ").bold("Perfect hit").normal(", the edge sharpens. This weapon gains +4 strength for this attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:7, .endeavor:1, .organ:3], resourceSpecialRequirements: [blackLichen:1, cocoonMembrane:1, iron:1, lanternGlaiveResource:1, leather:3], locationRequirement: exhaustedLanternHoard, overlappingResources: [.bone, .hide, .organ])
        availableGear.append(oxidizedLanternGlaive)
        let oxidizedLanternHelm = Gear(name: "Oxidized Lantern Helm", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "6", affinities: [.blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With blue puzzle and any red affinity: If you are not ").bold("deaf").normal(", you may ignore effects that target ").bold("non-deaf").normal(" survivors."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:7, .endeavor:1, .organ:3], resourceSpecialRequirements: [blackLichen:1, cocoonMembrane:1, iron:1, lanternHelmResource:1, leather:3], locationRequirement: exhaustedLanternHoard, overlappingResources: [.bone, .organ])
        availableGear.append(oxidizedLanternHelm)
        let oxidizedLanternSword = Gear(name: "Oxidized Lantern Sword", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n5+\n5", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Sharp.\n\nDeflect 1").normal(": Spend an activation - you now have exactly 1 deflect token. The next 1 time you are hit, ignore that hit and lose 1 deflect token."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .endeavor:1, .organ:3], resourceSpecialRequirements: [blackLichen:1, cocoonMembrane:1, lanternSwordResource:1, lanternTube:1, leather:3], locationRequirement: exhaustedLanternHoard, overlappingResources: [.bone, .organ])
        availableGear.append(oxidizedLanternSword)
        let oxidizedRingWhip = Gear(name: "Oxidixed Ring Whip", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n5+\n3", affinities: [.blueLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Sharp, Reach 2\n\n").normal("With 1 blue puzzle and any 3 red affinities - ").bold("Provoke").normal(": When you wound with this weapon, gain the Priority Target token."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .endeavor:1, .organ:7], resourceSpecialRequirements: [blackLichen:1, cocoonMembrane:1, iron:1, ringWhipResource:1], locationRequirement: exhaustedLanternHoard, overlappingResources: [.bone, .organ])
        availableGear.append(oxidizedRingWhip)
        let survivorsLantern = Gear(name: "Survivors' Lantern", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.redLeft, .greenRight, .blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal(""))), qtyAvailable: 4, resourceTypeRequirements: [.endeavor:1], resourceSpecialRequirements: [finalLanternResource:1], locationRequirement: exhaustedLanternHoard, overlappingResources: [.none])
        availableGear.append(survivorsLantern)
        // Leather Worker Gear
        let hunterWhip = Gear(name: "Hunter Whip", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n6+\n3", affinities: [.blueUp, .blueRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With two blue puzzle affinities - On a ").bold("Perfect hit").normal(", discard 1 mood in play."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [leather:2], locationRequirement: leatherWorker, overlappingResources: [.none])
        availableGear.append(hunterWhip)
        let leatherBoots = Gear(name: "Leather Boots", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "3", affinities: [.greenLeft, .greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With two green puzzle affinities - At the end of your act, you may move 1 space."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [leather:1], locationRequirement: leatherWorker, overlappingResources: [.hide])
        availableGear.append(leatherBoots)
        let leatherBracers = Gear(name: "Leather Bracers", description: GearDescription(type: .armor, statsLeft: "Arms:", statsRight: "3", affinities: [.greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 survival."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [leather:1], locationRequirement: leatherWorker, overlappingResources: [.hide])
        availableGear.append(leatherBracers)
        let leatherCuirass = Gear(name: "Leather Cuirass", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "3", affinities: [.redUp, .blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal(""))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [leather:1], locationRequirement: leatherWorker, overlappingResources: [.none])
        availableGear.append(leatherCuirass)
        let leatherMask = Gear(name: "Leather Mask", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "3", affinities: [.blueUp, .redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [leather:1, scrap:1], locationRequirement: leatherWorker, overlappingResources: [.none])
        availableGear.append(leatherMask)
        let leatherSkirt = Gear(name: "Leather Skirt", description: GearDescription(type: .armor, statsLeft: "Waist:", statsRight: "3", affinities: [.greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal(""))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [leather:1], locationRequirement: leatherWorker, overlappingResources: [.none])
        availableGear.append(leatherSkirt)
        let roundLeatherShield = Gear(name: "Round Leather Shield", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n8+\n1", affinities: [.greenUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Add +1 armor to all hit locations.\n\n").bold("Block 1").normal(": Spend an activation to ignore 1 hit the next time you are attacked. Lasts until your next act. You cannot use block more than once per attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .hide:1], resourceSpecialRequirements: [leather:1], locationRequirement: leatherWorker, overlappingResources: [.hide])
        availableGear.append(roundLeatherShield)
        // Mask Maker Gear
        let antelopeMask = Gear(name: "Antelope Mask", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Unique, Irreplaceable, Accessory").normal("\n\nWith any two red and any two blue affinities - At the start of your act, if insane, gain an activation."))), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [pelt:1], locationRequirement: maskMaker, overlappingResources: [.none])
        availableGear.append(antelopeMask)
        let deathMask = Gear(name: "Death Mask", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Unique, irreplaceable, Accessory").normal("\n\nIf you have no affinities, gain +4 luck and suffer -4 to all severe injury rolls. Must lose 1 population upon crafting!"))), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], locationRequirement: maskMaker, overlappingResources: [.none])
        availableGear.append(deathMask)
        let godMask = Gear(name: "God Mask", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Unique, Irreplaceable, Accessory").normal("\n\nWith two of each affinity - At the start of your act, if ").bold("insane").normal(", gain +1 survival."))), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [foundingStoneResource:1], locationRequirement: maskMaker, overlappingResources: [.none])
        availableGear.append(godMask)
        let manMask = Gear(name: "Man Mask", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Unique, Irreplaceable, Accessory").normal("\n\nWith any one red and any one green affinity - If ").bold("insane").normal(", you may spend negative attribute tokens in place of insanity."))), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [skull:1], locationRequirement: maskMaker, overlappingResources: [.bone])
        availableGear.append(manMask)
        let phoenixMask = Gear(name: "Phoenix Mask", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Unique, Irreplaceable, Accessory").normal("\n\nWith any four red affinities - If ").bold("insane").normal(", you may dodge 1 additional time per round."))), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [smallFeathers:1], locationRequirement: maskMaker, overlappingResources: [.none])
        availableGear.append(phoenixMask)
        let whiteLionMask = Gear(name: "White Lion Mask", description: GearDescription(type: .item, statsLeft: "Head:", statsRight: "2", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Unique, Irreplaceable, Accessory").normal("\n\nWith any two green affinities - If ").bold("insane").normal(", spend an activation to lose all your survival and gain that many +1 Strength tokens."))), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [shimmeringMane:1], locationRequirement: maskMaker, overlappingResources: [.none])
        availableGear.append(whiteLionMask)
        // Organ Grinder Gear
        let driedAcanthus = Gear(name: "Dried Acanthus", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 survival. When you suffer a severe injury, ignore it and archive this card instead."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [freshAcanthus:1], locationRequirement: organGrinder, overlappingResources: [.none])
        availableGear.append(driedAcanthus)
        let fecalSalve = Gear(name: "Fecal Salve", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 survival. Spend an activation: you are not a ").bold("threat").normal(" until you attack. If you have the ").bold("priority target").normal(" token, remove it."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], locationRequirement: organGrinder, overlappingResources: [.none])
        availableGear.append(fecalSalve)
        let luckyCharm = Gear(name: "Lucky Charm", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft, .blueRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With any two blue affinities - +1 luck."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], locationRequirement: organGrinder, overlappingResources: [.none])
        availableGear.append(luckyCharm)
        let monsterGrease = Gear(name: "Monster Grease", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.greenLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Gain +1 evasion. With any three green affninities - gain another +1 evasion."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], locationRequirement: organGrinder, overlappingResources: [.none])
        availableGear.append(monsterGrease)
        let monsterToothNecklace = Gear(name: "Monster Tooth Necklace", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Gain +1 strength. With any two red affinities - gain another +1 strength."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [scrap:1], innovationRequirement: lanternOven, locationRequirement: organGrinder, overlappingResources: [.none])
        availableGear.append(monsterToothNecklace)
        let stoneNoses = Gear(name: "Stone Noses", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On ").bold("arrival").normal(", gain +1 survival and +1 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [.endeavor:1], locationRequirement: organGrinder, overlappingResources: [.none])
        availableGear.append(stoneNoses)
        // Plumery Gear
        let arcBow = Gear(name: "Arc Bow", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n9", affinities: [.redLeft, .greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Slow, Range 6.\n\nCumbersome").normal(": Spend a movement as an additional cost of activating this weapon. With a red and a green puzzle affinity plus any blue affinity - Range +2"))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [phoenixWhisker:1, scrap:1, wishbone:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(arcBow)
        let birdBread = Gear(name: "Bird Bread", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation to ").bold("Consume").normal(": Once per showdown, add +1 armor to all hit locations. Gain the ").bold("priority target").normal(" token. Roll 1d10. On a 1, reduce your survival to 0."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:3], resourceSpecialRequirements: [pustules:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(birdBread)
        let bloomSphere = Gear(name: "Bloom Sphere", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.greenLeft, .blueRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With green and blue puzzle affinity - When you are picked as a target, roll 1d10. On a 6+, the monster must pick a new target if possible."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:3], resourceSpecialRequirements: [smallHandParasites:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(bloomSphere)
        let crestCrown = Gear(name: "Crest Crown", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.redLeft, .blueUp, .greenRight, .blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation: If ").bold("insane").normal(", reshuffle the hit location deck. With two blue and one red puzzle affinities - When you depart, gain +1 insanity and +1 survival for every blue affinity you have."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:6], resourceSpecialRequirements: [phoenixCrest:1], locationRequirement: plumery, overlappingResources: [.organ])
        availableGear.append(crestCrown)
        let featherMantle = Gear(name: "Feather Mantle", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft, .greenRight, .redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you suffer ").bold("knockback").normal(", you may ignore collision with other survivors and reduce the movement by up to 3 spaces."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [scrap:1, tailFeathers:2], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(featherMantle)
        let featherShield = Gear(name: "Feather Shield", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n7+\n0", affinities: [.blueUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Block 1").normal("\n\nWith any one red, one green, and one blue affinity - Reduce any suffered brain damage by 1 to a minimum of 1."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [muculentDroppings:1, smallFeathers:2], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(featherShield)
        let hollowSword = Gear(name: "Hollow Sword", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n5+\n3", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Frail, Paired").normal("\n\nOn a ").bold("Perfect hit").normal(", make 1 additional attack roll."))), qtyAvailable: 4, resourceTypeRequirements: [.bone:2, .hide:2], resourceSpecialRequirements: [hollowWingBones:1], locationRequirement: plumery, overlappingResources: [.bone])
        availableGear.append(hollowSword)
        let hollowpointArrow = Gear(name: "Hollowpoint Arrow", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n11", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Slow, Ammo - Bow").normal("\n\nOn a hit, monster gains -1 movement token. Use once per showdown."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [hollowWingBones:1, scrap:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(hollowpointArrow)
        let hoursRing = Gear(name: "Hours Ring", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Unique").normal("\n\nDuring the aftermath, if you died or ceased to exist, you may archive the Hours Ring and reset the campaign to the previous Settlement Phase's develop step before you departed."))), qtyAvailable: 1, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [shimmeringHalo:1], locationRequirement: plumery, overlappingResources: [.organ])
        availableGear.append(hoursRing)
        let phoenixFaulds = Gear(name: "Phoenix Faulds", description: GearDescription(type: .armor, statsLeft: "Waist:", statsRight: "4", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], resourceSpecialRequirements: [iron:1, leather:1, tailFeathers:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(phoenixFaulds)
        let phoenixGauntlets = Gear(name: "Phoenix Gauntlets", description: GearDescription(type: .armor, statsLeft: "Arms:", statsRight: "4", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [iron:1, leather:1, smallFeathers:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(phoenixGauntlets)
        let phoenixGreaves = Gear(name: "Phoenix Greaves", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "4", affinities: [.redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("If ").bold("insane").normal(", gain +2 movement."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], resourceSpecialRequirements: [iron:1, leather:1, smallFeathers:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(phoenixGreaves)
        let phoenixHelm = Gear(name: "Phoenix Helm", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "4", affinities: [.blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With one blue puzzle affinity, any one red and any one green affinity - If ").bold("insane").normal(" at the start of the showdown, gain +1 evasion token."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [hollowWingBones:1, smallFeathers:1], locationRequirement: plumery, overlappingResources: [.bone])
        availableGear.append(phoenixHelm)
        let phoenixPlackart = Gear(name: "Phoenix Plackart", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "4", affinities: [.greenLeft, .blueUp, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With red, green, and blue puzzle affinities - If ").bold("insane").normal(", ignore the first hit each round and suffer 1 brain damage instead."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [iron:1, leather:1, tailFeathers:1], locationRequirement: plumery, overlappingResources: [.hide])
        availableGear.append(phoenixPlackart)
        let sonicTomahawk = Gear(name: "Sonic Tomahawk", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n5+\n2", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", make 1 additional attack roll. With one red puzzle affinity, any two green affinities and any one blue affinity - Gain ").bold("Savage").normal(" and ").bold("Paired").normal("."))), qtyAvailable: 4, resourceTypeRequirements: [:], resourceSpecialRequirements: [hollowWingBones:1, scrap:1, smallFeathers:1], locationRequirement: plumery, overlappingResources: [.none])
        availableGear.append(sonicTomahawk)
        // Skinnery Gear
        let bandages = Gear(name: "Bandages", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueLeft, .greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation to remove up to 2 bleeding tokens from yourself or an adjacent survivor."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(bandages)
        let rawhideBoots = Gear(name: "Rawhide Boots", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "1", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 survival."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhideBoots)
        let rawhideDrum = Gear(name: "Rawhide Drum", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.greenLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", all survivors gain +1 insanity. Inspirational Drumming! When you perform ").bold("encourage").normal(", all non-deaf survivors are affected."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .hide:1], innovationRequirement: drums, locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhideDrum)
        let rawhideGloves = Gear(name: "Rawhide Gloves", description: GearDescription(type: .armor, statsLeft: "Arms:", statsRight: "1", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("When you ").bold("Depart").normal(", gain +1 survival."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhideGloves)
        let rawhideHeadband = Gear(name: "Rawhide Headband", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "1", affinities: [.blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With one blue puzzle affinity - Spend an activation to reveal the top two AI cards. Place them back on the AI deck in any order."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhideHeadband)
        let rawhidePants = Gear(name: "Rawhide Pants", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "1", affinities: [.blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal(""))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhidePants)
        let rawhideVest = Gear(name: "Rawhide Vest", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "1", affinities: [.redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With one blue and one red puzzle affinity - Gain +1 evasion."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhideVest)
        let rawhideWhip = Gear(name: "Rawhide Whip", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n7+\n1", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Provoke").normal(": When you wound with this weapon, gain the ").bold("priority target").normal(" token."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .hide:1], innovationRequirement: ammonia, locationRequirement: skinnery, overlappingResources: [.none])
        availableGear.append(rawhideWhip)
        // Stone Circle Gear
        let beastKnuckle = Gear(name: "Beast Knuckle", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n4", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Paired").normal("\n\nWhen you wound with this weapon, monster gains -1 toughness until end of the attack."))), qtyAvailable: 4, resourceTypeRequirements: [:], resourceSpecialRequirements: [largeFlatTooth:1, pelt:1], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(beastKnuckle)
        let bloodPaint = Gear(name: "Blood Paint", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation to activate weapon gear to the left and right of this card. These are two separate attacks. Cannot be used with two-handed weapons."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], resourceSpecialRequirements: [bladder:1], innovationRequirement: paint, locationRequirement: stoneCircle, overlappingResources: [.organ])
        availableGear.append(bloodPaint)
        let blueCharm = Gear(name: "Blue Charm", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.oneBlue], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With any five blue affinities - ").bold("Unshakeable").normal(": When you draw a trap, roll 1d10. On a 6+, discard the trap and reshuffle the deck."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(blueCharm)
        let boneEarrings = Gear(name: "Bone Earrings", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("At the start of the showdown, gain +2 speed and +2 strength tokens if ").bold("insane").normal(" and all gear in your gear grid has the bone keyword."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [shankBone:1], locationRequirement: stoneCircle, overlappingResources: [.bone])
        availableGear.append(boneEarrings)
        let bossMehndi = Gear(name: "Boss Mehndi", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Boss is brave. While adjacent to you, ").bold("insane").normal(" survivors gain +1 speed."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [goldenWhiskers:1], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(bossMehndi)
        let greenCharm = Gear(name: "Green Charm", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.oneGreen], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With any five green affinities - ").bold("Undeathable").normal(": If you would die, roll 1d10. On a 6+, you inexplicably survive."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(greenCharm)
        let lanceOfLonginus = Gear(name: "Lance of Longinus", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n9", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Irreplaceable, Reach 2").normal("\n\nEach showdown, the first time you wound, the monster gains a -1 toughness token."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:6], resourceSpecialRequirements: [legendaryHorns:1], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(lanceOfLonginus)
        let redCharm = Gear(name: "Red Charm", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.oneRed], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("With any five red affinities - ").bold("Unstoppable").normal(": When you attempt to wound, instead roll 1d10. On a 1 - 5, fail. On a 6 - 10, wound."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(redCharm)
        let screamingBracers = Gear(name: "Screaming Bracers", description: GearDescription(type: .armor, statsLeft: "Arms:", statsRight: "2", affinities: [.redLeft, .greenUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", if possible, add an ").bold("Acanthus Plant").normal(" terrain card to the showdown. When you activate terrain, you may add +2 to your roll result."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [pelt:1], locationRequirement: stoneCircle, overlappingResources: [.hide])
        availableGear.append(screamingBracers)
        let screamingCoat = Gear(name: "Screaming Coat", description: GearDescription(type: .armor, statsLeft: "Body:", statsRight: "2", affinities: [.greenLeft, .blueUp, .blueRight, .greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Slam").normal(": Spend an activation to full move forward in a straight line. If you move 4+ spaces and stop adjacent to a monster, it suffers knockback 1 and -1 toughness until the end of the round."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [pelt:1], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(screamingCoat)
        let screamingHorns = Gear(name: "Screaming Horns", description: GearDescription(type: .armor, statsLeft: "Head:", statsRight: "3", affinities: [.blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Spend an activation to ").bold("Scream").normal(": Non-deaf insane survivors gain+1 movement until end of round. All other survivors gain +1 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [scrap:1, spiralHorn:1], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(screamingHorns)
        let screamingLegWarmers = Gear(name: "Screaming Leg Warmers", description: GearDescription(type: .armor, statsLeft: "Legs:", statsRight: "2", affinities: [.blueUp, .redRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", your feet hurt. Gain +3 insanity."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [pelt:1], locationRequirement: stoneCircle, overlappingResources: [.hide])
        availableGear.append(screamingLegWarmers)
        let screamingSkirt = Gear(name: "Screaming Skirt", description: GearDescription(type: .armor, statsLeft: "Waist:", statsRight: "3", affinities: [.greenRight, .blueDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("Thick, protective fur protects your parts. Add +1 to severe waist injury roll results."))), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [pelt:1], locationRequirement: stoneCircle, overlappingResources: [.none])
        availableGear.append(screamingSkirt)
        // Weapon Crafter Gear
        let bloodSheath = Gear(name: "Blood Sheath", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.none], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Block 1").normal("\n\nWhen Rainbow Katana is left of Blood Sheath, it loses Frail and gains Sharp (add 1d10 strength to each wound attempt)."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [hollowWingBones:1, muculentDroppings:1], locationRequirement: weaponCrafter, overlappingResources: [.organ])
        availableGear.append(bloodSheath)
        let counterweightedAxe = Gear(name: "Counterweighted Axe", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n6+\n4", affinities: [.redUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().boldCenter("Reach 2").normal("\n\nWith one red puzzle affinity - On a ").bold("Perfect hit").normal(", do not draw a hit location. Monster suffers 1 wound."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .hide:1, .organ:1], locationRequirement: weaponCrafter, overlappingResources: [.none])
        availableGear.append(counterweightedAxe)
        let fingerOfGod = Gear(name: "Finger of God", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n5+\n5", affinities: [.redUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Reach 2").normal("\n\nWith any one red, any one green, and any one blue affinity - As long as you have 5+ survival, gain +1 accuracy and +1 strength."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [phoenixFinger:1], locationRequirement: weaponCrafter, overlappingResources: [.bone])
        availableGear.append(fingerOfGod)
        let rainbowKatana = Gear(name: "Rainbow Katana", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "4\n4+\n4", affinities: [.redLeft], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Frail").normal("\n\nWith one red puzzle affinity and any one green and any one blue affinity - Gains ").bold("Deadly").normal("."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:6], resourceSpecialRequirements: [birdBeak:1, iron:1, rainbowDroppings:1], innovationRequirement: lanternOven, locationRequirement: weaponCrafter, overlappingResources: [.bone])
        availableGear.append(rainbowKatana)
        let scrapDagger = Gear(name: "Scrap Dagger", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n7+\n2", affinities: [.redRight, .redDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", the edge sharpens. Gain +2 strength for the rest of the attack."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [scrap:1], innovationRequirement: lanternOven, locationRequirement: weaponCrafter, overlappingResources: [.none])
        availableGear.append(scrapDagger)
        let scrapSword = Gear(name: "Scrap Sword", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n5+\n3", affinities: [.blueUp], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", the edge sharpens. Gain +4 strength for the rest of the attack. With any two red and any one blue affinity - Gains Deadly."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [scrap:1], innovationRequirement: lanternOven, locationRequirement: weaponCrafter, overlappingResources: [.none])
        availableGear.append(scrapSword)
        let skullcapHammer = Gear(name: "Skullcap Hammer", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "2\n7+\n3", affinities: [.greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", the monster is dazed, and gains -1 speed token until the end of its turn. A monster can be dazed once per round."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [scrap:1], locationRequirement: weaponCrafter, overlappingResources: [.none])
        availableGear.append(skullcapHammer)
        let whistlingMace = Gear(name: "Whistling Mace", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "3\n6+\n3", affinities: [.greenDown], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", reveal the next AI card. Place it on the top or bottom of the AI deck. Unwieldy: If any attack roll results are 1, you hit yourself and suffer 1 damage."))), qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .organ:1], locationRequirement: weaponCrafter, overlappingResources: [.none])
        availableGear.append(whistlingMace)
        let zanbato = Gear(name: "Zanbato", description: GearDescription(type: .weapon, statsLeft: "Speed:\nAccuracy:\nPower:", statsRight: "1\n6+\n6", affinities: [.redUp, .greenRight], detailText: WrappedString(nsAttributedString: NSMutableAttributedString().bold("Slow, Frail, Deadly").normal("\n\nWith one red puzzle affinity and one green affinity - Gains Devastating 1: Whenever you wound, inflict one additional wound."))), qtyAvailable: 3, resourceTypeRequirements: [.hide:2], resourceSpecialRequirements: [greatCatBone:1], locationRequirement: weaponCrafter, overlappingResources: [.none])
        availableGear.append(zanbato)
        
        // Initialize settlement libraries
        initializeDictionaries()

    }
    
    func initializeDictionaries() {
        for gear in availableGear {
            gearCraftedDict[gear] = 0
        }
        for resource in allResources {
            resourceStorage[resource] = 0
        }
        for innovation in self.availableInnovations {
            innovationsAddedDict[innovation] = false
        }
        for location in self.allLocations {
            if location.name == "Lantern Hoard" {
                locationsBuiltDict[location] = true
            } else {
                locationsBuiltDict[location] = false
            }
        }
    }
    
    @objc func onUbiquitousKeyValueStoreDidChangeExternally(notification:Notification)
    {
        print("KVS updated!")
    }
}
