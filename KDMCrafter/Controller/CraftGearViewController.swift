//
//  CraftGearViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/27/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class CraftGearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GearTableViewCellDelegate, SpendResourcesVCDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    let dataModel = DataModel.sharedInstance
    var validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedGear: [Gear]?
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
    var numGearRows: Int?

    var expandedRows = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.register(GearTableViewCell.nib, forCellReuseIdentifier: GearTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        
        mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement!.resourceStorage
        numGearRows = dataModel.currentSettlement!.availableGear.count
        myAvailableGear = mySettlement!.availableGear
        sortedGear = myAvailableGear!.sorted(by: { $0.name < $1.name })
        
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        mySettlement = dataModel.currentSettlement!
        myAvailableGear = mySettlement!.availableGear
        myStorage = mySettlement!.resourceStorage
        validator.resources = mySettlement!.resourceStorage
        validator.settlement.builtLocations = mySettlement!.builtLocations
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return numGearRows!
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GearTableViewCell", for: indexPath) as! GearTableViewCell
        cell.cellDelegate = self
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        
        let gear = self.sortedGear![indexPath.row]
        let craftableStatus = validator.checkCraftability(gear: gear) > 0 ? true:false
        var craftableStatusString = String()
        var missingResourcesString = String()
        
        if craftableStatus == true {
            craftableStatusString = "Craft"
            configureMissingResourceLabel(for: cell, with: "", with: 3850)
        } else {
            let dict = validator.getMissingGearResourceRequirements(gear: gear)
            let locationBuiltStatus = mySettlement!.locationsBuiltDict[gear.locationRequirement!]
            if locationBuiltStatus == false && !dict.isEmpty {
                missingResourcesString = "Missing: \(gear.locationRequirement!.name), \(dict)"
            } else if locationBuiltStatus == true {
                missingResourcesString = "Missing: \(dict)"
            } else {
                missingResourcesString = "Missing: \(gear.locationRequirement!.name)"
            }
            craftableStatusString = "Uncraftable"
            configureMissingResourceLabel(for: cell, with: missingResourcesString, with: 3850)
        }
        
        configureTitle(for: cell, with: gear.name, with: 3750)
        configureCraftLabel(for: cell, with: craftableStatusString, with: 3800)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GearTableViewCell else { return }
        
        switch cell.isExpanded {
        case true:
            self.expandedRows.remove(indexPath.row)
        case false:
            self.expandedRows.insert(indexPath.row)
        }

        cell.isExpanded = !cell.isExpanded
        
//        self.tableView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GearTableViewCell else { return }
        self.expandedRows.remove(indexPath.row)
        cell.isExpanded = false
//        self.tableView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        label.sizeToFit()
    }
    fileprivate func configureCraftLabel(for cell: UITableViewCell, with status: String, with tag: Int) {
        //let button = cell.subviews.viewWithTag(tag) as! UIButton
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
        //button.sizeToFit()
        
    }
    fileprivate func configureMissingResourceLabel(for cell: UITableViewCell, with missing: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UITextView
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
    func tappedCraftButton(cell: GearTableViewCell) {
        //
    }
    
    func updateStorage(with spentResources: [Resource : Int]) {
        //
    }

}
