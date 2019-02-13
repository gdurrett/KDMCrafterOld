//
//  FirstViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class ResourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myBuiltLocations: [Location]?
    var myAvailableLocations: Set<Location>?
    
    var resourceName: String?
    var resourceValue: Int?
    var currentResource: Resource?

    var hidden:[Bool] = [true, true, true] // For collapsible sections
    var numResourceRows: Int?
    var numLocationRows: Int?
    var numInnovationRows: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.register(LocationTableViewCell.nib, forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement!.resourceStorage
        myAvailableGear = mySettlement!.availableGear
        myInnovations = mySettlement!.innovations
        myBuiltLocations = mySettlement!.builtLocations
        myAvailableLocations = Set(mySettlement!.allLocations).subtracting(myBuiltLocations!)
        
        myInnovations!.append(ammonia)
        myBuiltLocations!.append(blackSmith)
        myBuiltLocations!.append(barberSurgeon)
        
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name })
        
        numResourceRows =  dataModel.currentSettlement!.resourceStorage.count
        numLocationRows = 1
        numInnovationRows = 1
        //numLocationRows = dataModel.currentSettlement!.availableLocations.count
        //numInnovationRows = dataModel.currentSettlement!.innovations.count
        
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
        if myBuiltLocations!.contains(location) {
            return true
        } else {
            return false
        }
    }
    func checkBuildability(location: Location) -> Bool {
        let resourceRequirements = location.resourceRequirements
        var resourceRequirementsMet = Bool()
        
        if resourceRequirements.count != 0 {
            for (type, qty) in resourceRequirements {
                let typeCount = getTypeCount(type: type, resources: myStorage!)
                if typeCount < qty {
                    //print("Not enough \(type) for \(location.name)")
                    resourceRequirementsMet = false
                    break
                } else {
                    resourceRequirementsMet = true
                }
            }
        }
        if location.locationRequirement.contains("Special") {
            //print("We can build \(location.name) if we have met this condition: \(location.locationRequirement)")
            return true
        } else {
            let locationNames = myBuiltLocations!.map { $0.name }
            if locationNames.contains(location.locationRequirement) && resourceRequirementsMet {
                return true
            } else {
                if !resourceRequirementsMet {
                    //print("We cannot build \(location.name) due to lack of resources.")
                } else if !locationNames.contains (location.locationRequirement) {
                    //print("We cannot build \(location.name) due to lack of location.")
                }
                return false
            }
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
        var craftableSpecials = [Int]()
        
        if typeRequirements?.count != 0 || typeRequirements != nil {
            for (type, qty) in typeRequirements! {
                let typeCount = getTypeCount(type: type, resources: myStorage!)
                numTypeCraftable = (typeCount/qty)
                craftableTypes.append(numTypeCraftable)
                if numTypeCraftable == 0 {
                    //print("Missing \(type.rawValue)")
                }
            }
        }
        if specialRequirements?.count != nil {
            for (special, qty) in specialRequirements! {
                //print("Getting \(special.name)")
                let specialCount = getSpecialCount(special: special)
                numSpecialCraftable = (specialCount/qty)
                craftableSpecials.append(numSpecialCraftable)
                if numSpecialCraftable == 0 {
                    //print("Missing \(special.name) special resource for \(gear.name).")
                }
            }
        }
        if innovationRequirement != nil {
            innovationExists = getInnovationExists(innovation: gear.innovationRequirement!)
        }
        
        if gear.resourceSpecialRequirements == nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count != 0 { // Basic resource only
            maxCraftable = craftableTypes.min()!
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count != 0 { // Special and regular resource types required, but no innovation required
            if gear.name == "Skull Helm" { // Special case of either/or
                maxCraftable = craftableTypes.min()! + craftableSpecials.min()!
            } else {
                maxCraftable = [craftableTypes.min()!, craftableSpecials.min()!].min()!
            }
        } else if gear.resourceSpecialRequirements != nil && gear.innovationRequirement == nil && locationExists && typeRequirements!.count == 0 { //Special resource required, no innovation or regular types required
            maxCraftable = craftableSpecials.min()!
        } else if gear.resourceSpecialRequirements == nil && (gear.innovationRequirement != nil && innovationExists) && locationExists && typeRequirements!.count != 0 { // Innovation required and regular resource types required
            maxCraftable = craftableTypes.min()!
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count != 0 && gear.resourceSpecialRequirements != nil { //Innovation and regular resource and special required
            maxCraftable = [craftableTypes.min()!, craftableSpecials.min()!].min()!
        } else if locationExists && (gear.innovationRequirement != nil && innovationExists) && typeRequirements!.count == 0 && gear.resourceSpecialRequirements != nil { //Requires special and innovation but not regular
            maxCraftable = craftableSpecials.min()!
        }
        
        // Need to deal with gear type 'any' case when we get to actually decrementing gear storage for crafting!
        
        return maxCraftable
    }
    
    // TableViewDelegate stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hidden[section] {
            return 0
        } else
            if section == 0 {
            return numResourceRows!
        } else if section == 1 {
            return numLocationRows!
        } else if section == 2 {
            return numInnovationRows!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        //let cell = makeCell(for: tableView)
        cell.backgroundColor = UIColor.clear
        
//        let key = Array(self.myStorage!.keys)[indexPath.row]
//        let value = Array(self.myStorage!.values)[indexPath.row]
        let key = sortedStorage![indexPath.row].0
        let value = sortedStorage![indexPath.row].1

        resourceName = key.name
        resourceValue = value
        
        configureTitle(for: cell, with: resourceName!)
        configureValue(for: cell, with: resourceValue!)
        
        cell.stepperOutlet.value = Double(value)
        cell.resourceCountLabel.text! = "\(value)"
        cell.observation = cell.stepperOutlet.observe(\.value, options: [.new]) { (stepper, change) in
            cell.resourceCountLabel.text = "\(change.newValue!)"
            //self.myStorage![key] = Int(change.newValue!)
            self.sortedStorage![indexPath.row].1 = Int(change.newValue!)
            self.myStorage![self.sortedStorage![indexPath.row].0] = Int(change.newValue!)
            DataModel.sharedInstance.currentSettlement!.resourceStorage[self.sortedStorage![indexPath.row].0] = Int(change.newValue!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ResourceTableViewCell).observation = nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.textAlignment = .left
        headerView.tag = section
        
        if section == 0 {
            headerView.textLabel?.text = "Settlement Resource Storage"
        } else if section == 1 {
            headerView.textLabel?.text = "Settlement Locations"
        } else if section == 2 {
            headerView.textLabel?.text = "Settlement Innovations"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(tap)
        return headerView

    }
    // Helper functions
    fileprivate func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "ResourceTableViewCell"
        if let cell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle,reuseIdentifier: cellIdentifier)
        }
    }
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String) {
        let label = cell.viewWithTag(3500) as! UILabel
        label.text = name
        label.sizeToFit()
    }
    fileprivate func configureValue(for cell: UITableViewCell, with value: Int) {
        let label = cell.viewWithTag(3550) as! UILabel
        label.text = String(value)
        label.sizeToFit()
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let section = sender.view!.tag
        var indexPaths = [IndexPath]()
        if section == 0 {
            indexPaths = (0..<66).map { i in return IndexPath(item: i, section: section)  }
        } else if section == 1 {
            indexPaths = (0..<1).map { i in return IndexPath(item: i, section: section)  }
        } else if section == 2 {
            indexPaths = (0..<1).map { i in return IndexPath(item: i, section: section)  }
        }
        hidden[section] = !hidden[section]
        
        tableView?.beginUpdates()
        if hidden[section] {
            tableView?.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView?.insertRows(at: indexPaths, with: .fade)
        }
        tableView?.endUpdates()
    }
}

