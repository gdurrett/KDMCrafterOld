//
//  FirstViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let dataModel = DataModel.sharedInstance
    
    var myStorage: [Resource:Int]?
    var myAvailableGear: [Gear]?
    var hidesTotal: Int?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement.resourceStorage
        myAvailableGear = mySettlement.availableGear
        myInnovations = mySettlement.innovations
        myLocations = mySettlement.locations
        
        //let currentResource = myStorage!.filter { $0.key.name == "Lion Tail" }.first
        
        myStorage![lionTail]! += 4
        myStorage![shankBone]! += 2
        myStorage![birdBeak]! += 3
        myStorage![leather]! += 3
        myStorage![screamingBrain]! += 2
        myStorage![multi]! += 1
        myInnovations!.append(paint)
        myLocations!.append(barberSurgeon)
        
        for gear in myAvailableGear! {
            let count = checkCraftability(gear: gear)
            print("We can craft: \(count) \(gear.name)")
        }
    }
    
    func getTypeCount(type: resourceType, resources: [Resource:Int]) -> Int {
        let count = resources.filter { key, value in return key.type.contains(type) }.values.reduce(0, +)
        return count
    }
    func getSpecialCount(special: Resource) -> Int {
        let count = myStorage![special]!
        return count
    }
    func getInnovationExists(innovation: Innovation) -> Bool {
        if myInnovations!.contains(innovation) {
            return true
        } else {
            return false
        }
    }
    func getLocationExists(location: Location) -> Bool {
        if myLocations!.contains(location) {
            return true
        } else {
            return false
        }
    }
    func checkCraftability(gear: Gear) -> Int {
        let typeRequirements = gear.resourceTypeRequirements
        let specialRequirements = gear.resourceSpecialRequirements
        let innovationRequirement = gear.innovationRequirement
        var numTypeCraftable = Int()
        var numSpecialCraftable = Int()
        var innovationExists = Bool()
        let locationExists = getLocationExists(location: gear.locationRequirement)
        var maxCraftable = Int()
        var craftableTypes = [Int]()
        
        if typeRequirements.count != 0 {
            for (type, qty) in typeRequirements {
                let typeCount = getTypeCount(type: type, resources: myStorage!)
                numTypeCraftable = (typeCount/qty)
                craftableTypes.append(numTypeCraftable)
                if numTypeCraftable == 0 {
                    print("Missing \(type.rawValue)")
                }
            }
        }
        if specialRequirements?.count != nil {
            for (special, qty) in specialRequirements! {
                let specialCount = getSpecialCount(special: special)
                numSpecialCraftable = (specialCount/qty)
                if numSpecialCraftable == 0 {
                    print("Missing \(special.name) special resource for \(gear.name).")
                }
            }
        }
        if innovationRequirement != nil {
            innovationExists = getInnovationExists(innovation: gear.innovationRequirement!)
        }
        if gear.resourceSpecialRequirements == nil && gear.innovationRequirement == nil && locationExists && typeRequirements.count != 0 { // No special resource required, no innovation required (only regular types)
            maxCraftable = craftableTypes.min()!
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements.count != 0 { // Special and regular resource types required, but no innovation required
            maxCraftable = [craftableTypes.min()!, numSpecialCraftable].min()!
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements.count == 0 { //Special resource required, no innovation or regular types required
            maxCraftable = numSpecialCraftable
        } else if gear.resourceSpecialRequirements == nil && (gear.innovationRequirement != nil && innovationExists) && locationExists && typeRequirements.count != 0 { // Innovation required and regular resource types required
            maxCraftable = craftableTypes.min()!
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements.count != 0 { //Innovation and regular resource type required (no special required)
            maxCraftable = [craftableTypes.min()!, numSpecialCraftable].min()!
        }
        
        return maxCraftable
    }
}

