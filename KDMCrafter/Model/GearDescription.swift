//
//  GearDescription.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/7/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import Foundation

enum gearType: String, Codable {
    case armor = "Armor"
    case weapon = "Weapon"
    case item = "Item"
}
enum armorLocation: String, Codable {
    case head = "Head"
    case arms = "Arms"
    case body = "Body"
    case waist = "Waist"
    case legs = "Legs"
}
enum affinity: String, Codable, CaseIterable {
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

struct GearDescription: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, statsLeft, statsRight, affinities, detailText
    }
    
    public init(from decoder: Decoder) throws {
        let desc = try decoder.container(keyedBy: CodingKeys.self)
        type = gearType(rawValue: try desc.decode(String.self, forKey: .type))!
        statsLeft = try desc.decode(String.self, forKey: .statsLeft)
        statsRight = try desc.decode(String.self, forKey: .statsRight)
        affinities = try desc.decode([affinity].self, forKey: .affinities)
        detailText = try desc.decode(WrappedString.self, forKey: .detailText)
    }
    
    let type: gearType
    let statsLeft: String
    let statsRight: String
    let affinities: [affinity]
    let detailText: WrappedString
    
    init(type: gearType, statsLeft: String, statsRight: String, affinities: [affinity], detailText: WrappedString) {
        
        self.type = type
        self.statsLeft = statsLeft
        self.statsRight = statsRight
        self.affinities = affinities
        self.detailText = detailText
        
    }
}
