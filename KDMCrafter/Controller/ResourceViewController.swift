//
//  FirstViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class ResourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
//    var myBuiltLocations: [Location]?
//    var myAvailableLocations: Set<Location>?
    
    var resourceName: String?
    var resourceValue: Int?
    var currentResource: Resource?
    
    var missingLocation: String?
    var missingResource: [resourceType:Int]?
    var currentLocation: Location?
    
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
        //myBuiltLocations = mySettlement!.builtLocations
        myLocations = mySettlement!.allLocations
        
        myInnovations!.append(ammonia)
//        myStorage![monsterHide] = 1
//        myStorage![monsterOrgan] = 1
//        myStorage![endeavor] = 3
//        myStorage![lionClaw] = 1
//        myLocations![2].isBuilt = true
//        myLocations![10].isBuilt = true // probably index into this by indexPath.row in cellForRowAt:
        
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name })
        
        numResourceRows =  dataModel.currentSettlement!.resourceStorage.count
        numLocationRows = dataModel.currentSettlement!.allLocations.count
        numInnovationRows = 1


        
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
    func getMissingLocationResourceRequirements(location: Location) -> [String:Int] {
        var myDict = [String:Int]()
        let resourceRequirements = location.resourceRequirements
        if resourceRequirements.count != 0 {
            for (type, qty) in resourceRequirements {
                let typeCount = getTypeCount(type: type, resources: myStorage!)
                if typeCount < qty {
                    myDict[type.rawValue] = (qty - typeCount)
                    print("adding \(myDict)")
                }
            }
        }
        return myDict
    }
    func isBuildable(location: Location) -> Bool {
        let resourceRequirements = location.resourceRequirements
        var resourceRequirementsMet = Bool()
        if location.isBuilt { return false }
        if resourceRequirements.count != 0 {
            for (type, qty) in resourceRequirements {
                let typeCount = getTypeCount(type: type, resources: myStorage!)
                if typeCount < qty {
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
            //let locationNames = myBuiltLocations!.map { $0.name }
            let locationNames = myLocations!.filter { $0.isBuilt }.map { $0.name }
            if locationNames.contains(location.locationRequirement) && resourceRequirementsMet {
                return true
            } else {
                if !resourceRequirementsMet {
                    
                    print("We cannot build \(location.name) due to lack of resources.")
                } else if !locationNames.contains (location.locationRequirement) {
                    missingLocation = location.locationRequirement
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
        //let locationExists = getLocationExists(location: gear.locationRequirement)
        let locationExists = gear.locationRequirement.isBuilt
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
        var tableViewCell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
            //let cell = makeCell(for: tableView)
            cell.backgroundColor = UIColor.clear
            
            //        let key = Array(self.myStorage!.keys)[indexPath.row]
            //        let value = Array(self.myStorage!.values)[indexPath.row]
            let key = sortedStorage![indexPath.row].0
            let value = sortedStorage![indexPath.row].1
            
            resourceName = key.name
            resourceValue = value
            
            configureTitle(for: cell, with: resourceName!, with: 3500)
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
            tableViewCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
            cell.cellDelegate = self
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            let location = myLocations![indexPath.row]
            let buildableStatus = isBuildable(location: location)
            var buildableStatusString = String()
            var missingResourcesString = String()
            
            if location.name == "Lantern Hoard" {
                buildableStatusString = ""
            } else if buildableStatus == true {
                buildableStatusString = "Build"
            } else if location.isBuilt {
                buildableStatusString = "UnBuild"
            } else {
                buildableStatusString = "Unbuildable"
            }
            if buildableStatus != true && !location.isBuilt {
                let dict = getMissingLocationResourceRequirements(location: location)
                if dict == [:] {
                    missingResourcesString = "Missing: \(location.locationRequirement)"
                } else if missingLocation == nil {
                    missingResourcesString = "Missing: \(dict)"
                } else {
                    missingResourcesString = "Missing: \(location.locationRequirement), \(dict)"
                }
            } else {
                //missingResourcesString = location.locationRequirement.replacingOccurrences(of: "Special: ", with: "")
                missingResourcesString = location.locationRequirement
            }
            cell.backgroundColor = UIColor.clear

            
            configureTitle(for: cell, with: myLocations![indexPath.row].name, with: 3600)
            configureBuildLabel(for: cell, with: buildableStatusString, with: indexPath.row, for: location)
            configureMissingResourceLabel(for: cell, with: missingResourcesString, with: 3700)
            
            tableViewCell = cell
        default:
            tableViewCell = UITableViewCell()
        }

        return tableViewCell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            (cell as! ResourceTableViewCell).observation = nil
        case 1:
            break
            //(cell as! LocationTableViewCell).observation = nil
        default: break
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapExpandSection))
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
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        label.sizeToFit()
    }
    fileprivate func configureValue(for cell: UITableViewCell, with value: Int) {
        let label = cell.viewWithTag(3550) as! UILabel
        label.text = String(value)
        label.sizeToFit()
    }
    fileprivate func configureBuildLabel(for cell: UITableViewCell, with status: String, with tag: Int, for location: Location) {
        //let button = cell.subviews.viewWithTag(tag) as! UIButton
        let cell = cell as! LocationTableViewCell
        let button = cell.buildButton!
        
        button.setTitle(status, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == "Build" {
            button.backgroundColor = UIColor.green
        } else if status == "Unbuildable" {
            button.backgroundColor = UIColor.gray
        } else {
            button.backgroundColor = UIColor.red
        }
        button.sizeToFit()
        
    }
    fileprivate func configureMissingResourceLabel(for cell: UITableViewCell, with missing: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = missing.replacingOccurrences(of: "[\\[\\]\"]", with: "", options: .regularExpression, range: nil)
        if label.text!.contains("Missing") && label.text != "Lantern Hoard" {
            label.textColor = UIColor.red
        } else {
            label.textColor = UIColor.black
        }
        if label.text!.contains("Special") {
            label.text = missing.replacingOccurrences(of: "Special: ", with: "")
            label.textColor = UIColor.gray
        }
        label.backgroundColor = UIColor.clear
    }
    @objc func tapExpandSection(sender:UITapGestureRecognizer) {
        let section = sender.view!.tag
        var indexPaths = [IndexPath]()
        if section == 0 {
            indexPaths = (0..<66).map { i in return IndexPath(item: i, section: section)  }
        } else if section == 1 {
            indexPaths = (0..<13).map { i in return IndexPath(item: i, section: section)  }
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
    func tappedBuildButton(cell: LocationTableViewCell) {
        let location = myLocations![cell.tag]
        if isBuildable(location: location) {
            print("I can build \(location.name)")
            myLocations![cell.tag].isBuilt = true
        } else if location.isBuilt {
            print("UnBuilding \(location.name)")
            myLocations![cell.tag].isBuilt = false
        }
        tableView.reloadData()
    }
    
}

