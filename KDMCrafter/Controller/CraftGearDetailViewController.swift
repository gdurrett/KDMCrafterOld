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

    @IBOutlet weak var affinityView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var affinityLeftLabel: UILabel!
    @IBOutlet weak var affinityTopLabel: UILabel!
    @IBOutlet weak var affinityRightLabel: UILabel!
    @IBOutlet weak var affinityBottomLabel: UILabel!
    @IBOutlet weak var affinityWholeLabel: UILabel!
    @IBOutlet weak var gearNameLabel: UILabel!
    @IBOutlet weak var gearTypeLabel: UILabel!
    @IBOutlet weak var gearStatsRightLabel: UILabel!
    @IBOutlet weak var gearStatsLeftLabel: UILabel!
    @IBOutlet weak var gearInfoTextView: UITextView!
    
    let dataModel = DataModel.sharedInstance
    var mySettlement: Settlement?
    let validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var gear: Gear!
    var missingResourcesArray: [Any]?
    var requiredResourcesArray: [Any]?
    var specialTypesStringArray: [String]?
    
    var affinityBlue = UIColor(red: 0, green: 0.749, blue: 0.9765, alpha: 1.0)
    var affinityRed = UIColor(red: 0.9686, green: 0.1922, blue: 0, alpha: 1.0)
    var affinityGreen = UIColor(red: 0.2824, green: 0.7765, blue: 0, alpha: 1.0)
    
    var myGearDict = [String:Int]()
    var reducedTypes = [String:[resourceType:Int]]()
    var flaggedTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GearRequirementTableViewCell.nib, forCellReuseIdentifier: GearRequirementTableViewCell.identifier)
        tableView.rowHeight = 30 //UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        self.navigationItem.title = "Craft Gear"
        
        gearInfoTextView.textContainerInset = UIEdgeInsets.zero
        gearInfoTextView.textContainer.lineFragmentPadding = 0
        gearNameLabel.text = ("\(gear.name)")
        gearTypeLabel.text = ("(\(gear.description.type.rawValue))")
        var leftStats: (String)
        var rightStats: (String)
        if gear!.description.type == .armor {
            rightStats = gear.description.stats.armorAttributes().0
            leftStats = gear.description.stats.armorAttributes().1
        } else if gear.description.type == .weapon {
            rightStats = gear.description.stats.weaponAttributes().1
            leftStats = gear.description.stats.weaponAttributes().0
        } else {
            rightStats = ""
            leftStats = ""
        }
        gearStatsRightLabel.text = rightStats
        gearStatsLeftLabel.text = leftStats
        
        gearInfoTextView.attributedText = gear!.description.detailText

        affinityLeftLabel.isHidden = true
        affinityTopLabel.isHidden = true
        affinityRightLabel.isHidden = true
        affinityBottomLabel.isHidden = true
        affinityWholeLabel.isHidden = true
        
        setAffinities(gear: gear)
        
        mySettlement = dataModel.currentSettlement!

        requiredResourcesArray = [gear!.locationRequirement!]
        let gearRequiredPairs = validator.getGearResourceRequirements(gear: gear!)
        if gear.resourceSpecialRequirements != nil {
            specialTypesStringArray = validator.getSpecialStrings(resourceTypes: gear.resourceSpecialRequirements!)
        }
        for gear in gearRequiredPairs {
            requiredResourcesArray?.append(gear)
        }
        if gear!.innovationRequirement != nil {
            requiredResourcesArray!.append(gear!.innovationRequirement!)
        }
        tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.mySettlement = dataModel.currentSettlement!
        //self.reducedTypes = [String:[resourceType:Int]]()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requiredResourcesArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GearRequirementTableViewCell", for: indexPath) as! GearRequirementTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        if let requiredResource = self.requiredResourcesArray![indexPath.row] as? [String:Int] {
            let qtyReq = requiredResource.map { $0.value }[0]
            let requestedTypeRawValue = requiredResource.map { $0.key }[0]!
            let specialReqAmt = gear.resourceSpecialRequirements
            
            for special in specialTypesStringArray! { // Initialize dictionary
                if requestedTypeRawValue == special {
                    reducedTypes[requestedTypeRawValue] = [:]
                }
            }
            var qtyAvail = validator.getTypeCount(type: resourceType(rawValue: requestedTypeRawValue)!, resources: mySettlement!.resourceStorage)
            if gear.overlappingResources.0 == true { // If this gear has overlapping resources
                for special in specialTypesStringArray! { // Loop through array of strings of Special resource names
                    if requestedTypeRawValue == special { // If this particular resource is a Special
                        for (type, qtyRequired ) in specialReqAmt! { // Break out type and qty required for this Special
                            if type.rawValue == requestedTypeRawValue {
                                for res in mySettlement!.resourceStorage {
                                    if res.key.name == requestedTypeRawValue {
                                        for type in res.key.type {
                                            if gear.overlappingResources.1.contains(type) {
                                                if qtyAvail > 0 && qtyAvail <= qtyRequired {
                                                    if reducedTypes[requestedTypeRawValue]?[type] == nil {
                                                        reducedTypes[requestedTypeRawValue]![type] = qtyAvail
                                                    }
                                                } else if qtyAvail > qtyRequired {
                                                    if reducedTypes[requestedTypeRawValue]![type] != nil {
                                                        reducedTypes[requestedTypeRawValue]![type]! += qtyRequired
                                                    } else {
                                                        reducedTypes[requestedTypeRawValue]![type] = qtyRequired
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if !specialTypesStringArray!.contains(requestedTypeRawValue) {
                    for resource in reducedTypes {
                        for pair in reducedTypes[resource.key]! {
                            if pair.key.rawValue == requestedTypeRawValue {
                                qtyAvail -= pair.value
                                flaggedTypes.append(pair.key.rawValue)
                            }
                        }
                    }
                }
            } // If this is a special resource and gear also requires a regular type provided by the special resource, reduce available count
            cell.requiredTypeLabel.text! = requiredResource.map { $0.key }[0]
            cell.requiredQtyLabel.text! = String(qtyReq)
            cell.qtyAvailableLabel.text! = String(qtyAvail)
            if flaggedTypes.contains(cell.requiredTypeLabel.text!) && qtyAvail <= qtyReq && qtyAvail > 0 {
                print("Flagging \(cell.requiredTypeLabel.text!)")
                cell.statusLabel.text! = "⚠️"
            } else if qtyReq > qtyAvail {
                cell.statusLabel.text! = "❌"
            } else {
                cell.statusLabel.text! = "✅"
            }
        } else if let requiredResource = self.requiredResourcesArray![indexPath.row] as? Location {
            cell.requiredTypeLabel.text! = "\(requiredResource.name)"
            cell.requiredQtyLabel.text! = "1"
            if mySettlement!.locationsBuiltDict[requiredResource] == true {
                cell.qtyAvailableLabel.text! = "1"
                cell.statusLabel.text! = "✅"
            } else {
                cell.qtyAvailableLabel.text! = "0"
                cell.statusLabel.text! = "❌"
            }
        } else if let requiredResource = self.requiredResourcesArray![indexPath.row] as? Innovation {
            cell.requiredQtyLabel.text! = "1"
            cell.requiredTypeLabel.text! = "\(requiredResource.name) Innovation"
            if validator.getInnovationExists(innovation: requiredResource) {
                cell.qtyAvailableLabel.text! = "0"
                cell.statusLabel.text! = "✅"
            } else {
                cell.qtyAvailableLabel.text! = "1"
                cell.statusLabel.text! = "❌"
            }
        }
        return cell
    }
    
    // Helper functions
    fileprivate func setAffinities(gear: Gear) {
        for affinity in gear.description.affinities {
            
            if affinity != .none {
                if affinity == .redLeft {
                    affinityLeftLabel.isHidden = false
                    affinityLeftLabel.backgroundColor = affinityRed
                } else if affinity == .redUp {
                    affinityTopLabel.isHidden = false
                    affinityTopLabel.backgroundColor = affinityRed
                } else if affinity == .redRight {
                    affinityRightLabel.isHidden = false
                    affinityRightLabel.backgroundColor = affinityRed
                } else if affinity == .redDown {
                    affinityBottomLabel.isHidden = false
                    affinityBottomLabel.backgroundColor = affinityRed
                }
                if affinity == .blueLeft {
                    affinityLeftLabel.isHidden = false
                    affinityLeftLabel.backgroundColor = affinityBlue
                } else if affinity == .blueUp {
                    affinityTopLabel.isHidden = false
                    affinityTopLabel.backgroundColor = affinityBlue
                } else if affinity == .blueRight {
                    affinityRightLabel.isHidden = false
                    affinityRightLabel.backgroundColor = affinityBlue
                } else if affinity == .blueDown {
                    affinityBottomLabel.isHidden = false
                    affinityBottomLabel.backgroundColor = affinityBlue
                }
                if affinity == .greenLeft {
                    affinityLeftLabel.isHidden = false
                    affinityLeftLabel.backgroundColor = affinityGreen
                } else if affinity == .greenUp {
                    affinityTopLabel.isHidden = false
                    affinityTopLabel.backgroundColor = affinityGreen
                } else if affinity == .greenRight {
                    affinityRightLabel.isHidden = false
                    affinityRightLabel.backgroundColor = affinityGreen
                } else if affinity == .greenDown {
                    affinityBottomLabel.isHidden = false
                    affinityBottomLabel.backgroundColor = affinityGreen
                }
                if affinity == .oneRed {
                    affinityWholeLabel.isHidden = false
                    affinityWholeLabel.backgroundColor = affinityRed
                } else if affinity == .oneBlue {
                    affinityWholeLabel.isHidden = false
                    affinityWholeLabel.backgroundColor = affinityBlue
                } else if affinity == .oneGreen {
                    affinityWholeLabel.isHidden = false
                    affinityWholeLabel.backgroundColor = affinityGreen
                }
            } else {
                
                affinityView.backgroundColor = UIColor.clear
                let label = UILabel(frame: CGRect(x: 289, y: 47, width: 80, height: 21))
                label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12)
                label.text = "No Affinities"
                self.mainView.addSubview(label)
            }
        }
    }
}
