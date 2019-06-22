//
//  CraftBuildValidator.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/27/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import Foundation

public class CraftBuildValidator {
    
    var settlement: Settlement!
    var resources: [Resource:Int]!

    init(settlement: Settlement) {
        self.settlement = settlement
        self.resources = settlement.resourceStorage
    }
    
    func checkCraftability(gear: Gear) -> Bool {
        let resources = settlement!.resourceStorage
        let typeRequirements = gear.resourceTypeRequirements
        let specialRequirements = gear.resourceSpecialRequirements
        let innovationRequirement = gear.innovationRequirement
        var numTypeCraftable = Int()
        var numSpecialCraftable = Int()
        var innovationExists = Bool()
        let locationExists = settlement!.locationsBuiltDict[gear.locationRequirement!]!
        var isCraftable = Bool()
        var craftableTypes = [Int]()
        var craftableSpecials = [Int]()
        
        if typeRequirements?.count != 0 || typeRequirements != nil {
            for (type, qty) in typeRequirements! {
                let typeCount = getTypeCount(type: type, resources: resources)
                numTypeCraftable = (typeCount/qty)
                craftableTypes.append(numTypeCraftable)
            }
        }
        if specialRequirements?.count != nil {
            for (special, qty) in specialRequirements! {
                let specialCount = getSpecialCount(resources: resources, special: special.type[0])
                numSpecialCraftable = (specialCount/qty)
                craftableSpecials.append(numSpecialCraftable)
                if numSpecialCraftable == 0 {
                } else {
                    if gear.resourceSpecialRequirements != nil {

                    }
                }
            }
        }
        if innovationRequirement != nil {
            innovationExists = getInnovationExists(innovation: gear.innovationRequirement!)
        }
        if gear.resourceSpecialRequirements == nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count != 0 { // Basic resource only
            isCraftable = checkCraftability2(gear: gear).2
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && gear.resourceTypeRequirements!.count != 0 { // Special and regular resource types required, but no innovation required
            if gear.name == "Skull Helm" { // Special case of either/or
                isCraftable = checkCraftability2(gear: gear).2
            } else {
                isCraftable = checkCraftability2(gear: gear).2
            }
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count == 0 { //Special resource required, no innovation or regular types required
            isCraftable = checkCraftability2(gear: gear).2
        } else if gear.resourceSpecialRequirements == nil && (gear.innovationRequirement != nil && innovationExists) && locationExists && typeRequirements!.count != 0 { // Innovation required and regular resource types required
            isCraftable = checkCraftability2(gear: gear).2
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count != 0 && gear.resourceSpecialRequirements != nil { //Innovation and regular resource and special required
            isCraftable = checkCraftability2(gear: gear).2
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count == 0 && gear.resourceSpecialRequirements != nil { //Requires special and innovation but not regular
            isCraftable = checkCraftability2(gear: gear).2
        } else {
            //print(gear.name)
        }
        
        // Need to deal with gear type 'any' case when we get to actually decrementing gear storage for crafting!
        
        return isCraftable
    }
    func getTypeCount(type: resourceType, resources: [Resource:Int]) -> Int {
        var count = Int()
        if type == .any { // e.g. for Musk Bomb
            count = resources.filter { $0.value > 0 }.count
        } else {
            count = resources.filter { key, value in return key.type.contains(type) }.values.reduce(0, +)
        }
        return count
    }
    func getSpecialCount(resources: [Resource:Int], special: resourceType) -> Int {
        let count = resources.filter { key, value in return key.type.contains(special) }.values.reduce(0, +)
        return count
    }
    func getInnovationExists(innovation: Innovation) -> Bool {
        if self.settlement!.innovationsAddedDict[innovation] == true {
            return true
        } else {
            return false
        }
    }
    func getMissingLocationResourceRequirements(location: Location) -> [String:Int] {
        var myDict = [String:Int]()
        let resourceRequirements = location.resourceRequirements
        if resourceRequirements.count != 0 {
            for (type, qty) in resourceRequirements {
                let typeCount = getTypeCount(type: type, resources: resources)
                if typeCount < qty {
                    myDict[type.rawValue] = (qty - typeCount)
                }
            }
        }
        return myDict
    }
    func getGearResourceRequirements(gear: Gear) -> [[String:Int]] {
        var myArray = [[String:Int]]()
        let resourceTypeRequirements = gear.resourceTypeRequirements
        let resourceSpecialRequirements = gear.resourceSpecialRequirements
        if resourceSpecialRequirements != nil && resourceSpecialRequirements!.count != 0 {
            for pair in resourceSpecialRequirements! {
                myArray.append([pair.key.name:pair.value])
            }
        }
        if resourceTypeRequirements!.count != 0 {
            for pair in resourceTypeRequirements! {
                myArray.append([pair.key.rawValue:pair.value])
            }
        }
        return myArray
    }
    func getSpecialStrings(resources: [Resource:Int]) -> [String] {
        var myArray = [String]()
        for (name, _) in resources {
            myArray.append(name.name)
        }
        return myArray
    }
    func isBuildable(locations: [Location], location: Location) -> Bool {
        if settlement!.locationsBuiltDict[location] == true {
            return false
        } else if isResourceRequirementMet(resources: resources, location: location) && isLocationRequirementMet(locations: locations, location: location) || settlement!.overrideEnabled == true {
            return true
        } else {
            return false
        }
    }
    func isResourceRequirementMet(resources: [Resource:Int], location: Location) -> Bool {
        let resourceRequirements = location.resourceRequirements
        var resourceRequirementsMet = Bool()
        if location.locationRequirement.contains("Special") { resourceRequirementsMet = true }
        if resourceRequirements.count != 0 {
            for (type, qty) in resourceRequirements {
                let typeCount = getTypeCount(type: type, resources: resources) // myStorage
                if typeCount < qty {
                    resourceRequirementsMet = false
                    break
                } else {
                    resourceRequirementsMet = true
                }
            }
        }
        return resourceRequirementsMet
    }
    func isLocationRequirementMet(locations: [Location], location: Location) -> Bool {
        var locationRequirementMet = Bool()
        if location.locationRequirement.contains("Special") {
            locationRequirementMet = true
        } else {
            let builtLocationNames = settlement!.locationsBuiltDict.filter { $0.value == true }.map { $0.key.name }
            if builtLocationNames.contains(location.locationRequirement) {
                locationRequirementMet = true
            } else {
                locationRequirementMet = false
            }
        }
        return locationRequirementMet
    }
    func getAllTypesDict() -> [resourceType:Int] {
        var allTypesDict = [resourceType:Int]()
        for (resource, qty) in settlement!.resourceStorage {
            for type in resource.type {
                if allTypesDict[type] != nil {
                    allTypesDict[type]! += qty
                } else {
                    allTypesDict[type] = qty
                }
            }
        }
        return allTypesDict
    }
    func checkCraftability2(gear: Gear) -> ([Resource:Int], [resourceType:Int], Bool) {
        var returnValue = true
        var requiredSpecials = [Resource:Int]()
        var availableSpecials = [Resource:Int]()
        var totalQty = Int()
        // First, see if it's craftable
        // Loop through any special requirements to make sure we have enough
        if gear.resourceSpecialRequirements != nil {
            for (resource, qty) in gear.resourceSpecialRequirements! {
                totalQty = 0
                let difference = (settlement!.resourceStorage[resource]! - qty) >= 0 ? (settlement!.resourceStorage[resource]! - qty):0
                if self.getAllTypesDict()[resource.type[0]] != nil && self.getAllTypesDict()[resource.type[0]] != 0 {
                    totalQty += self.getAllTypesDict()[resource.type[0]]! - difference
                }
                if totalQty >= qty {
                    if returnValue != false {
                        returnValue = true
                        if difference > 0 && availableSpecials[resource] != nil {
                            availableSpecials[resource]! += difference
                        } else if difference > 0 && availableSpecials[resource] == nil {
                            availableSpecials[resource] = difference
                        }
                    }
                } else {
                    returnValue = false
                }
                requiredSpecials[resource] = qty // Keep track of specials required and qty in a dict
            }
        }
        // Need to reduce availability of multi resources that are not part of this gear's cost
        let availableResources = settlement!.resourceStorage.filter { $0.value > 0 }
        var nonBasic = availableResources.filter { $0.key.kind != .basic }
        for (resource, qty) in requiredSpecials {
            if nonBasic[resource] != nil {
                nonBasic[resource]! -= qty // reduce available nonBasics by number required for this gear
            }
        }
        let multi = nonBasic.filter { $0.key.type.count > 1 }
        //print(multi.keys.map { $0.name })
        var preBasics = [resourceType:Int]()
        let basics = settlement!.resourceStorage.filter { $0.key.kind == .basic }
        if gear.resourceTypeRequirements != [:] {
            for (resource, qty) in basics {
                for type in resource.type {
                    if gear.resourceTypeRequirements!.keys.contains(type) {
                        if qty > 0 {
                            if preBasics[type] != nil {
                                preBasics[type]! += qty
                            } else {
                                preBasics[type] = qty
                            }
                        }
                    }
                }
            }
        }
        var availableBasics = [resourceType:Int]()
        var resourceCountDict = [Resource:Int]()
        var gearRequiredSpecialTypes = [resourceType]()
        if gear.resourceSpecialRequirements != nil {
            gearRequiredSpecialTypes = gear.resourceSpecialRequirements!.keys.flatMap { $0.type }
            //if gear.name == "Lantern Sword" { print(gearRequiredSpecialTypes) }
        }
        let types: [resourceType] = [.bone, .consumable, .hide, .iron, .organ, .scrap, .skull, .vermin]
        for (item, qty) in multi {
            //print("Checking \(item.name) with \(qty)")
            for type in item.type {
                if availableBasics[type] != nil && types.contains(type) && (gear.resourceTypeRequirements!.keys.contains(type) || gear.resourceTypeRequirements!.keys.contains(type) && gearRequiredSpecialTypes.contains(type)) {
                    if gear.name == "Lantern Sword" { print("Adding \(type)") }
                    availableBasics[type]! += qty
                    if qty > 0 { resourceCountDict[item] = qty }
//                } else if (type == .hide || type == .organ || type == .bone || type == .consumable)  && gear.resourceTypeRequirements!.keys.contains(type) {
                } else if types.contains(type) && (gear.resourceTypeRequirements!.keys.contains(type) || gear.resourceTypeRequirements!.keys.contains(type) && gearRequiredSpecialTypes.contains(type)) {
                    if gear.name == "Lantern Sword" { print("Setting \(type)") }
                    availableBasics[type] = qty
                    if qty > 0 { resourceCountDict[item] = qty }
                }
            }
        }
        var loopCounter = 0
        if gear.name == "Lantern Sword" {
            print("Basics:\(availableBasics.keys), values: \(availableBasics.values), CountDict: \(resourceCountDict.values.reduce(0, +))")
            print("preBasics: \(preBasics.keys) and \(preBasics.values)")
        }
        // See if we need to reduce or not
        var reduce = true
//        var reduce = false
//        if availableBasics != [:] {
//            for (type, qty) in availableBasics {
//                if preBasics[type] != nil && (qty + preBasics[type]! >= gear.resourceTypeRequirements![type]!) {
//                    if gear.name == "Lantern Sword" {
//                        print("Skipping \(type.rawValue) reduction")
//                    }
//                    continue
//                } else {
//                    reduce = true
//                }
//            }
//        }
        if reduce == true {
            while loopCounter <= resourceCountDict.values.reduce(0, +) && availableBasics != [:] {
                let max = availableBasics.map { $1 }.max()!
                let sum = availableBasics.values.reduce(0, +)
                if gear.name == "Lantern Sword" {
                    print("max:\(max), sum: \(sum), reduce: \(resourceCountDict.values.reduce(0, +))")
                }

                if sum == resourceCountDict.values.reduce(0, +) {
                    break
                }
                for (type, qty) in availableBasics {
//                    if (preBasics[type] != nil) && (qty + preBasics[type]! > gear.resourceTypeRequirements![type]!) {
//                        if gear.name == "Oxidized Lantern Sword" {
//                            print("Decrementing: \(type) due to amnt being met already.")
//                            print("Basics now: \(availableBasics.keys), \(availableBasics.values)")
//                        }
//                        availableBasics[type]! -= 1
//                        break
//                    }
                    if qty == max {
                        if (preBasics[type] != nil) && (preBasics[type]! >= gear.resourceTypeRequirements![type]!) {
                            print("Reducing \(type.rawValue) as we already have enough.")
                            print("Reducing \(type.rawValue)")
                            availableBasics[type]! -= 1
                            break
                        } else if (preBasics[type] != nil) && (qty + preBasics[type]! > gear.resourceTypeRequirements![type]!) {
                            print("Reducing \(type.rawValue) as we already have enough.")
                            print("Reducing \(type.rawValue)")
                            availableBasics[type]! -= 1
                            break
                        } else {
                            continue
                        }
//                        print("Reducing \(type.rawValue)")
//                        availableBasics[type]! -= 1
//                        break
                    }
                }
                loopCounter += 1
            }
        }
        if gear.name == "Lantern Sword" {
            print("Basics final: \(availableBasics.keys), \(availableBasics.values)")
        }
        // Now get basic types and add to remaining multis (availableBasics)
        let postBasics = settlement!.resourceStorage.filter { $0.key.kind == .basic }
        if gear.resourceTypeRequirements != [:] {
            for (resource, qty) in postBasics {
                for type in resource.type {
                    if gear.resourceTypeRequirements!.keys.contains(type) {
                        if qty > 0 {
                            if availableBasics[type] != nil {
                                availableBasics[type]! += qty
                            } else {
                                availableBasics[type] = qty
                            }
                        }
                    }
                }
            }
        }
        if gear.resourceTypeRequirements != [:] {
            for (type, qty) in gear.resourceTypeRequirements! {
                if availableBasics[type] != nil && availableBasics[type]! >= qty {
                    if returnValue != false {
                        returnValue = true
                    }
                } else {
                    returnValue = false
                }
            }
        }
        //print("Specials: \(availableSpecials), Basics: \(availableBasics), Return: \(returnValue)")
        return (availableSpecials, availableBasics, returnValue)
    }
}
