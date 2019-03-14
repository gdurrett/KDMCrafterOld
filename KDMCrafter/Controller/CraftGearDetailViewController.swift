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
    
    var affinityBlue = UIColor(red: 0, green: 0.749, blue: 0.9765, alpha: 1.0)
    var affinityRed = UIColor(red: 0.9686, green: 0.1922, blue: 0, alpha: 1.0)
    var affinityGreen = UIColor(red: 0.2824, green: 0.7765, blue: 0, alpha: 1.0)
    
    var myGearDict = [String:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GearRequirementTableViewCell.nib, forCellReuseIdentifier: GearRequirementTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
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
            }
        }
    }
}
