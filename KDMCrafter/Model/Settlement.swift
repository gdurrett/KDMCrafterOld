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

class Settlement {
    
    // For the settlement object
    let name: String
    var resourceStorage = [Resource:Int]()
    var allLocations = [barberSurgeon, blackSmith, boneSmith, catarium, exhaustedLanternHoard, lanternHoard, leatherWorker, maskMaker, organGrinder, plumery, skinnery, stoneCircle, weaponCrafter]
    var locationsBuiltDict = [Location:Bool]()
    var gearCraftedDict = [Gear:Int]()
    var builtLocations = [Location]()
    var availableLocations = [Location]()
    var availableGear = [Gear]()
    var availableInnovations = [Innovation]()
    var innovationsAddedDict = [Innovation:Bool]()
    var overrideEnabled = false
    
    init(name: String) {
        
        // Gotta have a name!
        self.name = name
        
        // Initialize storage with zero of everything
        self.resourceStorage = [endeavor:0, multi:0, brokenLantern:0, loveJuice:0, monsterBone:0, monsterHide:0, monsterOrgan:0, scrap:0, skull:0, beaconShieldResource:0, birdBeak:0, blackSkull:0, hollowWingBones:0, lanternDaggerResource:0, lanternGlaiveResource:0, lanternHelmResource:0, lanternSwordResource:0, finalLanternResource:0, foundingStoneResource:0, ringWhipResource:0, muculentDroppings:0, phoenixEye:0, phoenixFinger:0, phoenixWhisker:0, pustules:0, rainbowDroppings:0, shimmeringHalo:0, smallFeathers:0, smallHandParasites:0, tailFeathers:0, wishbone:0, beastSteak:0, bladder:0, largeFlatTooth:0, musclyGums:0, pelt:0, screamingBrain:0, shankBone:0, spiralHorn:0, blackLichen:0, cocoonMembrane:0, elderCatTeeth:0, freshAcanthus:0, iron:0, lanternTube:0, leather:0, legendaryHorns:0, perfectCrucible:0, phoenixCrest:0, secondHeart:0, crabSpider:0, cyclopsFly:0, hissingCockroach:0, lonelyAnt:0, nightmareTick:0, swordBeetle:0, curiousHand:0, eyeOfCat:0, goldenWhiskers:0, greatCatBone:0, lionClaw:0, lionTail:0, lionTestes:0, shimmeringMane:0, sinew:0, whiteFur:0]

        // Initialize locations with the starter Lantern Hoard
        locationsBuiltDict[barberSurgeon] = false
        locationsBuiltDict[blackSmith] = false
        locationsBuiltDict[boneSmith] = false
        locationsBuiltDict[catarium] = false
        locationsBuiltDict[exhaustedLanternHoard] = false
        locationsBuiltDict[lanternHoard] = true
        locationsBuiltDict[leatherWorker] = false
        locationsBuiltDict[maskMaker] = false
        locationsBuiltDict[organGrinder] = false
        locationsBuiltDict[plumery] = false
        locationsBuiltDict[skinnery] = false
        locationsBuiltDict[stoneCircle] = false
        locationsBuiltDict[weaponCrafter] = false
        
        // Innovation declarations
        let ammonia = Innovation(name: "Ammonia")
        availableInnovations.append(ammonia)
        let drums = Innovation(name: "Drums")
        availableInnovations.append(drums)
        let heat = Innovation(name: "Heat")
        availableInnovations.append(heat)
        let paint = Innovation(name: "Paint")
        availableInnovations.append(paint)
        let pictograph = Innovation(name: "Pictograph")
        availableInnovations.append(pictograph)
        let pottery = Innovation(name: "Pottery")
        availableInnovations.append(pottery)
        
        // Initialize innovationsAdded dict
        for innovation in self.availableInnovations {
            innovationsAddedDict[innovation] = false
        }
        
        // Initialize available gear
        // Barber Surgeon Gear
        let almanac = Gear(name: "Almanac", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueRight], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 insanity. You cannot gain disorders.")), qtyAvailable: 3, resourceTypeRequirements: [.leather:2], innovationRequirement: pictograph, locationRequirement: barberSurgeon)
        availableGear.append(almanac)
        let bugTrap = Gear(name: "Bug Trap", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("At the start of the showdown, roll 1d10. On a roll of 3+, add a ").bold("Bug Patch ").normal("terrain to the showdown board.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [.musclyGums:1], locationRequirement: barberSurgeon)
        availableGear.append(bugTrap)
        let brainMint = Gear(name: "Brain Mint", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft, .greenUp], detailText: NSMutableAttributedString().normal("Spend an action to ").bold("Consume").normal(": Remove all your tokens and stand up. You may use this while knocked down, once per showdown.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.screamingBrain:1], locationRequirement: barberSurgeon)
        availableGear.append(brainMint)
        let elderEarrings = Gear(name: "Elder Earrings", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.redLeft, .greenRight, .blueDown], detailText: NSMutableAttributedString().normal("At the start of ").bold("showdown").normal(", gain +2 survival. Gain +1 Hunt XP after showdown.")), qtyAvailable: 3, resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [.shankBone:1], locationRequirement: barberSurgeon)
        availableGear.append(elderEarrings)
        let firstAidKit = Gear(name: "First Aid Kit", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.greenLeft, .greenRight, .greenUp, .greenDown], detailText: NSMutableAttributedString().normal("On ").bold("arrival").normal(", all survivors gain +3 survival. Spend an action: remove 1 bleeding or negative attribute token from yourself or an adjacent survivor.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .leather:1], locationRequirement: barberSurgeon)
        availableGear.append(firstAidKit)
        let muskBomb = Gear(name: "Musk Bomb", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("If adjacent to monster when it draws an AI card, you may spend 2 survival and archive Musk Bomb to roll 1d10. On a 3+, discard the AI card without playing it.")), qtyAvailable: 3, resourceTypeRequirements: [.any : 7], innovationRequirement: pottery, locationRequirement: barberSurgeon)
        availableGear.append(muskBomb)
        let scavengerKit = Gear(name: "Scavenger Kit", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.greenDown], detailText: NSMutableAttributedString().bold("Unique").normal("When you defeat a monster, gain either 1 random basic resource or 1 random monster resource from that monster's resource deck.")), qtyAvailable: 1,  resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [.pelt:1], locationRequirement: barberSurgeon)
        availableGear.append(scavengerKit)
        let speedPowder = Gear(name: "Speed Powder", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueRight], detailText: NSMutableAttributedString().normal("Spend 1 activation to suffer 2 brain damage. Gain 1 speed token. Use once per showdown.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:2], resourceSpecialRequirements: [.secondHeart:1], locationRequirement: barberSurgeon)
        availableGear.append(speedPowder)
        // Blacksmith Gear
        let beaconShield = Gear(name: "Beacon Shield", description: GearDescription(type: .weapon, stats: .weapon(1, 6, 5), affinities: [.none], detailText: NSMutableAttributedString().normal("Add 2 armor to all hit locations.\n\n").bold("Block 2").normal(": Spend an activation to ignore 2 hits the next time you are attacked. Lasts until your next act. You cannot use ").bold("block").normal(" more than once per attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [.iron:2, .leather:3], locationRequirement: blackSmith)
        availableGear.append(beaconShield)
        let dragonSlayer = Gear(name: "Dragon Slayer", description: GearDescription(type: .weapon, stats: .weapon(1, 6, 9), affinities: [.blueUp, .redRight], detailText: NSMutableAttributedString().bold("Frail, Slow, Sharp, Devastating 1.\n\nEarly Iron)").normal(": When an attack roll result is 1, cancel any hits and end the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [.iron:5], innovationRequirement: paint, locationRequirement: blackSmith)
        availableGear.append(dragonSlayer)
        let lanternCuirass = Gear(name: "Lantern Cuirass", description: GearDescription(type: .armor, stats: .armor(5, .body), affinities: [.greenLeft, .blueUp, .greenRight, .blueDown], detailText: NSMutableAttributedString().normal("-2 movement.\n\nWith two blue and two green puzzle affinities: When you depart, add 3 to all hit locations with metal armor.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.iron:2, .leather:5], locationRequirement: blackSmith)
        availableGear.append(lanternCuirass)
        let lanternDagger = Gear(name: "Lantern Dagger", description: GearDescription(type: .weapon, stats: .weapon(2, 7, 1), affinities: [.redLeft], detailText: NSMutableAttributedString().bold("Paired.\n\nSharp").normal(": Add 1d10 Strength to each wound attempt. Early Iron: When an attack roll result is 1, cancel any hits and end the attack.")), qtyAvailable: 4, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [.iron:2, .leather:3], locationRequirement: blackSmith)
        availableGear.append(lanternDagger)
        let lanternGauntlets = Gear(name: "Lantern Gauntlets", description: GearDescription(type: .armor, stats: .armor(5, .arms), affinities: [.greenLeft], detailText: NSMutableAttributedString().normal("With green puzzle affinity, +2 accuracy with club weapons.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.iron:2, .leather:6], locationRequirement: blackSmith)
        availableGear.append(lanternGauntlets)
        let lanternGlaive = Gear(name: "Lantern Glaive", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 4), affinities: [.greenDown], detailText: NSMutableAttributedString().bold("Reach 2.\n\nSharp").normal(": Add 1d10 Strength to each wound attempt. ").bold("Early Iron").normal(": When your attack roll result is 1, cancel any hits and end the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [.iron:2, .leather:2], locationRequirement: blackSmith)
        availableGear.append(lanternGlaive)
        let lanternGreaves = Gear(name: "Lantern Greaves", description: GearDescription(type: .armor, stats: .armor(5, .legs), affinities: [.redLeft, .blueUp, .redRight], detailText: NSMutableAttributedString().normal("With two red and one green puzzle affinity, +2 movement.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.iron:1, .leather:5], locationRequirement: blackSmith)
        availableGear.append(lanternGreaves)
        let lanternHelm = Gear(name: "Lantern Helm", description: GearDescription(type: .armor, stats: .armor(5, .head), affinities: [.blueDown], detailText: NSMutableAttributedString().normal("With blue puzzle affinity: Ear Plugs. You are ").bold("deaf").normal(". -1 accuracy.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:7], resourceSpecialRequirements: [.iron:1], locationRequirement: blackSmith)
        availableGear.append(lanternHelm)
        let lanternMail = Gear(name: "Lantern Mail", description: GearDescription(type: .armor, stats: .armor(5, .waist), affinities: [.greenRight], detailText: NSMutableAttributedString().normal("")), qtyAvailable: 3, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [.iron:1], locationRequirement: blackSmith)
        availableGear.append(lanternMail)
        let lanternSword = Gear(name: "Lantern Sword", description: GearDescription(type: .weapon, stats: .weapon(3, 5, 3), affinities: [.redLeft], detailText: NSMutableAttributedString().bold("Sharp").normal(": Add 1d10 Strength to each wound attempt. ").bold("Early Iron").normal(": When an attack roll result is 1, cancel any hits and end the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:4, .hide:3], resourceSpecialRequirements: [.iron:1], locationRequirement: blackSmith)
        availableGear.append(lanternSword)
        let perfectSlayer = Gear(name: "Perfect Slayer", description: GearDescription(type: .weapon, stats: .weapon(3, 6, 14), affinities: [.redDown], detailText: NSMutableAttributedString().bold("Slow, Sharp, Devastating 2, Irreplaceable").normal(". -2 movement.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [.iron:9, .perfectCrucible:1], locationRequirement: blackSmith)
        availableGear.append(perfectSlayer)
        let ringWhip = Gear(name: "Ring Whip", description: GearDescription(type: .weapon, stats: .weapon(2, 5, 0), affinities: [.blueLeft], detailText: NSMutableAttributedString().bold("Sharp, Reach 2\n\nEarly Iron").normal(": When an attack roll result is 1, cancel any hits and end the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .organ:3], resourceSpecialRequirements: [.iron:1], locationRequirement: blackSmith)
        availableGear.append(ringWhip)
        let scrapShield = Gear(name: "Scrap Shield", description: GearDescription(type: .weapon, stats: .weapon(2, 7, 3), affinities: [.redRight], detailText: NSMutableAttributedString().normal("Add +1 armor to all hit locations.\n\n").bold("Block 1").normal(": Spend an activation to ignore a hit the next time you are attacked. Lasts until your next act. You cannot use ").bold("block").normal(" more than once per attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3], resourceSpecialRequirements: [.leather:3, .scrap:2], locationRequirement: blackSmith)
        availableGear.append(scrapShield)
        // Bonesmith gear
        let boneAxe = Gear(name: "Bone Axe", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 3), affinities: [.redLeft], detailText: NSMutableAttributedString().bold("Frail\n\nSavage:").normal(": Once per attack, if you critically wound, cause 1 additional wound. This effect does not apply to impervious hit locations.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .organ:1], locationRequirement: boneSmith)
        availableGear.append(boneAxe)
        let boneBlade = Gear(name: "Bone Blade", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 2), affinities: [.redLeft], detailText: NSMutableAttributedString().bold("Frail").normal(": When you attempt to wound a super-dense hit location, this weapon breaks. Archive this card at the end of the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith)
        availableGear.append(boneBlade)
        let boneClub = Gear(name: "Bone Club", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 5), affinities: [.redLeft, .redRight], detailText: NSMutableAttributedString().bold("\nCumbersome").normal(": Spend a movement as an additional cost to activate this weapon. Ignore Cumbersome if this weapon is activated indirectly (Pounce, Charge, etc).")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3], locationRequirement: boneSmith)
        availableGear.append(boneClub)
        let boneDagger = Gear(name: "Bone Dagger", description: GearDescription(type: .weapon, stats: .weapon(3, 7, 1), affinities: [.redLeft, .redUp], detailText: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(" (lantern 10), gain +1 survival.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith)
        availableGear.append(boneDagger)
        let boneDarts = Gear(name: "Bone Darts", description: GearDescription(type: .weapon, stats: .weapon(3, 7, 1), affinities: [.redLeft, .redUp], detailText: NSMutableAttributedString().bold("Range").normal(": 6.\n\n").bold("Frail").normal(": When you attempt to wound a super-dense hit location, this weapon breaks. Archive this card at the end of the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith)
        availableGear.append(boneDarts)
        let bonePickaxe = Gear(name: "Bone Pickaxe", description: GearDescription(type: .weapon, stats: .weapon(1, 8, 2), affinities: [.greenUp], detailText: NSMutableAttributedString().normal("After Hunt phase setup, place the ").bold("Mineral Gathering").normal(" event on any hunt space.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.leather:1], innovationRequirement: ammonia, locationRequirement: boneSmith)
        availableGear.append(bonePickaxe)
        let boneSickle = Gear(name: "Bone Sickle", description: GearDescription(type: .weapon, stats: .weapon(2, 8, 1), affinities: [.greenUp], detailText: NSMutableAttributedString().normal("After Hunt phase setup, place the ").bold("Herb Gathering").normal(" event on any hunt space.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.leather:1], innovationRequirement: ammonia, locationRequirement: boneSmith)
        availableGear.append(boneSickle)
        let skullHelm = Gear(name: "Skull Helm", description: GearDescription(type: .armor, stats: .armor(3, .head), affinities: [.redDown], detailText: NSMutableAttributedString().normal("When you suffer a severe head injury, the Skull Helm is destroyed. Archive this card.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [.skull:1], locationRequirement: boneSmith)
        availableGear.append(skullHelm)
        // Catarium gear
        let catEyeCirclet = Gear(name: "Cat Eye Circlet", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft], detailText: NSMutableAttributedString().normal("Spend an activation to reveal the next 3 monster hit locations and return them in any order.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.eyeOfCat:1], locationRequirement: catarium)
        availableGear.append(catEyeCirclet)
        let catFangKnife = Gear(name: "Cat Fang Knife", description: GearDescription(type: .weapon, stats: .weapon(3, 6, 2), affinities: [.redLeft, .redUp, .redRight, .redDown], detailText: NSMutableAttributedString().normal("With any 3 red affinities: On a ").bold("Perfect hit").normal(", gain +1 strength token. When knocked down, remove all your +1 strength tokens.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:4], resourceSpecialRequirements: [.elderCatTeeth:1], locationRequirement: catarium)
        availableGear.append(catFangKnife)
        let catGutBow = Gear(name: "Cat Gut Bow", description: GearDescription(type: .weapon, stats: .weapon(2, 7, 3), affinities: [.blueUp], detailText: NSMutableAttributedString().bold("Cumbersome. Range 6\n\nAim").normal(": When you attack, before rolling to hit, you may reduce the speed of this weapon by 1 to gain +2 accuracy for this attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.sinew:1], locationRequirement: catarium)
        availableGear.append(catGutBow)
        let clawHeadArrow = Gear(name: "Claw Head Arrow", description: GearDescription(type: .item, stats: .weapon(1, 6, 6), affinities: [.blueRight], detailText: NSMutableAttributedString().bold("Slow, Ammo - Bow").normal(". You must have a bow in your gear grid to activate this.\n\nIf you hit, the monster gains a -1 evasion token. Use once per showdown.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.lionClaw:1], locationRequirement: catarium)
        availableGear.append(clawHeadArrow)
        let frenzyDrink = Gear(name: "Frenzy Drink", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("Spend an activation to ").bold("Consume").normal(": Suffer ").bold("Frenzy").normal(" brain trauma. Can be used once per showdown")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.lionTestes:1], locationRequirement: catarium)
        availableGear.append(frenzyDrink)
        let kingSpear = Gear(name: "King Spear", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 3), affinities: [.redRight], detailText: NSMutableAttributedString().bold("Reach 2").normal(": May attack from 2 spaces away.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.greatCatBone:1, .lionClaw:1], locationRequirement: catarium)
        availableGear.append(kingSpear)
        let lionBeastKatar = Gear(name: "Lion Beast Katar", description: GearDescription(type: .weapon, stats: .weapon(2, 7, 3), affinities: [.none], detailText: NSMutableAttributedString().bold("Deadly").normal(": +1 luck with this weapon.\n\n").bold("Paired").normal(": When you attack, add the speed of a 2nd Lion Beast Katar in your gear grid.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.lionClaw:1], locationRequirement: catarium)
        availableGear.append(lionBeastKatar)
        let lionHeaddress = Gear(name: "Lion Headdress", description: GearDescription(type: .item, stats: .armor(1, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Accessory").normal(": You may wear this in addition to 1 armor at this hit location.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.shimmeringMane:1], locationRequirement: catarium)
        availableGear.append(lionHeaddress)
        let lionSkinCloak = Gear(name: "Lion Skin Cloak", description: GearDescription(type: .armor, stats: .armor(0, .body), affinities: [.greenRight], detailText: NSMutableAttributedString().normal("Reduce damage from every hit suffered by 1, to a minimum of 1.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.whiteFur:2], locationRequirement: catarium)
        availableGear.append(lionSkinCloak)
        let whiskerHarp = Gear(name: "Whisker Harp", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft], detailText: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", all survivors gain +1 survival.\n\nSpend an action to Strum: Roll 1d10. On a result of 6+, discard 1 ").bold("mood").normal(" currently in play.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.goldenWhiskers:1], locationRequirement: catarium)
        availableGear.append(whiskerHarp)
        let whiteLionBoots = Gear(name: "White Lion Boots", description: GearDescription(type: .armor, stats: .armor(2, .legs), affinities: [.redRight, .redDown], detailText: NSMutableAttributedString().normal("With 2 red puzzle affinities: +1 movement.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.whiteFur:1], locationRequirement: catarium)
        availableGear.append(whiteLionBoots)
        let whiteLionCoat = Gear(name: "White Lion Coat", description: GearDescription(type: .armor, stats: .armor(2, .body), affinities: [.blueUp], detailText: NSMutableAttributedString().bold("Pounce").normal(": Spend an activation and a movement to move 3 spaces in a straight line. Then, if you moved 3 spaces, activate a melee weapon with +1 strength.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.whiteFur:1], locationRequirement: catarium)
        availableGear.append(whiteLionCoat)
        let whiteLionGauntlet = Gear(name: "White Lion Gauntlet", description: GearDescription(type: .armor, stats: .armor(2, .arms), affinities: [.none], detailText: NSMutableAttributedString().normal("When you ").bold("Pounce").normal(", gain +1 accuracy for your next attack this turn.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.whiteFur:1], locationRequirement: catarium)
        availableGear.append(whiteLionGauntlet)
        let whiteLionHelm = Gear(name: "White Lion Helm", description: GearDescription(type: .armor, stats: .armor(2, .head), affinities: [.redDown], detailText: NSMutableAttributedString().normal("With red puzzle and any blue affinity: Spend an action and 1 survival to ").bold("Roar").normal(": Non-Deaf Insane survivors gain +2 strength until the end of round. All other survivors gain +1 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.greatCatBone:1, .whiteFur:1], locationRequirement: catarium)
        availableGear.append(whiteLionHelm)
        let whiteLionSkirt = Gear(name: "White Lion Skirt", description: GearDescription(type: .armor, stats: .armor(2, .waist), affinities: [.redLeft, .redRight], detailText: NSMutableAttributedString().normal("")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.whiteFur:1], locationRequirement: catarium)
        availableGear.append(whiteLionSkirt)
        // Exhausted Lantern Hoard Gear
        let oxidizedBeaconShield = Gear(name: "Oxidized Beacon Shield", description: GearDescription(type: .weapon, stats: .weapon(1, 6, 6), affinities: [.none], detailText: NSMutableAttributedString().normal("+2 armor to all hit locations.\n\n").bold("Deflect 2").normal(": Spend an activation - you now have exactly 2 deflect tokens. The next 2 times you are hit, ignore a hit and lose 1 deflect token.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .endeavor:1, .hide:1, .organ:3], resourceSpecialRequirements: [.beaconShieldResource:1, .blackLichen:1, .cocoonMembrane:1, .iron:2, .leather:3], locationRequirement: exhaustedLanternHoard)
        availableGear.append(oxidizedBeaconShield)
        let oxidizedLanternDagger = Gear(name: "Oxidized Lantern Dagger", description: GearDescription(type: .weapon, stats: .weapon(3, 6, 4), affinities: [.redLeft, .redRight], detailText: NSMutableAttributedString().bold("Sharp, Paired").normal("\n\nWith 1 red puzzle affinity and any other red affinity: On a ").bold("Perfect hit").normal(", gain +1 survival.")), qtyAvailable: 4, resourceTypeRequirements: [.bone:3, .endeavor:1, .hide:4, .organ:3], resourceSpecialRequirements: [.blackLichen:1, .cocoonMembrane:1, .iron:1, .lanternDaggerResource:1, .leather:3], locationRequirement: exhaustedLanternHoard)
        availableGear.append(oxidizedLanternDagger)
        let oxidizedLanternGlaive = Gear(name: "Oxidized Lantern Glaive", description: GearDescription(type: .weapon, stats: .weapon(2, 5, 6), affinities: [.greenDown], detailText: NSMutableAttributedString().bold("Sharp, Reach 2").normal("\n\nWith a green puzzle and any red affinity: On a ").bold("Perfect hit").normal(", the edge sharpens. This weapon gains +4 strength for this attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:7, .endeavor:1, .organ:3], resourceSpecialRequirements: [.blackLichen:1, .cocoonMembrane:1, .iron:1, .lanternGlaiveResource:1, .leather:3], locationRequirement: exhaustedLanternHoard)
        availableGear.append(oxidizedLanternGlaive)
        let oxidizedLanternHelm = Gear(name: "Oxidized Lantern Helm", description: GearDescription(type: .armor, stats: .armor(6, .head), affinities: [.blueDown], detailText: NSMutableAttributedString().bold("With blue puzzle and any red affinity: If you are not deaf, you may ignore effects that taget non-deaf survivors.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:7, .endeavor:1, .organ:3], resourceSpecialRequirements: [.blackLichen:1, .cocoonMembrane:1, .iron:1, .lanternHelmResource:1, .leather:3], locationRequirement: exhaustedLanternHoard)
        availableGear.append(oxidizedLanternHelm)
        let oxidizedLanternSword = Gear(name: "Oxidized Lantern Sword", description: GearDescription(type: .weapon, stats: .weapon(3, 5, 5), affinities: [.redLeft], detailText: NSMutableAttributedString().bold("Sharp.\n\nDeflect 1").normal(": Spend an activation - you now have exactly 1 deflect token. The next 1 time you are hit, ignore that hit and lose 1 deflect token.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .endeavor:1, .organ:3], resourceSpecialRequirements: [.blackLichen:1, .cocoonMembrane:1, .lanternSwordResource:1, .lanternTube:1, .leather:3], locationRequirement: exhaustedLanternHoard)
        availableGear.append(oxidizedLanternSword)
        let oxidizedRingWhip = Gear(name: "Oxidixed Ring Whip", description: GearDescription(type: .weapon, stats: .weapon(2, 5, 3), affinities: [.blueLeft], detailText: NSMutableAttributedString().bold("Sharp, Reach 2\n\n").normal("With 1 blue puzzle and any 3 red affinities - ").bold("Provoke").normal(": When you wound with this weapon, gain the Priority Target token.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .endeavor:1, .organ:7], resourceSpecialRequirements: [.blackLichen:1, .cocoonMembrane:1, .iron:1, .ringWhipResource:1], locationRequirement: exhaustedLanternHoard)
        availableGear.append(oxidizedRingWhip)
        let survivorsLantern = Gear(name: "Survivors' Lantern", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.redLeft, .greenRight, .blueDown], detailText: NSMutableAttributedString().normal("")), qtyAvailable: 4, resourceTypeRequirements: [.endeavor:1], resourceSpecialRequirements: [.finalLanternResource:1], locationRequirement: exhaustedLanternHoard)
        availableGear.append(survivorsLantern)
        // Leather Worker Gear
        let hunterWhip = Gear(name: "Hunter Whip", description: GearDescription(type: .weapon, stats: .weapon(3, 6, 3), affinities: [.blueUp, .blueRight], detailText: NSMutableAttributedString().normal("With two blue puzzle affinities - On a ").bold("Perfect hit").normal(", discard 1 mood in play.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.leather:2], locationRequirement: leatherWorker)
        availableGear.append(hunterWhip)
        let leatherBoots = Gear(name: "Leather Boots", description: GearDescription(type: .armor, stats: .armor(3, .legs), affinities: [.greenLeft, .greenRight], detailText: NSMutableAttributedString().normal("With two green puzzle affinities - At the end of your act, you may move 1 space.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.leather:1], locationRequirement: leatherWorker)
        availableGear.append(leatherBoots)
        let leatherBracers = Gear(name: "Leather Bracers", description: GearDescription(type: .armor, stats: .armor(3, .arms), affinities: [.greenRight], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 survival.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.leather:1], locationRequirement: leatherWorker)
        availableGear.append(leatherBracers)
        let leatherCuirass = Gear(name: "Leather Cuirass", description: GearDescription(type: .armor, stats: .armor(3, .body), affinities: [.redUp, .blueDown], detailText: NSMutableAttributedString().normal("")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.leather:1], locationRequirement: leatherWorker)
        availableGear.append(leatherCuirass)
        let leatherMask = Gear(name: "Leather Mask", description: GearDescription(type: .armor, stats: .armor(3, .head), affinities: [.blueUp, .redDown], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.leather:1, .scrap:1], locationRequirement: leatherWorker)
        availableGear.append(leatherMask)
        let leatherSkirt = Gear(name: "Leather Skirt", description: GearDescription(type: .armor, stats: .armor(3, .waist), affinities: [.greenDown], detailText: NSMutableAttributedString().normal("")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.leather:1], locationRequirement: leatherWorker)
        availableGear.append(leatherSkirt)
        let roundLeatherShield = Gear(name: "Round Leather Shield", description: GearDescription(type: .weapon, stats: .weapon(1, 8, 1), affinities: [.greenUp], detailText: NSMutableAttributedString().normal("Add +1 armor to all hit locations.\n\n").bold("Block 1").normal(": Spend an activation to ignore 1 hit the next time you are attacked. Lasts until your next act. You cannot use block more than once per attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .hide:1], resourceSpecialRequirements: [.leather:1], locationRequirement: leatherWorker)
        availableGear.append(roundLeatherShield)
        // Mask Maker Gear
        let antelopeMask = Gear(name: "Antelope Mask", description: GearDescription(type: .item, stats: .armor(2, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique, Irreplaceable, Accessory").normal("\n\nWith any two red and any two blue affinities - At the start of your act, if insane, gain an activation.")), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [.pelt:1], locationRequirement: maskMaker)
        availableGear.append(antelopeMask)
        let deathMask = Gear(name: "Death Mask", description: GearDescription(type: .item, stats: .armor(2, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique, irreplaceable, Accessory").normal("\n\nIf you have no affinities, gain +4 luck and suffer -4 to all severe injury rolls. Must lose 1 population upon crafting!")), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], locationRequirement: maskMaker)
        availableGear.append(deathMask)
        let godMask = Gear(name: "God Mask", description: GearDescription(type: .item, stats: .armor(2, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique, Irreplaceable, Accessory").normal("\n\nWith two of each affinity - At the start of your act, if ").bold("insane").normal(", gain +1 survival.")), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [.foundingStoneResource:1], locationRequirement: maskMaker)
        availableGear.append(godMask)
        let manMask = Gear(name: "Man Mask", description: GearDescription(type: .item, stats: .armor(2, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique, Irreplaceable, Accessory").normal("\n\nWith any one red and any one green affinity - If ").bold("insane").normal(", you may spend negative attribute tokens in place of insanity.")), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [.skull:1], locationRequirement: maskMaker)
        availableGear.append(manMask)
        let phoenixMask = Gear(name: "Phoenix Mask", description: GearDescription(type: .item, stats: .armor(2, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique, Irreplaceable, Accessory").normal("\n\nWith any four red affinities - If ").bold("insane").normal(", you may dodge 1 additional time per round.")), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [.smallFeathers:1], locationRequirement: maskMaker)
        availableGear.append(phoenixMask)
        let whiteLionMask = Gear(name: "White Lion Mask", description: GearDescription(type: .item, stats: .armor(2, .head), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique, Irreplaceable, Accessory").normal("\n\nWith any two green affinities - If ").bold("insane").normal(", spend an activation to lose all your survival and gain that many +1 Strength tokens.")), qtyAvailable: 1, resourceTypeRequirements: [.bone:6, .endeavor:1, .organ:4], resourceSpecialRequirements: [.shimmeringMane:1], locationRequirement: maskMaker)
        availableGear.append(whiteLionMask)
        // Organ Grinder Gear
        let driedAcanthus = Gear(name: "Dried Acanthus", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +2 survival. When you suffer a severe injury, ignore it and archive this card instead.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.freshAcanthus:1], locationRequirement: organGrinder)
        availableGear.append(driedAcanthus)
        let fecalSalve = Gear(name: "Fecal Salve", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 survival. Spend an activation: you are not a ").bold("threat").normal(" until you attack. If you have the ").bold("priority target").normal(" token, remove it.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], locationRequirement: organGrinder)
        availableGear.append(fecalSalve)
        let luckyCharm = Gear(name: "Lucky Charm", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft, .blueRight], detailText: NSMutableAttributedString().normal("With any two blue affinities - +1 luck.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], locationRequirement: organGrinder)
        availableGear.append(luckyCharm)
        let monsterGrease = Gear(name: "Monster Grease", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.greenLeft], detailText: NSMutableAttributedString().normal("Gain +1 evasion. With any three green affninities - gain another +1 evasion.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], locationRequirement: organGrinder)
        availableGear.append(monsterGrease)
        let monsterToothNecklace = Gear(name: "Monster Tooth Necklace", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.redRight], detailText: NSMutableAttributedString().normal("Gain +1 strength. With any two red affinities - gain another +1 strength.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.scrap:1], innovationRequirement: heat, locationRequirement: organGrinder)
        availableGear.append(monsterToothNecklace)
        let stoneNoses = Gear(name: "Stone Noses", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("On ").bold("arrival").normal(", gain +1 survival and +1 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [.endeavor:1], locationRequirement: organGrinder)
        availableGear.append(stoneNoses)
        // Plumery Gear
        let arcBow = Gear(name: "Arc Bow", description: GearDescription(type: .weapon, stats: .weapon(1, 6, 9), affinities: [.redLeft, .greenRight], detailText: NSMutableAttributedString().bold("Slow, Range 6.\n\nCumbersome").normal(": Spend a movement as an additional cost of activating this weapon. With a red and a green puzzle affinity plus any blue affinity - Range +2")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.phoenixWhisker:1, .scrap:1, .wishBone:1], locationRequirement: plumery)
        availableGear.append(arcBow)
        let birdBread = Gear(name: "Bird Bread", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.greenRight], detailText: NSMutableAttributedString().normal("Spend an activation to ").bold("Consume").normal(": Once per showdown, add +1 armor to all hit locations. Gain the ").bold("priority target").normal(" token. Roll 1d10. On a 1, reduce your survival to 0.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:3], resourceSpecialRequirements: [.pustules:1], locationRequirement: plumery)
        availableGear.append(birdBread)
        let bloomSphere = Gear(name: "Bloom Sphere", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.greenLeft, .blueRight], detailText: NSMutableAttributedString().normal("With green and blue puzzle affinity - When you are picked as a target, roll 1d10. On a 6+, the monster must pick a new target if possible.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:3], resourceSpecialRequirements: [.smallHandParasites:1], locationRequirement: plumery)
        availableGear.append(bloomSphere)
        let crestCrown = Gear(name: "Crest Crown", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.redLeft, .blueUp, .greenRight, .blueDown], detailText: NSMutableAttributedString().normal("Spend an activation: If ").bold("insane").normal(", reshuffle the hit location deck. With two blue and one red puzzle affinities - When you depart, gain +1 insanity and +1 survival for every blue affinity you have.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:6], resourceSpecialRequirements: [.phoenixCrest:1], locationRequirement: plumery)
        availableGear.append(crestCrown)
        let featherMantle = Gear(name: "Feather Mantle", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft, .greenRight, .redDown], detailText: NSMutableAttributedString().normal("When you suffer ").bold("knockback").normal(", you may ignore collision with other survivors and reduce the movement by up to 3 spaces.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.scrap:1, .tailFeathers:2], locationRequirement: plumery)
        availableGear.append(featherMantle)
        let featherShield = Gear(name: "Feather Shield", description: GearDescription(type: .weapon, stats: .weapon(3, 7, 0), affinities: [.blueUp], detailText: NSMutableAttributedString().bold("Block 1").normal("\n\nWith any one red, one green, and one blue affinity - Reduce any suffered brain damage by 1 to a minimum of 1.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.muculentDroppings:1, .smallFeathers:2], locationRequirement: plumery)
        availableGear.append(featherShield)
        let hollowSword = Gear(name: "Hollow Sword", description: GearDescription(type: .weapon, stats: .weapon(3, 5, 3), affinities: [.none], detailText: NSMutableAttributedString().bold("Frail, Paired").normal("\n\nOn a ").bold("Perfect hit").normal(", make 1 additional attack roll.")), qtyAvailable: 4, resourceTypeRequirements: [.bone:2, .hide:2], resourceSpecialRequirements: [.hollowWingBones:1], locationRequirement: plumery)
        availableGear.append(hollowSword)
        let hollowpointArrow = Gear(name: "Hollowpoint Arrow", description: GearDescription(type: .weapon, stats: .weapon(1, 6, 11), affinities: [.none], detailText: NSMutableAttributedString().bold("Slow, Ammo - Bow").normal("\n\nOn a hit, monster gains -1 movement token. Use once per showdown.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.hollowWingBones:1, .scrap:1], locationRequirement: plumery)
        availableGear.append(hollowpointArrow)
        let hoursRing = Gear(name: "Hours Ring", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().bold("Unique").normal("\n\nDuring the aftermath, if you died or ceased to exist, you may archive the Hours Ring and reset the campaign to the previous Settlement Phase's develop step before you departed.")), qtyAvailable: 1, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [.shimmeringHalo:1], locationRequirement: plumery)
        availableGear.append(hoursRing)
        let phoenixFaulds = Gear(name: "Phoenix Faulds", description: GearDescription(type: .armor, stats: .armor(4, .waist), affinities: [.none], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], resourceSpecialRequirements: [.iron:1, .leather:1, .tailFeathers:1], locationRequirement: plumery)
        availableGear.append(phoenixFaulds)
        let phoenixGauntlets = Gear(name: "Phoenix Gauntlets", description: GearDescription(type: .armor, stats: .armor(4, .arms), affinities: [.none], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.iron:1, .leather:1, .smallFeathers:1], locationRequirement: plumery)
        availableGear.append(phoenixGauntlets)
        let phoenixGreaves = Gear(name: "Phoenix Greaves", description: GearDescription(type: .armor, stats: .armor(4, .legs), affinities: [.redRight], detailText: NSMutableAttributedString().normal("If ").bold("insane").normal(", gain +2 movement.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], resourceSpecialRequirements: [.iron:1, .leather:1, .smallFeathers:1], locationRequirement: plumery)
        availableGear.append(phoenixGreaves)
        let phoenixHelm = Gear(name: "Phoenix Helm", description: GearDescription(type: .armor, stats: .armor(4, .head), affinities: [.blueDown], detailText: NSMutableAttributedString().normal("With one blue puzzle affinity, any one red and any one green affinity - If ").bold("insane").normal(" at the start of the showdown, gain +1 evasion token.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.hollowWingBones:1, .smallFeathers:1], locationRequirement: plumery)
        availableGear.append(phoenixHelm)
        let phoenixPlackart = Gear(name: "Phoenix Plackart", description: GearDescription(type: .armor, stats: .armor(4, .body), affinities: [.greenLeft, .blueUp, .redRight], detailText: NSMutableAttributedString().normal("With red, green, and blue puzzle affinities - If ").bold("insane").normal(", ignore the first hit each round and suffer 1 brain damage instead.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.iron:1, .leather:1, .tailFeathers:1], locationRequirement: plumery)
        availableGear.append(phoenixPlackart)
        let sonicTomahawk = Gear(name: "Sonic Tomahawk", description: GearDescription(type: .weapon, stats: .weapon(3, 5, 2), affinities: [.redLeft], detailText: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", make 1 additional attack roll. With one red puzzle affinity, any two green affinities and any one blue affinity - Gain ").bold("Savage").normal(" and ").bold("Paired").normal(".")), qtyAvailable: 4, resourceTypeRequirements: [:], resourceSpecialRequirements: [.hollowWingBones:1, .scrap:1, .smallFeathers:1], locationRequirement: plumery)
        availableGear.append(sonicTomahawk)
        // Skinnery Gear
        let bandages = Gear(name: "Bandages", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.blueLeft, .greenDown], detailText: NSMutableAttributedString().normal("Spend an activation to remove up to 2 bleeding tokens from yourself or an adjacent survivor.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery)
        availableGear.append(bandages)
        let rawhideBoots = Gear(name: "Rawhide Boots", description: GearDescription(type: .armor, stats: .armor(1, .legs), affinities: [.none], detailText: NSMutableAttributedString().normal("When you ").bold("depart").normal(", gain +1 survival.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery)
        availableGear.append(rawhideBoots)
        let rawhideDrum = Gear(name: "Rawhide Drum", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.greenLeft], detailText: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", all survivors gain +1 insanity. Inspirational Drumming! When you perform ").bold("encourage").normal(", all non-deaf survivors are affected.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .hide:1], innovationRequirement: drums, locationRequirement: skinnery)
        availableGear.append(rawhideDrum)
        let rawhideGloves = Gear(name: "Rawhide Gloves", description: GearDescription(type: .armor, stats: .armor(1, .arms), affinities: [.redLeft], detailText: NSMutableAttributedString().normal("When you ").bold("Depart").normal(", gain +1 survival.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery)
        availableGear.append(rawhideGloves)
        let rawhideHeadband = Gear(name: "Rawhide Headband", description: GearDescription(type: .armor, stats: .armor(1, .head), affinities: [.blueDown], detailText: NSMutableAttributedString().normal("With one blue puzzle affinity - Spend an activation to reveal the top two AI cards. Place them back on the AI deck in any order.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery)
        availableGear.append(rawhideHeadband)
        let rawhidePants = Gear(name: "Rawhide Pants", description: GearDescription(type: .armor, stats: .armor(1, .legs), affinities: [.blueDown], detailText: NSMutableAttributedString().normal("")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery)
        availableGear.append(rawhidePants)
        let rawhideVest = Gear(name: "Rawhide Vest", description: GearDescription(type: .armor, stats: .armor(1, .body), affinities: [.redRight], detailText: NSMutableAttributedString().normal("With one blue and one red puzzle affinity - Gain +1 evasion.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], locationRequirement: skinnery)
        availableGear.append(rawhideVest)
        let rawhideWhip = Gear(name: "Rawhide Whip", description: GearDescription(type: .weapon, stats: .weapon(3, 7, 1), affinities: [.none], detailText: NSMutableAttributedString().bold("Provoke").normal(": When you wound with this weapon, gain the ").bold("priority target").normal(" token.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .hide:1], innovationRequirement: ammonia, locationRequirement: skinnery)
        availableGear.append(rawhideWhip)
        // Stone Circle Gear
        let beastKnuckle = Gear(name: "Beast Knuckle", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 4), affinities: [.none], detailText: NSMutableAttributedString().bold("Paired").normal("\n\nWhen you wound with this weapon, monster gains -1 toughness unti end of the attack.")), qtyAvailable: 4, resourceTypeRequirements: [:], resourceSpecialRequirements: [.largeFlatTooth:1, .pelt:1], locationRequirement: stoneCircle)
        availableGear.append(beastKnuckle)
        let bloodPaint = Gear(name: "Blood Paint", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("Spend an activation to activate weapon gear to the left and right of this card. These are two separate attacks. Cannot be used with two-handed weapons.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:1], resourceSpecialRequirements: [.bladder:1], innovationRequirement: paint, locationRequirement: stoneCircle)
        availableGear.append(bloodPaint)
        let blueCharm = Gear(name: "Blue Charm", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.oneBlue], detailText: NSMutableAttributedString().normal("With any five blue affinities - ").bold("Unshakeable").normal(": When you draw a trap, roll 1d10. On a 6+, discard the trap and reshuffle the deck.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], locationRequirement: stoneCircle)
        availableGear.append(blueCharm)
        let boneEarrings = Gear(name: "Bone Earrings", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("At the start of the showdown, gain +2 speed and +2 strength tokens if ").bold("insane").normal(" and all gear in your gear grid has the bone keyword.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.shankBone:1], locationRequirement: stoneCircle)
        availableGear.append(boneEarrings)
        let bossMehndi = Gear(name: "Boss Mehndi", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().normal("Boss is brave. While adjacent to you, ").bold("insane").normal(" survivors gain +1 speed.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.goldenWhiskers:1], locationRequirement: stoneCircle)
        availableGear.append(bossMehndi)
        let greenCharm = Gear(name: "Green Charm", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.oneGreen], detailText: NSMutableAttributedString().normal("With any five green affinities - ").bold("Undeathable").normal(": If you would die, roll 1d10. On a 6+, you inexplicably survive.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], locationRequirement: stoneCircle)
        availableGear.append(greenCharm)
        let lanceOfLonginus = Gear(name: "Lance of Longinus", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 9), affinities: [.none], detailText: NSMutableAttributedString().bold("Irreplaceable, Reach 2").normal("\n\nEach showdown, the first time you wound, the monster gains a -1 toughness token.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:6], resourceSpecialRequirements: [.legendaryHorns:1], locationRequirement: stoneCircle)
        availableGear.append(lanceOfLonginus)
        let redCharm = Gear(name: "Red Charm", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.oneRed], detailText: NSMutableAttributedString().normal("With any five red affinities - ").bold("Unstoppable").normal(": When you attempt to wound, instead roll 1d10. On a 1 - 5, fail. On a 6 - 10, wound.")), qtyAvailable: 3, resourceTypeRequirements: [.organ:3], locationRequirement: stoneCircle)
        availableGear.append(redCharm)
        let screamingBracers = Gear(name: "Screaming Bracers", description: GearDescription(type: .armor, stats: .armor(2, .arms), affinities: [.redLeft, .greenUp], detailText: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", if possible, add an ").bold("Acanthus Plant").normal(" terrain card to the showdown. When you activate terrain, you may add +2 to your roll result.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.pelt:1], locationRequirement: stoneCircle)
        availableGear.append(screamingBracers)
        let screamingCoat = Gear(name: "Screaming Coat", description: GearDescription(type: .armor, stats: .armor(2, .body), affinities: [.greenLeft, .blueUp, .blueRight, .greenDown], detailText: NSMutableAttributedString().bold("Slam").normal(": Spend an activation to full move forward in a straight line. If you move 4+ spaces and stop adjacent to a monster, it suffers knockback 1 and -1 toughness until the end of the round.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.pelt:1], locationRequirement: stoneCircle)
        availableGear.append(screamingCoat)
        let screamingHorns = Gear(name: "Screaming Horns", description: GearDescription(type: .armor, stats: .armor(3, .head), affinities: [.blueDown], detailText: NSMutableAttributedString().normal("Spend an activation to ").bold("Scream").normal(": Non-deaf insane survivors gain+1 movement until end of round. All other survivors gain +1 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.scrap:1, .spiralHorn:1], locationRequirement: stoneCircle)
        availableGear.append(screamingHorns)
        let screamingLegWarmers = Gear(name: "Screaming Leg Warmers", description: GearDescription(type: .armor, stats: .armor(2, .legs), affinities: [.blueUp, .redRight], detailText: NSMutableAttributedString().normal("On ").bold("Arrival").normal(", your feet hurt. Gain +3 insanity.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [.pelt:1], locationRequirement: stoneCircle)
        availableGear.append(screamingLegWarmers)
        let screamingSkirt = Gear(name: "Screaming Skirt", description: GearDescription(type: .armor, stats: .armor(3, .waist), affinities: [.greenRight, .blueDown], detailText: NSMutableAttributedString().normal("Thick, protective fur protects your parts. Add +1 to severe waist injury roll results.")), qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [.pelt:1], locationRequirement: stoneCircle)
        availableGear.append(screamingSkirt)
        // Weapon Crafter Gear
        let bloodSheath = Gear(name: "Blood Sheath", description: GearDescription(type: .item, stats: .item("N/A"), affinities: [.none], detailText: NSMutableAttributedString().bold("Block 1").normal("\n\nWhen Rainbow Katana is left of Blood Sheath, it loses Frail and gains Sharp (add 1d10 strength to each wound attempt).")), qtyAvailable: 3, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [.hollowWingBones:1, .muculentDroppings:1], locationRequirement: weaponCrafter)
        availableGear.append(bloodSheath)
        let counterweightedAxe = Gear(name: "Counterweighted Axe", description: GearDescription(type: .weapon, stats: .weapon(2, 6, 4), affinities: [.redUp], detailText: NSMutableAttributedString().bold("Reach 2").normal("\n\nWith one red puzzle affinity - On a ").bold("Perfect hit").normal(", do not draw a hit location. Monster suffers 1 wound.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .hide:1, .organ:1], locationRequirement: weaponCrafter)
        availableGear.append(counterweightedAxe)
        let fingerOfGod = Gear(name: "Finger of God", description: GearDescription(type: .weapon, stats: .weapon(2, 5, 5), affinities: [.redUp], detailText: NSMutableAttributedString().bold("Reach 2").normal("\n\nWith any one red, any one green, and any one blue affinity - As long as you have 5+ survival, gain +1 accuracy and +1 strength.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [.phoenixFinger:1], locationRequirement: weaponCrafter)
        availableGear.append(fingerOfGod)
        let rainbowKatana = Gear(name: "Rainbow Katana", description: GearDescription(type: .weapon, stats: .weapon(4, 4, 4), affinities: [.redLeft], detailText: NSMutableAttributedString().bold("Frail").normal("\n\nWith one red puzzle affinity and any one green and any one blue affinity - Gains ").bold("Deadly").normal(".")), qtyAvailable: 3, resourceTypeRequirements: [.bone:6], resourceSpecialRequirements: [.birdBeak:1, .iron:1, .rainbowDroppings:1], innovationRequirement: heat, locationRequirement: weaponCrafter)
        availableGear.append(rainbowKatana)
        let scrapDagger = Gear(name: "Scrap Dagger", description: GearDescription(type: .weapon, stats: .weapon(3, 7, 2), affinities: [.redRight, .redDown], detailText: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", the edge sharpens. Gain +2 strength for the rest of the attack.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [.scrap:1], innovationRequirement: heat, locationRequirement: weaponCrafter)
        availableGear.append(scrapDagger)
        let scrapSword = Gear(name: "Scrap Sword", description: GearDescription(type: .weapon, stats: .weapon(2, 5, 3), affinities: [.blueUp], detailText: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", the edge sharpens. Gain +4 strength for the rest of the attack. With any two red and any one blue affinity - Gains Deadly.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [.scrap:1], innovationRequirement: heat, locationRequirement: weaponCrafter)
        availableGear.append(scrapSword)
        let skullcapHammer = Gear(name: "Skullcap Hammer", description: GearDescription(type: .weapon, stats: .weapon(2, 7, 3), affinities: [.greenDown], detailText: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", the monster is dazed, and gains -1 speed token until the end of its turn. A monster can be dazed once per round.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [.scrap:1], locationRequirement: weaponCrafter)
        availableGear.append(skullcapHammer)
        let whistlingMace = Gear(name: "Whistling Mace", description: GearDescription(type: .weapon, stats: .weapon(3, 6, 3), affinities: [.greenDown], detailText: NSMutableAttributedString().normal("On a ").bold("Perfect hit").normal(", reveal the next AI card. Place it on the top or bottom of the AI deck. Unwieldy: If any attack roll results are 1, you hit yourself and suffer 1 damage.")), qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .organ:1], locationRequirement: weaponCrafter)
        availableGear.append(whistlingMace)
        let zanbato = Gear(name: "Zanbato", description: GearDescription(type: .weapon, stats: .weapon(1, 6, 6), affinities: [.redUp, .greenRight], detailText: NSMutableAttributedString().bold("Slow, Frail, Deadly").normal("\n\nWith one red puzzle affinity and one green affinity - Gains Devastating 1: Whenever you wound, inflict one additional wound.")), qtyAvailable: 3, resourceTypeRequirements: [.hide:2], resourceSpecialRequirements: [.greatCatBone:1], locationRequirement: weaponCrafter)
        availableGear.append(zanbato)
        
        // Initialize Crafted Gear tracking
        for gear in availableGear {
            gearCraftedDict[gear] = 0
        }
        
    }
}
