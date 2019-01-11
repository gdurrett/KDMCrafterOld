//
//  Settlement.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/17/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

class Settlement {
    
    // For the settlement object
    let name: String
    var resourceStorage = [Resource:Int]()
    let allLocations: Set = [barberSurgeon, blackSmith, boneSmith, catarium, exhaustedLanternHoard, lanternHoard, leatherWorker, maskMaker, organGrinder, plumery, skinnery, stoneCircle, weaponCrafter]
    var builtLocations = [Location]()
    var availableLocations = [Location]()
    var availableGear = [Gear]()
    //var gearStorage = [Gear]()
    var innovations = [Innovation]()
    
    init(name: String) {
        
        // Gotta have a name!
        self.name = name
        
        // Initialize storage with zero of everything
        self.resourceStorage = [endeavor:0, multi:0, brokenLantern:0, loveJuice:0, monsterBone:0, monsterHide:0, monsterOrgan:0, scrap:0, skull:0, birdBeak:0, blackSkull:0, hollowWingBones:0, muculentDroppings:0, phoenixEye:0, phoenixFinger:0, pustules:0, rainbowDroppings:0, shimmeringHalo:0, smallFeathers:0, smallHandParasites:0, tailFeathers:0, wishbone:0, beastSteak:0, bladder:0, largeFlatTooth:0, musclyGums:0, pelt:0, screamingBrain:0, shankBone:0, spiralHorn:0, blackLichen:0, cocoonMembrane:0, elderCatTeeth:0, freshAcanthus:0, iron:0, lanternTube:0, leather:0, legendaryHorns:0, perfectCrucible:0, phoenixCrest:0, secondHeart:0, crabSpider:0, cyclopsFly:0, hissingCockroach:0, lonelyAnt:0, nightmareTick:0, swordBeetle:0, curiousHand:0, eyeOfCat:0, goldenWhiskers:0, lionClaw:0, lionTail:0, lionTestes:0, shimmeringMane:0, sinew:0, whiteFur:0]

        // Initialize locations with the starter Lantern Hoard
        self.builtLocations.append(lanternHoard)
        
        // Initialize available gear
        // Barber Surgeon Gear
        let almanac = Gear(name: "Almanac", description: "When you depart, gain +2 insanity. You cannot gain disorders.", qtyAvailable: 3, resourceTypeRequirements: [.leather:2], innovationRequirement: pictograph, locationRequirement: barberSurgeon)
        availableGear.append(almanac)
        let bugTrap = Gear(name: "Bug Trap", description: "At the start of the showdown, roll 1d10. On a roll of 3+, add a Bug Patch terrain to the showdown board.", qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [musclyGums:1], locationRequirement: barberSurgeon)
        availableGear.append(bugTrap)
        let brainMint = Gear(name: "Brain Mint", description: "Spend an action to Consume: Remove all your tokens and stand up. You may use this while knocked down, once per showdown.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [screamingBrain:1], locationRequirement: barberSurgeon)
        availableGear.append(brainMint)
        let elderEarrings = Gear(name: "Elder Earrings", description: "At the start of showdown, gain +2 survival. Gain +1 Hunt XP after showdown.", qtyAvailable: 3, resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [shankBone:1], locationRequirement: barberSurgeon)
        availableGear.append(elderEarrings)
        let firstAidKit = Gear(name: "First Aid Kit", description: "On arrival, all survivors gain +3 survival. Spend an action: remove 1 bleeding or negative attribute token from yourself or an adjacent survivor.", qtyAvailable: 3, resourceTypeRequirements: [.bone:2, .leather:1], locationRequirement: barberSurgeon)
        availableGear.append(firstAidKit)
        let muskBomb = Gear(name: "Musk Bomb", description: "If adjacent to monster when it draws an AI card, you may spend 2 survival and archive Musk Bomb to roll 1d10. On a 3+, discard the AI card without playing it.", qtyAvailable: 3, resourceTypeRequirements: [.any : 7], innovationRequirement: pottery, locationRequirement: barberSurgeon)
        availableGear.append(muskBomb)
        let scavengerKit = Gear(name: "Scavenger Kit", description: "When you defeat a monster, gain either 1 random basic resource or 1 random monster resource from that monster's resource deck.", qtyAvailable: 1,  resourceTypeRequirements: [.scrap:1], resourceSpecialRequirements: [pelt:1], locationRequirement: barberSurgeon)
        availableGear.append(scavengerKit)
        let speedPowder = Gear(name: "Speed Powder", description: "Spend 1 activation to suffer 2 brain damage. Gain 1 speed token. Use once per showdown.", qtyAvailable: 3, resourceTypeRequirements: [.organ:2], resourceSpecialRequirements: [secondHeart:1], locationRequirement: barberSurgeon)
        availableGear.append(speedPowder)
        // Blacksmith Gear
        let beaconShield = Gear(name: "Beacon Shield", description: "Add 2 to all hit locations. Block 2: Spend an activation to ignore 2 hits the next time you are attacked. Lasts until your next act. You cannot use block more than once per attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [iron:2, leather:3], locationRequirement: blackSmith)
        availableGear.append(beaconShield)
        let dragonSlayer = Gear(name: "Dragon Slayer", description: "1/6+/9. Frail, Slow, Sharp, Devastating 1. Early Iron: When an attack roll result is 1, cancel any hits and end the attack.", qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [iron:5], innovationRequirement: paint, locationRequirement: blackSmith)
        availableGear.append(dragonSlayer)
        let lanternCuirass = Gear(name: "Lantern Cuirass", description: "+5 armor to body location. -2 movement. With affinities: When you depart, add 3 to all hit locations with metal armor.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [iron:2, leather:5], locationRequirement: blackSmith)
        availableGear.append(lanternCuirass)
        let lanternDagger = Gear(name: "Lantern Dagger", description: "2/7+/1. Paired. Sharp: Add 1d10 Strength to each wound attempt. Early Iron: When an attack roll result is 1, cancel any hits and end the attack.", qtyAvailable: 4, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [iron:2, leather:3], locationRequirement: blackSmith)
        availableGear.append(lanternDagger)
        let lanternGauntlets = Gear(name: "Lantern Gauntlets", description: "+5 armor to legs location. With green affinity, +2 accuracy with club weapons.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [iron:2, leather:6], locationRequirement: blackSmith)
        availableGear.append(lanternGauntlets)
        let lanternGlaive = Gear(name: "Lantern Glaive", description: "2/6+/4. Reach 2. Sharp: Add 1d10 Strength to each wound attempt. Early Iron: When your attack roll result is 1, cancel any hits and end the attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:4], resourceSpecialRequirements: [iron:2, leather:2], locationRequirement: blackSmith)
        availableGear.append(lanternGlaive)
        let lanternGreaves = Gear(name: "Lantern Greaves", description: "With two red and a green affinity, +2 movement.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [iron:1, leather:5], locationRequirement: blackSmith)
        availableGear.append(lanternGreaves)
        let lanternHelm = Gear(name: "Lantern Helm", description: "+5 armor to head location. Blue affinity: Ear Plugs. You are deaf. -1 accuracy.", qtyAvailable: 3, resourceTypeRequirements: [.bone:7], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith)
        availableGear.append(lanternHelm)
        let lanternMail = Gear(name: "Lantern Mail", description: "+5 armor to waist location.", qtyAvailable: 3, resourceTypeRequirements: [.organ:5], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith)
        availableGear.append(lanternMail)
        let lanternSword = Gear(name: "Lantern Sword", description: "3/5+/3. Sharp: Add 1d10 Strength to each wound attempt. Early Iron: When an attack roll result is 1, cancel any hits and end the attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:4, .hide:3], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith)
        availableGear.append(lanternSword)
        let perfectSlayer = Gear(name: "Perfect Slayer", description: "3/6+/14. Slow, Sharp, Devastating 2, Irreplaceable. -2 movement.", qtyAvailable: 3, resourceTypeRequirements: [.organ:3], resourceSpecialRequirements: [iron:9, perfectCrucible:1], locationRequirement: blackSmith)
        availableGear.append(perfectSlayer)
        let ringWhip = Gear(name: "Ring Whip", description: "2/5+/0. Sharp, Reach 2. Early Iron: When an attack roll result is 1, cancel any hits and end the attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:3, .organ:3], resourceSpecialRequirements: [iron:1], locationRequirement: blackSmith)
        availableGear.append(ringWhip)
        let scrapShield = Gear(name: "Scrap Shield", description: "Add +1 armor to all hit locations. Block 1: Spend an activation to ignore a hit the next time you are attacked. Lasts until your next act. You cannot use block more than once per attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:3], resourceSpecialRequirements: [leather:3, scrap:2], locationRequirement: blackSmith)
        availableGear.append(scrapShield)
        // Bonesmith gear
        let boneAxe = Gear(name: "Bone Axe", description: "2/6+/3. Frail. Savage: Once per attack, if you critically wound, cause 1 additional wound. This effect does not apply to impervious hit locations.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1, .organ:1], locationRequirement: boneSmith)
        availableGear.append(boneAxe)
        let boneBlade = Gear(name: "Bone Blade", description: "2/6+/2. Frail: When you attempt to wound a super-dense hit location, this weapon breaks. Archive this card at the end of the attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith)
        availableGear.append(boneBlade)
        let boneClub = Gear(name: "Bone Club", description: "2/6+/5. Cumbersome: Spend a movement as an additional cost to activate this weapon. Ignore Cumbersome if this weapon is activated indrectly (Pounce, Charge, etc).", qtyAvailable: 3, resourceTypeRequirements: [.bone:3], locationRequirement: boneSmith)
        availableGear.append(boneClub)
        let boneDagger = Gear(name: "Bone Dagger", description: "3/7+/1. On a Perfect hit (lantern 10), gain +1 survival.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith)
        availableGear.append(boneDagger)
        let boneDarts = Gear(name: "Bone Darts", description: "1/7+/3. Range: 6. Frail: When you attempt to wound a super-dense hit location, this weapon breaks. Archive this card at the end of the attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1], locationRequirement: boneSmith)
        availableGear.append(boneDarts)
        let bonePickaxe = Gear(name: "Bone Pickaxe", description: "After Hunt phase setup, place the Mineral Gathering event on any hunt space.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [leather:1], innovationRequirement: ammonia, locationRequirement: boneSmith)
        availableGear.append(bonePickaxe)
        let boneSickle = Gear(name: "Bone Sickle", description: "After Hunt phase setup, place the Herb Gathering event on any hunt space.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [leather:1], innovationRequirement: ammonia, locationRequirement: boneSmith)
        availableGear.append(boneSickle)
        let skullHelm = Gear(name: "Skull Helm", description: "+3 armor to the head location. When you suffer a severe head injury, the Skull Helm is destroyed. Archive this card.", qtyAvailable: 3, resourceTypeRequirements: [.bone:2], resourceSpecialRequirements: [skull:1], locationRequirement: boneSmith)
        availableGear.append(skullHelm)
        // Catarium gear
        let catEyeCirclet = Gear(name: "Cat Eye Circlet", description: "Spend an activation to reveal the next 3 monster hit locations and return them in any order.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [eyeOfCat:1], locationRequirement: catarium)
        availableGear.append(catEyeCirclet)
        let catFangKnife = Gear(name: "Cat Fang Knife", description: "3/6+/2. 3 red affinities: On a Perfect hit, gain +1 strength token. When knocked down, remove all your +1 strength tokens.", qtyAvailable: 3, resourceTypeRequirements: [.organ:4], resourceSpecialRequirements: [elderCatTeeth:1], locationRequirement: catarium)
        availableGear.append(catFangKnife)
        let catGutBow = Gear(name: "Cat Gut Bow", description: "2/7+/3. Cumbersome. Range 6. Aim: When you attack, before rolling to hit, you may reduce the speed of this weapon by 1 to gain +2 accuracy for this attack.", qtyAvailable: 3, resourceTypeRequirements: [.bone:1], resourceSpecialRequirements: [sinew:1], locationRequirement: catarium)
        availableGear.append(catGutBow)
        let clawHeadArrow = Gear(name: "Claw Head Arrow", description: "1/6+/6. Slow, Ammo - Bow. You must have a bow in your gear grid to activate this. If you hit, the monster gains a -1 evasion token. Use once per showdown.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [lionClaw:1], locationRequirement: catarium)
        availableGear.append(clawHeadArrow)
        let frenzyDrink = Gear(name: "Frenzy Drink", description: "Spend an activation to Consume: Suffer Frenzy brain trauma. Can be used once per showdown", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [lionTestes:1], locationRequirement: catarium)
        availableGear.append(frenzyDrink)
        let kingSpear = Gear(name: "King Spear", description: "2/6+/3. Reach 2: May attack from 2 spaces away.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [greatCatBone:1, lionClaw:1], locationRequirement: catarium)
        availableGear.append(kingSpear)
        let lionBeastKatar = Gear(name: "Lion Beast Katar", description: "2/7+/3. Deadly: +1 luck with this weapon. Paired. When you attack, add the speed of a 2nd Lion Beast Katar in your gear grid.", qtyAvailable: 3, resourceTypeRequirements: [.hide:1], resourceSpecialRequirements: [lionClaw:1], locationRequirement: catarium)
        availableGear.append(lionBeastKatar)
        let lionHeaddress = Gear(name: "Lion Headdress", description: "+1 armor to head location. Accessory: You may wear this in addition to 1 armor at this hit location.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [shimmeringMane:1], locationRequirement: catarium)
        availableGear.append(lionHeaddress)
        let lionSkinCloak = Gear(name: "Lion Skin Cloak", description: "+0 armor to body location. Reduce damage from every hit suffered by 1, to a minimum of 1.", qtyAvailable: 3, resourceTypeRequirements: [:], resourceSpecialRequirements: [whiteFur:2], locationRequirement: catarium)
        availableGear.append(lionSkinCloak)
        
        
        // Initialize gear storage with cloth and founding stones
        //self.gearStorage.append(<#T##newElement: Gear##Gear#>)
        
        // Initialize available innovations
    }
}
