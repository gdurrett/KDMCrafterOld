//
//  CraftGearDetailViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/7/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class CraftGearDetailViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, SpendResourcesVCDelegate {
    
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
    
    @IBOutlet weak var numAvailableLabel: UILabel!
    
    @IBAction func craftGearButtonAction(_ sender: Any) {
        tappedCraftButton()
    }
    @IBOutlet weak var craftGearButtonOutlet: UIButton!
    
    @IBAction func archiveGearButtonAction(_ sender: Any) {
        tappedArchiveButton()
    }
    @IBOutlet weak var archiveGearButtonOutlet: UIButton!
    
    let dataModel = DataModel.sharedInstance
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    let validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var gear: Gear!
    var craftability: Bool?
    
    //var missingResourcesArray: [Any]?
    var requiredResourcesArray: [Any]?
    var specialTypesStringArray: [String]?
    var requestedTypeRawValue = String()
    
    var affinityBlue = UIColor(red: 0, green: 0.749, blue: 0.9765, alpha: 1.0)
    var affinityRed = UIColor(red: 0.9686, green: 0.1922, blue: 0, alpha: 1.0)
    var affinityGreen = UIColor(red: 0.2824, green: 0.7765, blue: 0, alpha: 1.0)
    
    var myGearDict = [String:Int]()
    var reducedTypes = [String:[resourceType:Int]]()
    var flaggedTypes = [String:Int]() // For flagging basic types with yellow exclamation
    var specialMet = ["Temp":false] // Test if special requirements have been met for flagging purposes
    var currentSpecial = ""
    var skullDict = [String:Bool]()
    var currentCell = GearRequirementTableViewCell()
    var craftStatusDict = [String:Bool]()
    
    var result: ([Resource:Int], [resourceType:Int], Bool)?
    
