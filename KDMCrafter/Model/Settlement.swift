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
    var locations = [Location]()
    //var gearStorage = [Gear]()
    var availableGear = [Gear]()
    var innovations = [Innovation]()
    
    init(name: String) {
        
        // Gotta have a name!
        self.name = name
        
        // Initialize storage with zero of everything
        self.resourceStorage = [multi:0, brokenLantern:0, loveJuice:0, monsterBone:0, monsterHide:0, monsterOrgan:0, scrap:0, skull:0, birdBeak:0, blackSkull:0, hollowWingBones:0, muculentDroppings:0, phoenixEye:0, phoenixFinger:0, pustules:0, rainbowDroppings:0, shimmeringHalo:0, smallFeathers:0, smallHandParasites:0, tailFeathers:0, wishbone:0, beastSteak:0, bladder:0, largeFlatTooth:0, musclyGums:0, pelt:0, screamingBrain:0, shankBone:0, spiralHorn:0, blackLichen:0, cocoonMembrane:0, elderCatTeeth:0, freshAcanthus:0, iron:0, lanternTube:0, leather:0, legendaryHorns:0, perfectCrucible:0, phoenixCrest:0, secondHeart:0, crabSpider:0, cyclopsFly:0, hissingCockroach:0, lonelyAnt:0, nightmareTick:0, swordBeetle:0, curiousHand:0, eyeOfCat:0, goldenWhiskers:0, lionClaw:0, lionTail:0, lionTestes:0, shimmeringMane:0, sinew:0, whiteFur:0]

        // Initialize locations with the starter Lantern Hoard
        self.locations.append(lanternHoard)
        
        // Initialize gear storage with cloth and founding stones
        //self.gearStorage.append(<#T##newElement: Gear##Gear#>)
        
        // Initialize available gear selection
        availableGear = [almanac,bugTrap,brainMint,elderEarrings,firstAidKit]
        
        // Initialize available innovations
    }
}
