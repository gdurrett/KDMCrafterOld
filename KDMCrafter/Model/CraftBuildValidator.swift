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
                //print(type,typeCount)
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
                    //print("Missing \(special.name) special resource for \(gear.name).")
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
//            isCraftable = craftableTypes.min()!
            isCraftable = checkCraftability2(gear: gear).2
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && gear.resourceTypeRequirements!.count != 0 { // Special and regular resource types required, but no innovation required
            if gear.name == "Skull Helm" { // Special case of either/or
//                isCraftable = craftableTypes.min()! + craftableSpecials.min()!
                isCraftable = checkCraftability2(gear: gear).2
            } else {
//                isCraftable = [craftableTypes.min()!, craftableSpecials.min()!].min()!
                isCraftable = checkCraftability2(gear: gear).2
            }
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count == 0 { //Special resource required, no innovation or regular types required
//            isCraftable = craftableSpecials.min()!
            isCraftable = checkCraftability2(gear: gear).2
        } else if gear.resourceSpecialRequirements == nil && (gear.innovationRequirement != nil && innovationExists) && locationExists && typeRequirements!.count != 0 { // Innovation required and regular resource types required
//            isCraftable = craftableTypes.min()!
            isCraftable = checkCraftability2(gear: gear).2
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count != 0 && gear.resourceSpecialRequirements != nil { //Innovation and regular resource and special required
//            isCraftable = [craftableTypes.min()!, craftableSpecials.min()!].min()!
            isCraftable = checkCraftability2(gear: gear).2
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count == 0 && gear.resourceSpecialRequirements != nil { //Requires special and innovation but not regular
//            isCraftable = craftableSpecials.min()!
            isCraftable = checkCraftability2(gear: gear).2
        } else {
            print(gear.name)
        }
        
        // Need to deal with gear type 'any' case when we get to actually decrementing gear storage for crafting!
        
        return isCraftable
    }
    func getTypeCount(type: resourceType, resources: [Resource:Int]) -> Int {
        var count = Int()
        if type == .any { // e.g. for Musk Bomb
            //count = resources.count
            count = resources.filter { $0.value > 0 }.count
        } else {
            count = resources.filter { key, value in return key.type.contains(type) }.values.reduce(0, +)
            //print("GetTypeCt returning: \(type)")
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
            //print("Returning true for \(location.name)")
            return true
        } else {
            //print("Returning false for \(location.name)")
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
    func checkCraftability2(gear: Gear) -> ([Resource:Int], [resourceType:Int], Bool, [Resource:Int]) {
        var returnValue = true
        var requiredSpecials = [Resource:Int]()
        var availableSpecials = [Resource:Int]()
        // First, see if it's craftable
        // Loop through any special requirements to make sure we have enough
        if gear.resourceSpecialRequirements != nil {
            for (resource, qty) in gear.resourceSpecialRequirements! {
                let difference = (settlement!.resourceStorage[resource]! - qty)
                if settlement!.resourceStorage[resource]! >= qty {
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
        //print("Specials required: \(requiredSpecials.keys)")
        // Need to reduce availability of multi resources that are not part of this gear's cost
        let availableResources = settlement!.resourceStorage.filter { $0.value > 0 }
        var nonBasic = availableResources.filter { $0.key.kind != .basic }
        for (resource, qty) in requiredSpecials {
            if nonBasic[resource] != nil {
                nonBasic[resource]! -= qty // reduce available nonBasics by number required for this gear
            }
        }
        let multi = nonBasic.filter { $0.key.type.count > 1 }

        //print("Multi: \(multi.keys)")
        var availableBasics = [resourceType:Int]()
        var availableBasicsResources = [Resource:Int]()
        var resourceCountDict = [Resource:Int]()
        for (item, qty) in multi {
            for type in item.type {
                if availableBasics[type] != nil && (type == .hide || type == .organ || type == .bone || type == .consumable) && gear.resourceTypeRequirements!.keys.contains(type) {
                    availableBasics[type]! += qty
                    if qty > 0 { resourceCountDict[item] = 1 }
                } else if (type == .hide || type == .organ || type == .bone || type == .consumable)  && gear.resourceTypeRequirements!.keys.contains(type) {
                    availableBasics[type] = qty
                    if qty > 0 { resourceCountDict[item] = 1 }
                }
            }
        }

        var loopCounter = 0
        while loopCounter <= resourceCountDict.count && availableBasics != [:] {
            let max = availableBasics.map { $1 }.max()!
            let sum = availableBasics.values.reduce(0, +)
            if sum == resourceCountDict.count {
                break
            }
            for (type, qty) in availableBasics {
//                if qty == max {
                if qty == max && gear.overlappingResources.contains(type) { //test skip if not in overlapping
                    availableBasics[type]! -= 1
                    print("Decrementing: \(type.rawValue)")
                    break
                }
            }
            loopCounter += 1
        }
        // Now get basic types and add to remaining multis (availableBasics)
        let basics = settlement!.resourceStorage.filter { $0.key.kind == .basic }
        if gear.resourceTypeRequirements != [:] {
            for (resource, qty) in basics {
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
                    print("We have enough resource types!")
                } else {
                    returnValue = false
                    print("Not enough resource types!")
                }
            }
        }
        //print("Required Specials: \(gear.resourceSpecialRequirements), Required Basics: \(gear.resourceTypeRequirements)")
        return (availableSpecials, availableBasics, returnValue, availableBasicsResources)
    }
}
