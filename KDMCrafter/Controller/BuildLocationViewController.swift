//
//  BuildLocationViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class BuildLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationTableViewCellDelegate, SpendResourcesVCDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let dataModel = DataModel.sharedInstance
    let validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
    
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
        
//        myInnovations!.append(ammonia)
//        myStorage![monsterHide] = 3
//        myStorage![blackLichen] = 2
//        myStorage![endeavor] = 3
//        myStorage![monsterOrgan] = 5
        //myStorage![bladder] = 4
//        myLocations![9].isBuilt = true
        //myLocations![10].isBuilt = true // probably index into this by indexPath.row in cellForRowAt:
        
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name })
        
        numResourceRows =  dataModel.currentSettlement!.resourceStorage.count
        numLocationRows = dataModel.currentSettlement!.allLocations.count
        numInnovationRows = 1

        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        validator.resources = mySettlement!.resourceStorage // Update validator here?
        myStorage = mySettlement!.resourceStorage
        tableView.reloadData()
    }

    func getInnovationExists(innovation: Innovation) -> Bool {
        if myInnovations!.contains(innovation) {
            return true
        } else {
            return false
        }
    }
    
    // TableViewDelegate stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numLocationRows!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
            cell.cellDelegate = self
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
            let location = myLocations![indexPath.row]
            let buildableStatus = validator.isBuildable(locations: myLocations!, location: location)
        
            var buildableStatusString = String()
            var missingResourcesString = String()
            let builtLocationNames = myLocations!.filter { $0.isBuilt }.map { $0.name }
            
            if location.name == "Lantern Hoard" {
                buildableStatusString = ""
            } else if buildableStatus == true {
                buildableStatusString = "Build"
            } else if location.isBuilt {
                buildableStatusString = "Destroy"
            } else {
                buildableStatusString = "Unbuildable"
            }
            if buildableStatus != true && !location.isBuilt {
                let dict = validator.getMissingLocationResourceRequirements(location: location)
                if dict == [:] {
                    missingResourcesString = "Missing: \(location.locationRequirement)"
                } else if !location.locationRequirement.contains("Special") && builtLocationNames.contains(location.locationRequirement) {
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
            
            //if !location.isBuilt {
            if !validator.isBuildable(locations: myLocations!, location: location) && !location.isBuilt {
                configureMissingResourceLabel(for: cell, with: missingResourcesString, with: 3700)
            } else if location.locationRequirement.contains("Special") {
                configureMissingResourceLabel(for: cell, with: missingResourcesString, with: 3700)
            } else {
                configureMissingResourceLabel(for: cell, with: "", with: 3700)
            }

        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UITableViewHeaderFooterView()
//        headerView.textLabel?.textAlignment = .left
//        headerView.tag = section
//
//        if section == 0 {
//            headerView.textLabel?.text = "Settlement Resource Storage"
//        } else if section == 1 {
//            headerView.textLabel?.text = "Settlement Locations"
//        } else if section == 2 {
//            headerView.textLabel?.text = "Settlement Innovations"
//        }
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapExpandSection))
//        headerView.isUserInteractionEnabled = true
//        headerView.addGestureRecognizer(tap)
//        return headerView
//
//    }
    // Helper functions
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
            button.backgroundColor = UIColor(red: 0, green: 0.8588, blue: 0.1412, alpha: 1.0)
        } else if status == "Unbuildable" {
            button.setTitle("Build", for: .normal)
            button.backgroundColor = UIColor.gray
        } else if status == "Destroy" {
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            //button.isHidden = true
        }
        //button.sizeToFit()
        
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
//    @objc func tapExpandSection(sender:UITapGestureRecognizer) {
//        let section = sender.view!.tag
//        var indexPaths = [IndexPath]()
//        if section == 0 {
//            indexPaths = (0..<66).map { i in return IndexPath(item: i, section: section)  }
//        } else if section == 1 {
//            indexPaths = (0..<13).map { i in return IndexPath(item: i, section: section)  }
//        } else if section == 2 {
//            indexPaths = (0..<1).map { i in return IndexPath(item: i, section: section)  }
//        }
//        hidden[section] = !hidden[section]
//
//        tableView?.beginUpdates()
//        if hidden[section] {
//            tableView?.deleteRows(at: indexPaths, with: .fade)
//        } else {
//            tableView?.insertRows(at: indexPaths, with: .fade)
//        }
//        tableView?.endUpdates()
//    }
    func tappedBuildButton(cell: LocationTableViewCell) {
        let location = myLocations![cell.tag]
        if location.locationRequirement.contains("Special") {
            myLocations![cell.tag].isBuilt = true
            //dataModel.currentSettlement!.allLocations[cell.tag].isBuilt = true
            mySettlement!.locationsBuiltDict[location] = true
        } else if validator.isBuildable(locations: myLocations!, location: location) {
            spendResources(for: location)
        } else if location.isBuilt {
            myLocations![cell.tag].isBuilt = false // Destroy instead
        }
        tableView.reloadData()
    }
    fileprivate func spendResources(for location: Location) {
        let requiredTypes = location.resourceRequirements.map { $0.key }
        let requiredResourceTypes = location.resourceRequirements
        var spendableResources = [Resource:Int]()
        validator.resources = mySettlement!.resourceStorage // Update validator here?

        let spendResourcesVC = self.storyboard?.instantiateViewController(withIdentifier: "spendResourcesVC") as! SpendResourcesViewController
        
        for resource in myStorage!.keys {
            if myStorage![resource]! > 0 {
                for type in resource.type {
                    if requiredTypes.contains(type) {
                        spendableResources[resource] = myStorage![resource]! //assign value
                        break
                    }
                }
            }
        }
        spendResourcesVC.spendableResources = spendableResources
        spendResourcesVC.requiredResourceTypes = requiredResourceTypes
        self.currentLocation = location
        spendResourcesVC.delegate = self
        
        self.present(spendResourcesVC, animated: true, completion: nil)

    }
    func updateStorage(with spentResources: [Resource : Int]) {
        for (resource, qty) in spentResources {
            mySettlement!.resourceStorage[resource]! -= qty
            myStorage![resource]! -= qty
        }
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name }) //Update here?
        validator.resources = mySettlement!.resourceStorage // Update validator here?
        self.myLocations![self.myLocations!.lastIndex(of: self.currentLocation!)!].isBuilt = true
        mySettlement!.locationsBuiltDict[currentLocation!] = true
        tableView.reloadData()
    }
}

