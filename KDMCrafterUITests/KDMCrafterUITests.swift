//
//  KDMCrafterUITests.swift
//  KDMCrafterUITests
//
//  Created by Greg Durrett on 4/1/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import Foundation
import XCTest

class NewTest: XCTestCase {
    
    let myTests = KDMCrafterUITests()

    let myNewGear = KDMCrafterUITests.Gear(name: "Shlubby", description: KDMCrafterUITests.GearDescription(type: .armor, statsLeft: "5", statsRight: "Head", affinities: [.blueUp], detailText: FancyString(nsAttributedString: NSMutableAttributedString().normal("Blow me down").bold(" you blowhard!"))), qtyAvailable: 3, resourceTypeRequirements: [.organ:2, .hide:3], resourceSpecialRequirements: [.whiteFur:1], innovationRequirement: KDMCrafterUITests.Innovation(name: "Ammonia"), locationRequirement: KDMCrafterUITests.Location(name: "Plumery", locationRequirement: "None", resourceRequirement: [.organ:2], isBuilt: false), overlappingResources: [.organ])
    
    func testEncodeDecodePlist() throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        //let data = try encoder.encode(whiteFur)
        let data = try encoder.encode(myNewGear)
        //print(String(data: data, encoding: .utf8)!)
        
        let decoder = PropertyListDecoder()
        //let restored = try decoder.decode(Resource.self, from: data)
        let restored = try decoder.decode(KDMCrafterUITests.Gear.self, from: data)
//        dump(restored)
        let name = restored.name
        let description = restored.description
        let type = description.type
        let statsLeft = description.statsLeft
        let statsRight = description.statsRight
        let affinities = description.affinities
        let detailText = description.detailText
        guard let resourceTypeRequirements = restored.resourceTypeRequirements as? [KDMCrafterUITests.resourceType:Int] else {
            print("Can't convert!")
            return
        }
        guard let resourceSpecialRequirements = restored.resourceSpecialRequirements as? [KDMCrafterUITests.resourceType:Int] else {
            print("Can't convert!")
            return
        }
        guard let innovationRequirement = restored.innovationRequirement else {
            print("No innovation!")
            return
        }
        let locationRequirement = restored.locationRequirement
        let overlappingResources = restored.overlappingResources
        
        print("Name: \(name), Type: \(type.rawValue), StatsLeft: \(statsLeft), StatsRight: \(statsRight), Affinities: \(affinities), DetailText: \(detailText.attributedString), TypeRequirements: \(resourceTypeRequirements), SpecialRequirements: \(resourceSpecialRequirements), innovationRequirement: \(innovationRequirement.name), locationRequirement: \(locationRequirement?.name)")
    }
}

class KDMCrafterUITests: XCTestCase {
    // Gear Section
    struct Gear: Hashable, Codable {
        
        enum CodingKeys: String, CodingKey {
            
            case name = "Name"
            case description = "Gear"
            case qtyAvailable = "Qty Available"
            case resourceTypeRequirements = "Resource Type Requirements"
            case resourceSpecialRequirements = "Resource Special Requirements"
            case innovationRequirement = "Innovation Requirement"
            case locationRequirement = "Location Requirement"
            case overlappingResources = "Overlapping Resources"
        }
        
        public init(from decoder: Decoder) throws {
            let gear = try decoder.container(keyedBy: CodingKeys.self)
            name = try gear.decode(String.self, forKey: .name)
            description = try gear.decode(GearDescription.self, forKey: .description)
            qtyAvailable = try gear.decode(Int.self, forKey: .qtyAvailable)
            resourceTypeRequirements = try gear.decode([resourceType:Int]?.self, forKey: .resourceTypeRequirements)
            resourceSpecialRequirements = try gear.decode([resourceType:Int]?.self, forKey: .resourceSpecialRequirements)
            innovationRequirement = try gear.decode(Innovation.self, forKey: .innovationRequirement)
            locationRequirement = try gear.decode(Location.self, forKey: .locationRequirement)
            overlappingResources = try gear.decode([resourceType].self, forKey: .overlappingResources)
        }
        func encode(to encoder: Encoder) throws {
            var data = encoder.container(keyedBy: CodingKeys.self)
            try data.encode(name, forKey: .name)
            try data.encode(description, forKey: .description)
            try data.encode(qtyAvailable, forKey: .qtyAvailable)
            try data.encode(resourceTypeRequirements, forKey: .resourceTypeRequirements)
            try data.encode(resourceSpecialRequirements, forKey: .resourceSpecialRequirements)
            try data.encode(innovationRequirement, forKey: .innovationRequirement)
            try data.encode(locationRequirement, forKey: .locationRequirement)
            try data.encode(overlappingResources, forKey: .overlappingResources)
        }
        static func == (lhs: Gear, rhs: Gear) -> Bool {
            return lhs.name == rhs.name
        }
        
