//
//  CraftGearViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/27/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class CraftGearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GearTableViewCellDelegate, SpendResourcesVCDelegate {
    
    @IBAction func overrideToggleAction(_ sender: Any) {
        if self.overrideToggleOutlet.isOn {
            mySettlement!.overrideEnabled = true
            self.filterCraftableOutlet.setOn(false, animated: true)
        } else {
            mySettlement!.overrideEnabled = false
        }
        tableView.reloadData()
    }
    
    @IBAction func filterCraftableAction(_ sender: Any) {
        self.sortedCraftableGear = getCraftableGear()
        if self.filterCraftableOutlet.isOn {
            self.overrideToggleOutlet.setOn(false, animated: true)
        }
        if self.getCraftableGear().count == 0 {
            self.filterCraftableOutlet.setOn(false, animated: true)
        }

        tableView.reloadData()
    }
    
    @IBOutlet weak var filterCraftableOutlet: UISwitch!
    @IBOutlet weak var overrideToggleOutlet: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    let dataModel = DataModel.sharedInstance
    let gearDetailSegueIdentifier = "ShowCraftGearDetailView"
    
    var validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var sortedGear: [Gear]?
    var sortedCraftableGear: [Gear]?
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
    var numGearRows: Int?
    var currentGear: Gear?
    
    var craftability = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.register(GearTableViewCell.nib, forCellReuseIdentifier: GearTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement!.resourceStorage
        numGearRows = dataModel.currentSettlement!.availableGear.count
        myAvailableGear = mySettlement!.availableGear
        
        sortedGear = myAvailableGear!.sorted(by: { $0.name < $1.name })
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name })

        self.overrideToggleOutlet.isOn = false
        self.filterCraftableOutlet.isOn = false
        
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        mySettlement = dataModel.currentSettlement!
        myAvailableGear = mySettlement!.availableGear
        sortedCraftableGear = getCraftableGear()
        myStorage = mySettlement!.resourceStorage
        validator.resources = mySettlement!.resourceStorage
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filterCraftableOutlet.isOn && self.sortedCraftableGear!.count != 0 {
            return self.sortedCraftableGear!.count
        } else {
            return (self.sortedGear?.count)!
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GearTableViewCell", for: indexPath) as! GearTableViewCell
        cell.cellDelegate = self
//        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.layoutMargins = UIEdgeInsets.zero
        cell.accessoryType = .disclosureIndicator

        var gear: Gear
        
        if self.filterCraftableOutlet.isOn && self.sortedCraftableGear!.count != 0 {
            gear = self.sortedCraftableGear![indexPath.row]
        } else {
            gear = self.sortedGear![indexPath.row]
        }
        
        var craftableStatus = Bool()
        
        if mySettlement!.overrideEnabled {
            if mySettlement!.gearCraftedDict[gear] == gear.qtyAvailable {
                craftableStatus = false
            } else {
                craftableStatus = true
            }
        } else {
            craftableStatus = validator.checkCraftability(gear: gear) > 0 ? true:false
        }
        var craftableStatusString = String()
        var missingResourcesString = String()
        var archiveStatusString = String()
        
//        configureGearInfoLabel(for: cell, with: gear.description, with: 3900)
        
        if craftableStatus == true {
            craftableStatusString = "Craft"
//            configureMissingResourceLabel(for: cell, with: "", with: 3850)
        } else {
//            missingResourcesString = configureMissingResourcesString(for: cell, for: gear)
            craftableStatusString = "Uncraftable"
//            configureMissingResourceLabel(for: cell, with: missingResourcesString, with: 3850)
        }
        
        if mySettlement!.gearCraftedDict[gear]! > 0 {
            archiveStatusString = "Archivable"
        } else {
            archiveStatusString = "Unarchivable"
        }
        
        configureTitle(for: cell, with: gear.name, with: 3750)
//        configureCraftLabel(for: cell, with: craftableStatusString, with: 3800)
//        configureArchiveLabel(for: cell, with: archiveStatusString, with: 3950)
        configureNumCraftableLabel(for: cell, with: gear, for: 3975)
        configureQtyAvailableLabel(for: cell, with: gear, with: 4000)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " Craft Gear"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GearTableViewCell", for: indexPath) as! GearTableViewCell
        if let craftDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CraftGearDetailViewController") as? CraftGearDetailViewController {
            let gearIndex = tableView.indexPathForSelectedRow?.row
            if self.filterCraftableOutlet.isOn && self.sortedCraftableGear!.count != 0 {
                craftDetailVC.gear = self.sortedCraftableGear![gearIndex!]
            } else {
                craftDetailVC.gear = self.sortedGear![gearIndex!]

            }
            craftDetailVC.craftability = self.validator.checkCraftability(gear: craftDetailVC.gear) > 0 ? true:false
            self.navigationController?.pushViewController(craftDetailVC, animated: true)
        }
    }
    // Segue

    // Helper methods
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        label.sizeToFit()
    }
    fileprivate func configureCraftLabel(for cell: UITableViewCell, with status: String, with tag: Int) {
        let cell = cell as! GearTableViewCell
        let button = cell.craftButton!
        
        button.setTitle(status, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == "Craft" {
            button.backgroundColor = UIColor(red: 0, green: 0.8588, blue: 0.1412, alpha: 1.0)
        } else if status == "Uncraftable" {
            button.setTitle("Craft", for: .normal)
            button.backgroundColor = UIColor.gray
        } else if status == "Destroy" {
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            //button.isHidden = true
        }
    }
    fileprivate func configureArchiveLabel(for cell: UITableViewCell, with status: String, with tag: Int) {
        let cell = cell as! GearTableViewCell
        let button = cell.archiveButton!
        
        button.setTitle("Archive", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == "Archivable" {
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            button.backgroundColor = UIColor.gray
        }
    }
    fileprivate func configureQtyAvailableLabel(for cell: UITableViewCell, with gear: Gear, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        let labelString = "\(mySettlement!.gearCraftedDict[gear]!) crafted of \(gear.qtyAvailable) available"
        label.text! = labelString
        label.textColor = UIColor.gray
    }
    fileprivate func configureNumCraftableLabel(for cell: UITableViewCell, with gear: Gear, for tag: Int) {
        let numCraftable = self.validator.checkCraftability(gear: gear) > gear.qtyAvailable ? gear.qtyAvailable:self.validator.checkCraftability(gear: gear) // If numCraftable greater than qty available, use qtyAvailable
        let label = cell.viewWithTag(tag) as! UILabel
        var labelString = String()
        //let labelString = "\(numCraftable) craftable"
        if numCraftable > 0 {
            labelString = "Craftable"
            self.craftability = true
        } else {
            labelString = "Uncraftable"
            self.craftability = false
        }
        label.text = labelString
        if numCraftable == 0 {
            label.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            label.textColor = UIColor(red: 0.3843, green: 0.8275, blue: 0, alpha: 1.0)
        }
    }
    fileprivate func configureGearInfoLabel(for cell: UITableViewCell, with info: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UITextView
        label.text = info
        
    }
    fileprivate func configureMissingResourcesString(for cell: UITableViewCell, for gear: Gear) -> [Any] {
        var missingResourcesString = String()
        var missingResourcesArray = [Any]()
        var requiredResourceTypes = [String:Int]()
        
        if mySettlement!.gearCraftedDict[gear] == gear.qtyAvailable {
            missingResourcesString = "Max number crafted."
        } else {
            let resourceRequirements = validator.getMissingGearResourceRequirements(gear: gear)
            let locationBuiltStatus = mySettlement!.locationsBuiltDict[gear.locationRequirement!]
            var innovationRequirement = ""
            if gear.innovationRequirement != nil && mySettlement!.innovationsAddedDict[gear.innovationRequirement!] != true {
                innovationRequirement = validator.getMissingInnovationRequirement(gear: gear)
            }
            if locationBuiltStatus == false && !resourceRequirements.isEmpty && innovationRequirement != "" {
                missingResourcesString = "Missing: \(gear.locationRequirement!.name), \(resourceRequirements), \(innovationRequirement)"
                missingResourcesArray += [gear.locationRequirement!, resourceRequirements, innovationRequirement]
            } else if locationBuiltStatus == false && !resourceRequirements.isEmpty && innovationRequirement == "" {
                missingResourcesString = "Missing: \(gear.locationRequirement!.name), \(resourceRequirements)"
                missingResourcesArray += [gear.locationRequirement!, resourceRequirements]
            } else if locationBuiltStatus == false && resourceRequirements.isEmpty && innovationRequirement != "" {
                missingResourcesString = "Missing: \(gear.locationRequirement!.name), \(innovationRequirement)"
                missingResourcesArray += [gear.locationRequirement!, requiredResourceTypes, innovationRequirement]
            } else if locationBuiltStatus == true && !resourceRequirements.isEmpty && innovationRequirement != "" {
                missingResourcesString = "Missing: \(resourceRequirements), \(innovationRequirement)"
                missingResourcesArray += [resourceRequirements, gear.locationRequirement!, innovationRequirement]
            } else if locationBuiltStatus == true && resourceRequirements.isEmpty && innovationRequirement != "" {
                missingResourcesString = "Missing: \(innovationRequirement)"
                missingResourcesArray += [gear.locationRequirement!, requiredResourceTypes, innovationRequirement]
            } else if locationBuiltStatus == true && !resourceRequirements.isEmpty && innovationRequirement == "" {
                missingResourcesString = "Missing: \(resourceRequirements)"
                missingResourcesArray += [gear.locationRequirement!, resourceRequirements]
            } else {
                missingResourcesString = "Missing: \(gear.locationRequirement!.name)"
                missingResourcesArray += [gear.locationRequirement!, requiredResourceTypes]
            }
        }
        
        return missingResourcesArray
    }
    fileprivate func configureMissingResourceLabel(for cell: UITableViewCell, with missing: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UITextView
        label.text = missing.replacingOccurrences(of: "[\\[\\]\"]", with: "", options: .regularExpression, range: nil)
        if (label.text!.contains("Missing") || label.text!.contains("Max")) && label.text != "Lantern Hoard" {
            label.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            label.textColor = UIColor.black
        }
        if label.text!.contains("Special") {
            label.text = missing.replacingOccurrences(of: "Special: ", with: "")
            label.textColor = UIColor.gray
        }
        label.backgroundColor = UIColor.clear
    }
    fileprivate func getCraftableGear() -> [Gear] {
        self.sortedCraftableGear = []
        for gear in mySettlement!.availableGear {
            if validator.checkCraftability(gear: gear) > 0 {
                self.sortedCraftableGear!.append(gear)
            }
        }
        return self.sortedCraftableGear!.sorted(by: { $0.name < $1.name })
    }
    func tappedCraftButton(cell: GearTableViewCell) {
        var gear: Gear?
        if self.filterCraftableOutlet.isOn && self.sortedCraftableGear!.count > 0 {
            gear = self.sortedCraftableGear![cell.tag]
        } else {
            gear = self.sortedGear![cell.tag]
        }
        if self.mySettlement!.overrideEnabled && mySettlement!.gearCraftedDict[gear!]! < gear!.qtyAvailable {
            mySettlement!.gearCraftedDict[gear!]! += 1
        } else if validator.checkCraftability(gear: gear!) > 0 && mySettlement!.gearCraftedDict[gear!]! < gear!.qtyAvailable {
            spendResources(for: gear!)
        } else {
            // Can't craft!
        }
        tableView.reloadData()
    }
    func tappedArchiveButton(cell: GearTableViewCell) {
        var gear: Gear?
        if self.filterCraftableOutlet.isOn && self.sortedCraftableGear!.count > 0 {
            gear = self.sortedCraftableGear![cell.tag]
        } else {
            gear = self.sortedGear![cell.tag]
        }
        if self.mySettlement!.gearCraftedDict[gear!]! > 0 {
            mySettlement!.gearCraftedDict[gear!]! -= 1
        }
        tableView.reloadData()
    }
    fileprivate func spendResources(for gear: Gear) {
        var requiredTypes = [resourceType]()
        var requiredResourceTypes = [resourceType:Int]()
        if gear.resourceSpecialRequirements == nil {
            requiredTypes = gear.resourceTypeRequirements!.keys.map { $0 }
            requiredResourceTypes = gear.resourceTypeRequirements!
        } else {
            requiredTypes = gear.resourceTypeRequirements!.keys.map { $0 } + gear.resourceSpecialRequirements!.keys
            requiredResourceTypes = gear.resourceTypeRequirements!.merging(gear.resourceSpecialRequirements!) { (current, _) in current } // Also combined dict
        }

        var spendableResources = [Resource:Int]()
        validator.resources = mySettlement!.resourceStorage // Update validator
        
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
        self.currentGear = gear
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
        mySettlement!.gearCraftedDict[self.currentGear!]! += 1
        tableView.reloadData()
    }

}