//    if #available(iOS 13.0, *) {
//        let cellStatusImageChecked = UIImage(systemName: "checkmark.seal")
//    } else {
//        let cellStatusImageChecked = #imageLiteral(resourceName: "icons8-tick-box-50")
//    }
//    let cellStatusImageChecked = UIImage(systemName: "checkmark.square.fill")
    let cellStatusImageChecked = #imageLiteral(resourceName: "icons8-tick-box-100-dark")
    let cellStatusImageUnchecked = #imageLiteral(resourceName: "icons8-unchecked-checkbox-100")
    let cellStatusImageIndeterminate = #imageLiteral(resourceName: "icons8-indeterminate-checkbox-100")
    let cellStatusImageOverride = #imageLiteral(resourceName: "icons8-settings-filled-50")
    
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
            rightStats = gear.description.statsRight
            leftStats = gear.description.statsLeft
        } else if gear.description.type == .weapon {
            rightStats = gear.description.statsRight
            leftStats = gear.description.statsLeft
        } else {
            rightStats = ""
            leftStats = ""
        }
        gearStatsRightLabel.text = rightStats
        gearStatsLeftLabel.text = leftStats
        
        gearInfoTextView.attributedText = gear!.description.detailText.attributedString

        affinityLeftLabel.isHidden = true
        affinityTopLabel.isHidden = true
        affinityRightLabel.isHidden = true
        affinityBottomLabel.isHidden = true
        affinityWholeLabel.isHidden = true
        
        setAffinities(gear: gear)
        
        mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement!.resourceStorage

        requiredResourcesArray = [gear!.locationRequirement!]
        let gearRequiredPairs = validator.getGearResourceRequirements(gear: gear!)
        if gear.resourceSpecialRequirements != nil {
            specialTypesStringArray = validator.getSpecialStrings(resources: gear.resourceSpecialRequirements!)
        }
        for gear in gearRequiredPairs {
            requiredResourcesArray?.append(gear)
        }
        if gear!.innovationRequirement != nil {
            requiredResourcesArray!.append(gear!.innovationRequirement!)
        }
        
        result = validator.checkCraftability2(gear: gear)
        configureCraftButton()
        configureArchiveButton()
        configureNumAvailableLabel()
        
        navigationItem.title = "Craft Gear"
        configureTopLine() //Not showing!
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myStorage = mySettlement!.resourceStorage
        tableView.reloadData()
        configureCraftButton()
        configureArchiveButton()
        result = validator.checkCraftability2(gear: gear)
        configureNumAvailableLabel()
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requiredResourcesArray!.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentCell.isHidden {
            return 0.0
        } else {
            return 30
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GearRequirementTableViewCell", for: indexPath) as! GearRequirementTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let requiredResource = self.requiredResourcesArray![indexPath.row] as? [String:Int] {
            currentCell = cell
            cell.isHidden = false
            cell.requiredTypeLabel.text! = ("\(requiredResource.map { $0.key })").replacingOccurrences(of: "[\\[\\]\"]", with: "", options: .regularExpression, range: nil)
            cell.requiredQtyLabel.text! = ("\(requiredResource.map { $0.value })").replacingOccurrences(of: "[\\[\\]\"]", with: "", options: .regularExpression, range: nil)
            let requiredResourceQty = requiredResource.map { $0.value }[0]
            if gear.resourceSpecialRequirements != nil {
                let requestedResourceName = requiredResource.map { $0.key }[0]
                for resource in gear.resourceSpecialRequirements! { // Loop through required Special resources
                    if resource.key.name == requestedResourceName { // If we find a match in our requiredResources array
                        var excessQty = Int()
                        var qty = mySettlement!.resourceStorage[resource.key] == nil ? 0:mySettlement!.resourceStorage[resource.key]
                        if validator.getAllTypesDict()[resource.key.type[0]] != nil {
                            if gear.name != "Skull Helm" { // Exception for Skull Helm unique resource requirements
                                excessQty = validator.getAllTypesDict()[resource.key.type[0]]! - qty!
                            }
                        }
                        if excessQty != 0 { qty! += excessQty } //
                        cell.qtyAvailableLabel.text! = "\(qty!)"
                        if mySettlement!.overrideEnabled {
                            cell.statusImage.image = cellStatusImageOverride
                        } else {
                            if qty! >= requiredResourceQty {
                                cell.statusImage.image = cellStatusImageChecked
                            } else {
                                cell.statusImage.image = cellStatusImageUnchecked
                            }
                        }
                        break
                    }
                }
            }
            
            if gear.resourceTypeRequirements != [:] {
                let requestedResourceName = requiredResource.map { $0.key }[0]
                for (type, _) in gear.resourceTypeRequirements! {
                    if type.rawValue == requestedResourceName {
                        if result!.1 == [:] {
                            cell.qtyAvailableLabel.text! = "0"
                            if mySettlement!.overrideEnabled {
                                cell.statusImage.image = cellStatusImageOverride
                            } else {
                                cell.statusImage.image = cellStatusImageUnchecked
                            }
                        } else if !result!.1.keys.contains(type) { // If we have something in availableBasics, but not the type we need
                            cell.qtyAvailableLabel.text! = "0"
                            if mySettlement!.overrideEnabled {
                                cell.statusImage.image = cellStatusImageOverride
                            } else {
                                cell.statusImage.image = cellStatusImageUnchecked
                            }
                        } else {
                            for (availType, qty) in result!.1 {
                                if type == availType {
                                    cell.qtyAvailableLabel.text! = "\(qty)"
                                    if mySettlement!.overrideEnabled {
                                        cell.statusImage.image = cellStatusImageOverride
                                    } else {
                                        if qty >= requiredResourceQty {
                                            cell.statusImage.image = cellStatusImageChecked
                                        } else {
                                            cell.statusImage.image = cellStatusImageUnchecked
                                        }
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            }
        } else if let requiredResource = self.requiredResourcesArray![indexPath.row] as? Location {
            currentCell = cell
            cell.isHidden = false
            cell.requiredTypeLabel.text! = "\(requiredResource.name)"
            cell.requiredQtyLabel.text! = "1"
            if mySettlement!.locationsBuiltDict[requiredResource] == true {
                cell.qtyAvailableLabel.text! = "1"
                if mySettlement!.overrideEnabled {
                    cell.statusImage.image = cellStatusImageOverride
                } else {
                    cell.statusImage.image = cellStatusImageChecked
                }
                craftStatusDict[requiredResource.name] = true
            } else {
                cell.qtyAvailableLabel.text! = "0"
                if mySettlement!.overrideEnabled {
                    cell.statusImage.image = cellStatusImageOverride
                } else {
                    cell.statusImage.image = cellStatusImageUnchecked
                }
            }
        } else if let requiredResource = self.requiredResourcesArray![indexPath.row] as? Innovation {
            currentCell = cell
            cell.isHidden = false
            cell.requiredQtyLabel.text! = "1"
            cell.requiredTypeLabel.text! = "\(requiredResource.name) Innovation"
            if validator.getInnovationExists(innovation: requiredResource) {
                cell.qtyAvailableLabel.text! = "1"
                if mySettlement!.overrideEnabled {
                    cell.statusImage.image = cellStatusImageOverride
                } else {
                    cell.statusImage.image = cellStatusImageChecked
                }
            } else {
                cell.qtyAvailableLabel.text! = "0"
                if mySettlement!.overrideEnabled {
                    cell.statusImage.image = cellStatusImageOverride
                } else {
                    cell.statusImage.image = cellStatusImageUnchecked
                }
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
    fileprivate func configureCraftButton() {
        checkCraftableStatus()
        let button = self.craftGearButtonOutlet!
        
        button.setTitle("Craft", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if self.craftability == true || (mySettlement!.overrideEnabled == true && checkIfMaxedOut(gear: gear) != true) {
            button.isEnabled = true
            button.setTitleColor(UIColor(red: 0.9686, green: 0.9647, blue: 0.8314, alpha: 1.0), for: .normal)
            button.backgroundColor = UIColor(red: 0.3882, green: 0.6078, blue: 0.2549, alpha: 1.0)
        } else {
            button.isEnabled = false
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.backgroundColor = UIColor.darkGray
        }
    }
    fileprivate func configureArchiveButton() {
        let button = self.archiveGearButtonOutlet!
        
        button.setTitle("Archive", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if mySettlement!.gearCraftedDict[gear]! < 1 {
            button.isEnabled = false
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.backgroundColor = UIColor.darkGray
        } else {
            button.isHidden = false
            button.isEnabled = true
            button.setTitleColor(UIColor(red: 0.9686, green: 0.9647, blue: 0.8314, alpha: 1.0), for: .normal)
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        }
    }

    fileprivate func configureNumAvailableLabel() {
        numAvailableLabel.text = ("\(mySettlement!.gearCraftedDict[gear]!) crafted of \(gear.qtyAvailable) available")
    }
    fileprivate func tappedCraftButton() {
        if self.mySettlement!.overrideEnabled && mySettlement!.gearCraftedDict[gear!]! < gear!.qtyAvailable {
            //mySettlement!.gearCraftedDict[gear!]! += 1
            showCraftedAlert(for: gear)
        } else if validator.checkCraftability(gear: gear!) == true && mySettlement!.gearCraftedDict[gear!]! < gear!.qtyAvailable {
            showCraftedAlert(for: gear!)
        } else {
            // Can't craft!
        }
        tableView.reloadData()
    }
    fileprivate func tappedArchiveButton() {
        showArchivedAlert(for: gear)
    }
    fileprivate func spendResources(for gear: Gear) {
        var requiredTypes = [resourceType]()
        var requiredResourceTypes = [resourceType:Int]()
        requiredTypes = gear.resourceTypeRequirements!.keys.map { $0 }
        requiredResourceTypes = gear.resourceTypeRequirements!
        
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
        spendResourcesVC.gear = self.gear
        if gear.resourceSpecialRequirements != nil {
            spendResourcesVC.requiredResources = gear.resourceSpecialRequirements
        }
        spendResourcesVC.delegate = self
        
        self.present(spendResourcesVC, animated: true, completion: nil)
    }
    func updateStorage(with spentResources: [Resource : Int]) {
        for (resource, qty) in spentResources {
            mySettlement!.resourceStorage[resource]! -= qty
            myStorage![resource]! -= qty
        }
        validator.resources = mySettlement!.resourceStorage // Update validator here?
        mySettlement!.gearCraftedDict[self.gear!]! += 1
        configureCraftButton()
        configureArchiveButton()
        configureNumAvailableLabel()
        dataModel.writeData()
        tableView.reloadData()
    }
    func checkCraftableStatus() {
        self.craftability = (validator.checkCraftability(gear: gear) == true && !checkIfMaxedOut(gear: gear))
        tableView.reloadData()
    }
    func checkIfMaxedOut (gear: Gear) -> Bool {
        if mySettlement!.gearCraftedDict[gear]! >= gear.qtyAvailable {
            return true
        } else {
            return false
        }
    }
    func showCraftedAlert(for gear: Gear) {
        //let alert = UIAlertController(title: "\(mySettlement!.gearCraftedDict[gear]!) crafted of \(gear.qtyAvailable) available", message: "", preferredStyle: .alert)
        let alert = UIAlertController(title: "Craft one \(gear.name)?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
            
            if self.mySettlement!.overrideEnabled == false {
                self.spendResources(for: gear)
            } else {
                self.mySettlement!.gearCraftedDict[gear]! += 1
            }
            self.configureCraftButton()
            self.configureArchiveButton()
            self.configureNumAvailableLabel()
            self.dataModel.writeData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func showArchivedAlert(for gear: Gear) {
        let alert = UIAlertController(title: "Archive \(gear.name)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Archive", style: .default, handler: { (UIAlertAction) in
            self.mySettlement!.gearCraftedDict[gear]! -= 1
            self.configureCraftButton()
            self.configureArchiveButton()
            self.configureNumAvailableLabel()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func configureTopLine() {
        let px = 1/UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
    }
}
