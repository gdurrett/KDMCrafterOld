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
    
    init(settlement: Settlement) {
        self.settlement = settlement
    }
    
//    func checkCraftability(resources: [Resource:Int], gear: Gear) -> Int {
    func checkCraftability(gear: Gear) -> Int {
        let resources = settlement!.resourceStorage
        let typeRequirements = gear.resourceTypeRequirements
        let specialRequirements = gear.resourceSpecialRequirements
        let innovationRequirement = gear.innovationRequirement
        var numTypeCraftable = Int()
        var numSpecialCraftable = Int()
        var innovationExists = Bool()
        //let locationExists =  settlement!.allLocations[gear.locationRequirement.rawValue].isBuilt == true
        let locationExists = settlement!.locationsBuiltDict[gear.locationRequirement!]!
        var maxCraftable = Int()
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
                let specialCount = getSpecialCount(resources: resources, special: special)
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
        if gear.name == "Bone Dagger" {
            print("For BD, requiredLocation built is \(locationExists)")
        }
        if gear.resourceSpecialRequirements == nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count != 0 { // Basic resource only
            maxCraftable = craftableTypes.min()!
            print("Section 1")
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && gear.resourceTypeRequirements!.count != 0 { // Special and regular resource types required, but no innovation required
            if gear.name == "Skull Helm" { // Special case of either/or
                maxCraftable = craftableTypes.min()! + craftableSpecials.min()!
            } else {
                print("Section 2")
                maxCraftable = [craftableTypes.min()!, craftableSpecials.min()!].min()!
            }
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count == 0 { //Special resource required, no innovation or regular types required
            print("Should get here for circlet!")
            maxCraftable = craftableSpecials.min()!
        } else if gear.resourceSpecialRequirements == nil && (gear.innovationRequirement != nil && innovationExists) && locationExists && typeRequirements!.count != 0 { // Innovation required and regular resource types required
            maxCraftable = craftableTypes.min()!
            print("Section 3")
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count != 0 && gear.resourceSpecialRequirements != nil { //Innovation and regular resource and special required
            maxCraftable = [craftableTypes.min()!, craftableSpecials.min()!].min()!
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count == 0 && gear.resourceSpecialRequirements != nil { //Requires special and innovation but not regular
            maxCraftable = craftableSpecials.min()!
            print("Section 4")
        } else {
            //print(gear.name)
        }
        
        // Need to deal with gear type 'any' case when we get to actually decrementing gear storage for crafting!
        
        return maxCraftable
    }
    func getTypeCount(type: resourceType, resources: [Resource:Int]) -> Int {
        var count = Int()
        if type == .any { // e.g. for Musk Bomb
            count = resources.count
        } else {
            count = resources.filter { key, value in return key.type.contains(type) }.values.reduce(0, +)
        }
        return count
    }
    func getSpecialCount(resources: [Resource:Int], special: Resource) -> Int {
        let count = resources[special]!
        return count
    }
    func getInnovationExists(innovation: Innovation) -> Bool {
        if myInnovations.contains(innovation) {
            return true
        } else {
            return false
        }
    }
    func getMissingLocationResourceRequirements(resources: [Resource:Int], location: Location) -> [String:Int] {
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
    func isBuildable(resources: [Resource:Int], locations: [Location], location: Location) -> Bool {
        if location.isBuilt { return false }
        if isResourceRequirementMet(resources: resources, location: location) && isLocationRequirementMet(locations: locations, location: location) {
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
            //print("We can build \(location.name) if we have met this condition: \(location.locationRequirement)")
            locationRequirementMet = true
        } else {
            let builtLocationNames = locations.filter { $0.isBuilt }.map { $0.name }
            if builtLocationNames.contains(location.locationRequirement) {
                locationRequirementMet = true
            } else {
                locationRequirementMet = false
            }
        }
        return locationRequirementMet
    }
//    let dataModel = DataModel.sharedInstance
//    let mySettlement = DataModel.sharedInstance.currentSettlement!
//    let myStorage = DataModel.sharedInstance.currentSettlement!.resourceStorage
//    let myAvailableGear = DataModel.sharedInstance.currentSettlement!.availableGear
    let myInnovations = DataModel.sharedInstance.currentSettlement!.innovations
//    let myLocations = DataModel.sharedInstance.currentSettlement!.allLocations

}
