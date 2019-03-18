//
//  GearDescription.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/7/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import Foundation

enum gearType: String {
    case armor = "Armor"
    case weapon = "Weapon"
    case item = "Item"
}
enum armorLocation: String {
    case head = "Head"
    case arms = "Arms"
    case body = "Body"
    case waist = "Waist"
    case legs = "Legs"
}
enum affinity: String {
    case blueRight = "Blue Right"
    case redRight = "Red Right"
    case greenRight = "GreenRight"
    case blueLeft = "Blue Left"
    case redLeft = "Red Left"
    case greenLeft = "Green Left"
    case blueUp = "Blue Up"
    case redUp = "Red Up"
    case greenUp = "Green Up"
    case blueDown = "Blue Down"
    case redDown = "Red Down"
    case greenDown = "Green Down"
    case oneBlue = "One Blue"
    case oneRed = "One Red"
    case oneGreen = "One Green"
    case none = "None"
}
enum statType {
    
    case armor(_ protectionValue: Int, _ location: armorLocation)
    case weapon(_ speedValue: Int, _ accuracyValue: Int, _ strengthValue: Int)
    case item(String)
    
    func armorAttributes() -> (String, String) {

        switch self {
        case let .armor(protectionValue, location):
            return ("\(String(protectionValue))", "\(location.rawValue):")
        default:
            return ("Zero", "Nothing")
        }
    }
    
    func weaponAttributes() -> (String, String) {
        
        switch self {
        case let .weapon(speedValue, accuracyValue, strengthValue):
            return ("Speed:\nAccuracy:\nStrength:", "\(speedValue)\n\(accuracyValue)+\n\(strengthValue)")
        default:
            return("Nada", "Nothing")
        }
    }
    
}
struct GearDescription {
    
    let type: gearType
    let stats: statType
    let affinities: [affinity]
    let detailText: NSMutableAttributedString
    
    init(type: gearType, stats: statType, affinities: [affinity], detailText: NSMutableAttributedString) {
        
        self.type = type
        self.stats = stats
        self.affinities = affinities
        self.detailText = detailText
        
    }
}