        let name: String
        let description: GearDescription
        let qtyAvailable: Int
        var resourceTypeRequirements: [resourceType:Int]? = nil
        var resourceSpecialRequirements: [resourceType:Int]? = nil
        var innovationRequirement: Innovation? = nil
        var locationRequirement: Location?
        var overlappingResources: [resourceType]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
        
        // Full init
        init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [resourceType:Int], innovationRequirement: Innovation, locationRequirement: Location, overlappingResources: [resourceType]) {
            
            self.name = name
            self.description = description
            self.qtyAvailable = qtyAvailable
            self.resourceTypeRequirements = resourceTypeRequirements
            self.resourceSpecialRequirements = resourceSpecialRequirements
            self.innovationRequirement = innovationRequirement
            self.locationRequirement = locationRequirement
            self.overlappingResources = overlappingResources
        }
        // Non Innovation init
        init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], resourceSpecialRequirements: [resourceType:Int], locationRequirement: Location, overlappingResources: [resourceType]) {
            
            self.name = name
            self.description = description
            self.qtyAvailable = qtyAvailable
            self.resourceTypeRequirements = resourceTypeRequirements
            self.resourceSpecialRequirements = resourceSpecialRequirements
            self.locationRequirement = locationRequirement
            self.overlappingResources = overlappingResources
        }
        // Non Special Resource requirement Has Innovation requirement init
        init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], innovationRequirement: Innovation, locationRequirement: Location, overlappingResources: [resourceType]) {
            
            self.name = name
            self.description = description
            self.qtyAvailable = qtyAvailable
            self.resourceTypeRequirements = resourceTypeRequirements
            self.innovationRequirement = innovationRequirement
            self.locationRequirement = locationRequirement
            self.overlappingResources = overlappingResources
            
        }
        // Non Special Resource requirement Non Innovation requirement init
        init(name: String, description: GearDescription, qtyAvailable: Int, resourceTypeRequirements: [resourceType:Int], locationRequirement: Location, overlappingResources: [resourceType]) {
            
            self.name = name
            self.description = description
            self.qtyAvailable = qtyAvailable
            self.resourceTypeRequirements = resourceTypeRequirements
            self.locationRequirement = locationRequirement
            self.overlappingResources = overlappingResources
        }
    }
    // Innovation declarations
    let ammonia = Innovation(name: "Ammonia")
    let drums = Innovation(name: "Drums")
    let heat = Innovation(name: "Heat")
    let paint = Innovation(name: "Paint")
    let pictograph = Innovation(name: "Pictograph")
    let pottery = Innovation(name: "Pottery")
    
    // Resource Section
    enum resourceKind: String, Codable {
        case whiteLion
    }
    enum resourceType: String, Codable {
        case bone = "Bone"
        case endeavor = "Endeavor"
        case hide = "Hide"
        case organ = "Organ"
        case whiteFur = "White Fur"
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
    
    let whiteFur = Resource(name: "White Fur", kind: .whiteLion, type: [.hide, .whiteFur])

    func testEncodeDecodePlist() throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        //let data = try encoder.encode(whiteFur)
        let data = try encoder.encode(myGearDescription)
        print(String(data: data, encoding: .utf8)!)
        
        let decoder = PropertyListDecoder()
        //let restored = try decoder.decode(Resource.self, from: data)
        let restored = try decoder.decode(GearDescription.self, from: data)
        dump(restored)
    }
    
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
    enum affinity: String, Codable {
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
            type = KDMCrafterUITests.gearType(rawValue: try desc.decode(String.self, forKey: .type))!
            statsLeft = try desc.decode(String.self, forKey: .statsLeft)
            statsRight = try desc.decode(String.self, forKey: .statsRight)
            affinities = try desc.decode([affinity].self, forKey: .affinities)
            detailText = try desc.decode(FancyString.self, forKey: .detailText)
        }

        let type: gearType
        //let stats: statType
        let statsLeft: String
        let statsRight: String
        let affinities: [affinity]
        let detailText: FancyString
        
        init(type: gearType, statsLeft: String, statsRight: String, affinities: [affinity], detailText: FancyString) {
            
            self.type = type
            self.statsLeft = statsLeft
            self.statsRight = statsRight
            self.affinities = affinities
            self.detailText = detailText
            
        }
    }
    
    let myGearDescription = GearDescription(type: .armor, statsLeft: "5", statsRight: armorLocation.head.rawValue, affinities: [.blueUp], detailText: FancyString(nsAttributedString: NSMutableAttributedString().normal("Add 2 armor to all hit locations.\n\n").bold("Block 2").normal(": Spend an activation to ignore 2 hits the next time you are attacked. Lasts until your next act. You cannot use ").bold("block").normal(" more than once per attack.")))
    
    struct Location: Hashable, Codable {
        
        let name: String
        let locationRequirement: String
        let resourceRequirements: [resourceType:Int]
        var isBuilt: Bool
        
        init(name: String, locationRequirement: String, resourceRequirement: [resourceType:Int], isBuilt: Bool) {
            
            self.name = name
            self.locationRequirement = locationRequirement
            self.resourceRequirements = resourceRequirement
            self.isBuilt = isBuilt
        }
    }
    
    // Location declarations
    let barberSurgeon = Location(name: "Barber Surgeon", locationRequirement: "Special: Defeat L2 Screaming Antelope with Pottery innovated", resourceRequirement: [:], isBuilt: false) // Allow toggle, but pop up message confirming requirement met
    let blackSmith = Location(name: "Blacksmith", locationRequirement: "Special: Innovate Scrap Smelting", resourceRequirement: [:], isBuilt: false) // Allow toggle, but pop up message confirming requirement met
    let boneSmith = Location(name: "Bone Smith", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1], isBuilt: false)
    let catarium = Location(name: "Catarium", locationRequirement: "Special: Defeat White Lion", resourceRequirement: [:], isBuilt: false) // Allow toggle, but pop up message confirming requirement met
    let exhaustedLanternHoard = Location(name: "Exhausted Lantern Hoard", locationRequirement: "Special: Archive Lantern Hoard at endgame", resourceRequirement: [:], isBuilt: false) // Allow toggle, but pop up message confirming requirement met
    let lanternHoard = Location(name: "Lantern Hoard", locationRequirement: "Special: Enabled by default", resourceRequirement: [:], isBuilt: true) // Enabled by default
    let leatherWorker = Location(name: "Leather Worker", locationRequirement: "Skinnery", resourceRequirement: [.hide:3, .organ:1], isBuilt: false)
    let maskMaker = Location(name: "Mask Maker", locationRequirement: "Special: Acquire Forsaker Mask", resourceRequirement: [:], isBuilt: false    ) // Allow toggle, but pop up message confirming requirement met
    let organGrinder = Location(name: "Organ Grinder", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1], isBuilt: false)
    let plumery = Location(name: "Plumery", locationRequirement: "Special: Defeat Phoenix", resourceRequirement: [:], isBuilt: false) // Allow toggle, but pop up message confirming requirement met
    let skinnery = Location(name: "Skinnery", locationRequirement: "Lantern Hoard", resourceRequirement: [.endeavor:1], isBuilt: false)
    let stoneCircle = Location(name: "Stone Circle", locationRequirement: "Organ Grinder", resourceRequirement: [.organ:3, .hide:1], isBuilt: false)
    let weaponCrafter = Location(name: "Weapon Crafter", locationRequirement: "Bone Smith", resourceRequirement: [.bone:3, .hide:1], isBuilt: false)
    
    struct Innovation: Hashable, Codable {
        
        let name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
    //let speedPowder = Gear(name: "Speen Pownder", description: GearDescription(type: .item, statsLeft: "N/A", statsRight: "N/A", affinities: [.blueUp], detailText: FancyString(nsAttributedString: NSMutableAttributedString().normal("Spend 1 activation to suffer 2 brain damage. Gain 1 speed token. Use once per showdown."))), qtyAvailable: 3, resourceTypeRequirements: [.organ:2], innovationRequirement: ammonia, locationRequirement: boneSmith, overlappingResources: [.organ])

}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let boldString = NSMutableAttributedString.makeWithBold(text: text)
        append(boldString)
        
        return self
    }
    @discardableResult func boldCenter(_ text: String) -> NSMutableAttributedString {
        let boldCenterString = NSMutableAttributedString.makeWithBoldCenter(text: text)
        append(boldCenterString)
        
        return self
    }
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString.makeWithNormal(text: text)
        append(normal)
        
        return self
    }
}
extension NSAttributedString {
    
    public static func makeWithBold(text: String) -> NSMutableAttributedString {
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        return NSMutableAttributedString(string: text, attributes:attrs)
    }
    public static func makeWithNormal(text: String) -> NSMutableAttributedString {
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)]
        return NSMutableAttributedString(string: text, attributes:attrs)
    }
    public static func makeWithBoldCenter(text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes:attrs)
        
    }
}

class FancyString: Codable {
    let attributedString : NSMutableAttributedString
    
    init(nsAttributedString : NSMutableAttributedString) {
        self.attributedString = nsAttributedString
    }
    
    public required init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        let base64String = try singleContainer.decode(String.self)
        guard let data = Data(base64Encoded: base64String) else { throw DecodingError.dataCorruptedError(in: singleContainer, debugDescription: "String is not a base64 encoded string") }
        guard let attributedString = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSMutableAttributedString.self], from: data) as? NSMutableAttributedString else { throw DecodingError.dataCorruptedError(in: singleContainer, debugDescription: "Data is not NSMutableAttributedString") }
        self.attributedString = attributedString
    }
    
    func encode(to encoder: Encoder) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false)
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(data.base64EncodedString())
    }
}
