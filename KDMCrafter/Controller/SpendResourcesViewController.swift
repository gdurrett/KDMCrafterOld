//
//  SpendResourcesViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/19/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol SpendResourcesVCDelegate: class {
    func updateStorage(with spentResources: [Resource:Int])
}
class SpendResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var requiredTypesLabel: UILabel!
    @IBOutlet weak var spentTypesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func save(_ sender: Any) { // Maybe use notification to update values?
        delegate!.updateStorage(with: spentResources)
        self.dismiss(dismiss(animated: true, completion: nil))
    }
    
    @IBOutlet weak var save: UIButton!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var spendableResources: [Resource:Int]! // Sent by Craft Detail VC
    var requiredResourceTypes: [resourceType:Int]! // Sent by Craft Detail VC
    var requiredResources: [Resource:Int]? // Sent by Craft Detail VC
    
    var spentResources = [Resource:Int]() // Track spent resources
    var spentResourceTypes = [Resource:[resourceType:Int]]() // Track spent resource types by Resource
    var spentResourceTypesTemp = [resourceType:Int]() // Used to compare against required types for enabling save button
    
    var sortedSpendableResources: [(key: Resource, value: Int)]?
    var sortedSpentResources: [(key: Resource, value: Int)]?
    var prevSpentResources = Int()
        
    var resourceName: String?
    var resourceValue: Int?
    
    var requiredTypesString = "Required: "
    var spentTypesString = String()
    var providedTypesString = "Provides: "
    var spentResourcesString = " "
    
    // For type picker alertView
    var typeChoices = [resourceType]()
    var pickerView = UIPickerView()
    var typeValue = String()
    
    var currentResource: Resource?
    var currentQty: Int?
    var selectedType: resourceType?
    var currentCell: ResourceTableViewCell?
    var stepperVal: Int?
    
    weak var delegate: SpendResourcesVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        save.isHidden = true
        //spentTypesLabel.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        spentTypesLabel.textColor = UIColor.white
        if spendableResources == [:] { // resources auto-spent in this case, so just show done and spend them (maybe need an alert?)
            preSpend()
            for (resource, qty) in requiredResources! {
                spentResourceTypes[resource] = [resource.type[0]:qty]
            }
            checkIfRequirementsMet()
        } else {
            preSpend()
        }
        sortedSpendableResources = spendableResources!.sorted(by: { $0.key.name < $1.key.name })
        sortedSpentResources = sortedSpendableResources! // Initialize to same values as spendable to begin with
        
        for (type, qty) in requiredResourceTypes {
            spentTypesString.append("\(type.rawValue.capitalized):0/\(qty) ")
        }
        spentTypesLabel.text! = spentResourcesString + spentTypesString
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSpendableResources!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero

        providedTypesString = "Provides: "
        
        let key = sortedSpendableResources![indexPath.row].0
        let value = sortedSpendableResources![indexPath.row].1

        resourceName = key.name
        resourceValue = value
        
        configureTitle(for: cell, with: resourceName!, with: 3500)
        configureValue(for: cell, with: resourceValue!)
        
        cell.stepperOutlet.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        for (idx, type) in key.type.enumerated() {
            if key.type.count > 1 && !(idx == key.type.endIndex - 1) {
                self.providedTypesString.append("\(type.rawValue), ")
            } else if key.type.count > 1 {
                self.providedTypesString.append("\(type.rawValue)")
            } else {
                self.providedTypesString.append("\(type.rawValue)")
            }
        }
        cell.providedTypesLabel.text! = self.providedTypesString
        cell.providedTypesLabel.textColor = UIColor.gray
        
        cell.stepperOutlet.value = Double(value)
        cell.stepperOutlet.maximumValue = Double(value)
        cell.resourceCountLabel.text! = "\(value)"

        cell.observation = cell.stepperOutlet.observe(\.value, options: [.new]) { (stepper, change) in
            
            self.typeChoices.removeAll()
            
            self.stepperVal = Int(change.newValue!)
            self.currentCell = cell
            self.prevSpentResources = self.sortedSpendableResources![indexPath.row].1 - self.sortedSpentResources![indexPath.row].1
            self.sortedSpentResources![indexPath.row].1 = Int(change.newValue!)
            let spentResourceQty = self.sortedSpendableResources![indexPath.row].1 - self.sortedSpentResources![indexPath.row].1            
            
            var typesProvidedByThisResource = [resourceType]()
            for type in self.requiredResourceTypes.keys { // Get a count of types provided by this resource that are required by gear in question
                if key.type.contains(type) {
                    typesProvidedByThisResource.append(type)
                }
            }
            let weDecremented = (spentResourceQty < self.prevSpentResources) ? true:false
            if key.type.count == 1 { // No need for picker
                self.setSpentTypes(key: key, type: key.type[0], spentResourceQty: spentResourceQty) // Spend the only type this resource has
                self.setSpentTypes()
                cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            } else if typesProvidedByThisResource.count == 1 { // If this resource provides multiple types, but only one of the types qualifies for use
                self.setSpentTypes(key: key, type: typesProvidedByThisResource[0], spentResourceQty: spentResourceQty)
                self.setSpentTypes()
                cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            } else if weDecremented { // If we 'unspent'
                self.setSpentTypes(key: key, type: key.type[1], spentResourceQty: spentResourceQty)
                self.setSpentTypes()
                cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            } else if key.kind != .basic && key.type.count > 2 { // Call picker but strip away Special Type first, but only if there's more than one non-basic type after the initial special type
                for type in self.sortedSpentResources![indexPath.row].0.type {
                    if type == self.sortedSpentResources![indexPath.row].0.type[0] && key.name != "???" {
                        continue
                    } else if !self.requiredResourceTypes.keys.contains(type) {
                        continue
                    } else {
                        self.typeChoices.append(type)
                    }
                }
                self.currentResource = key
                self.currentQty = spentResourceQty
                self.showChoices(self)
            } else {
                self.setSpentTypes(key: key, type: key.type[1], spentResourceQty: 1)
                self.setSpentTypes()
                cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            }
            
        }
        return cell
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
    fileprivate func checkIfRequirementsMet() {
        if spentResourceTypesTemp == requiredResourceTypes {
            save.isHidden = false
            //self.spentTypesLabel.textColor = UIColor(red: 0, green: 0.8588, blue: 0.1412, alpha: 1.0)
            self.spentTypesLabel.textColor = UIColor.black
        } else {
            save.isHidden = true
            //spentTypesLabel.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
            spentTypesLabel.textColor = UIColor.white
        }
        for (resource, qty) in self.spentResourceTypes {
            self.spentResources[resource] = Array(qty.values)[0] // Assign spent resources
        }
    }
    fileprivate func setSpentTypes(key: Resource, type: resourceType, spentResourceQty: Int) {
            self.spentResourceTypes[key] = [type:spentResourceQty]
    }
    fileprivate func setSpentTypes() {

        let typeVals = Array(self.spentResourceTypes.values)
        self.spentTypesString = spentResourcesString
        for (type, qty ) in self.requiredResourceTypes {
            let spentAmount = typeVals.flatMap{$0}.filter { $0.key == type }.map{ $0.value }.reduce(0,+)
            self.spentResourceTypesTemp[type] = spentAmount
                 self.spentTypesString.append("\(type.rawValue.capitalized):\(spentAmount)/\(qty) ")
        }
        self.spentTypesLabel.text = self.spentTypesString
        self.checkIfRequirementsMet()
    }

    fileprivate func preSpend() { // Automatically reduce spendable resources that we know have to be used for this gear (requiredSpecial)
        for (resource, _) in spendableResources! {
            if requiredResources != nil && requiredResources![resource] != nil {
                spendableResources[resource]! -= requiredResources![resource]!
                if spendableResources[resource]! == 0 {
                    spendableResources.removeValue(forKey: resource)
                }
            }
        }
        if requiredResources != nil {
            for (resource, qty) in requiredResources! {
                spentResourcesString.append ("\(resource.name):\(qty)/\(qty) ")
            }
        }
    }
    @IBAction func showChoices(_ sender: Any) {
        let alert = UIAlertController(title: "Use resource for which type?", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.currentCell!.stepperOutlet.value += 1 // Re-increment stepper behind the scenes so that minus button is not greyed out after canceling picker
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            if self.selectedType == nil {
                self.selectedType = self.typeChoices[0] // Auto-pick first entry if picker isn't actually moved by user
            }
            self.spentResourceTypes[self.currentResource!] = [self.selectedType!:self.currentQty!]
            self.currentCell!.resourceCountLabel.text = "\(self.stepperVal!)"
            self.setSpentTypes()
        }))
        self.present(alert,animated: true, completion: nil )
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeChoices.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeChoices[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.selectedType = self.typeChoices[row]
    }
}
