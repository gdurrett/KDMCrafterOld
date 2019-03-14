//
//  CraftGearDetailViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/7/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class CraftGearDetailViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var gearNameLabel: UILabel!
    @IBOutlet weak var gearTypeLeftLabel: UILabel!
    @IBOutlet weak var gearStatsLeftLabel: UILabel!
    @IBOutlet weak var gearStatsLabel: UILabel!
    @IBOutlet weak var gearTypeLabel: UILabel!
    @IBOutlet weak var gearInfoTextView: UITextView!
    
    let dataModel = DataModel.sharedInstance
    var mySettlement: Settlement?
    let validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var gear: Gear?
    var missingResourcesArray: [Any]?
    var requiredResourcesArray: [Any]?
    
    var myGearDict = [String:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GearRequirementTableViewCell.nib, forCellReuseIdentifier: GearRequirementTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        self.navigationItem.title = "Craft Gear"
        gearNameLabel.text = gear!.name
        
        gearInfoTextView.textContainerInset = UIEdgeInsets.zero
        gearInfoTextView.textContainer.lineFragmentPadding = 0
        gearStatsLeftLabel.text = "Stats\n\n"
        gearTypeLeftLabel.text = "Type"
        var stats: (String)
        gearTypeLabel.text = ("\(gear!.description.type.rawValue)")
        if gear!.description.type == .armor {
            stats = gear!.description.stats.armorAttributes()
        } else if gear!.description.type == .weapon {
            stats = gear!.description.stats.weaponAttributes()
        } else {
            stats = "N/A\n\n"
        }
        gearStatsLabel.text = stats
        gearInfoTextView.attributedText = gear!.description.detailText

        mySettlement = dataModel.currentSettlement!

        requiredResourcesArray = [gear!.locationRequirement!]
        let gearRequiredPairs = validator.getGearResourceRequirements(gear: gear!)
        for gear in gearRequiredPairs {
            requiredResourcesArray?.append(gear)
        }
        
        if gear!.innovationRequirement != nil {
            requiredResourcesArray!.append(gear!.innovationRequirement!)
        }
        tableView.tableFooterView = UIView()

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requiredResourcesArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GearRequirementTableViewCell", for: indexPath) as! GearRequirementTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let obj = self.requiredResourcesArray![indexPath.row] as? [String:Int] {
            cell.requiredTypeLabel.text! = obj.map { $0.key }[0]
            cell.requiredQtyLabel.text! = String(obj.map { $0.value }[0])
            cell.qtyAvailableLabel.text! = String(validator.getTypeCount(type: resourceType(rawValue: obj.map { $0.key }[0])!, resources: mySettlement!.resourceStorage))
        } else if let obj = self.requiredResourcesArray![indexPath.row] as? Location {
            cell.requiredTypeLabel.text! = obj.name
            cell.requiredQtyLabel.text! = ""
            if mySettlement!.locationsBuiltDict[obj] == true {
                cell.qtyAvailableLabel.text! = "✅"
            } else {
                cell.qtyAvailableLabel.text! = "UnBuilt"
            }
        } else if let obj = self.requiredResourcesArray![indexPath.row] as? Innovation {
            cell.requiredTypeLabel.text! = obj.name
        }

        
        return cell
    }
    

}
