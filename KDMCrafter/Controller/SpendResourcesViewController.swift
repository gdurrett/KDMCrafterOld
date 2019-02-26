//
//  SpendResourcesViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/19/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol SpendResourcesVCDelegate: class {
    func updateStorage(with spentResources: [Resource:Int], location: Location)
}
class SpendResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func save(_ sender: Any) { // Maybe use notification to update values?
        delegate!.updateStorage(with: spentResources, location: location)
        self.dismiss(dismiss(animated: true, completion: nil))
    }
    
    @IBOutlet weak var save: UIButton!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var spendableResources: [Resource:Int]! // Sent by Resource VC
    var requiredResourceTypes: [resourceType:Int]! // Sent by Resource VC
    var location: Location! // Sent by ResorurceVC
    
    var spentResources = [Resource:Int]() // Track spent resources
    var spentResourceTypes = [Resource:[resourceType:Int]]() // Track spent resource types by Resource
    var spentResourceTypesTemp = [resourceType:Int]() // Used to compare against required types for enabling save button
    
    var sortedSpendableResources: [(key: Resource, value: Int)]?
    var sortedSpentResources: [(key: Resource, value: Int)]?
    
    var resourceName: String?
    var resourceValue: Int?
    
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
        
        save.isHidden = true
        
        sortedSpendableResources = spendableResources!.sorted(by: { $0.key.name < $1.key.name })
        sortedSpentResources = sortedSpendableResources! // Initialize to same values as spendable to begin with

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSpendableResources!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        //let cell = makeCell(for: tableView)
        cell.backgroundColor = UIColor.clear

        let key = sortedSpendableResources![indexPath.row].0
        let value = sortedSpendableResources![indexPath.row].1

        resourceName = key.name
        resourceValue = value
        
        configureTitle(for: cell, with: resourceName!, with: 3500)
        configureValue(for: cell, with: resourceValue!)
        
        cell.stepperOutlet.value = Double(value)
        cell.stepperOutlet.maximumValue = Double(value)
        cell.resourceCountLabel.text! = "\(value)"
        
        cell.observation = cell.stepperOutlet.observe(\.value, options: [.new]) { (stepper, change) in
            //cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            self.stepperVal = Int(change.newValue!)
            self.currentCell = cell
            
            self.save.isHidden = true
            self.sortedSpentResources![indexPath.row].1 = Int(change.newValue!)
            let spentResourceQty = self.sortedSpendableResources![indexPath.row].1 - self.sortedSpentResources![indexPath.row].1
            if self.sortedSpentResources![indexPath.row].0.type.count > 1 {
                self.typeChoices = self.sortedSpentResources![indexPath.row].0.type
                self.showChoices(self)
            } else {
                cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            }
            if spentResourceQty >= 0 {
                for type in self.sortedSpentResources![indexPath.row].0.type {
                    //self.spentResourceTypes[key] = [type:spentResourceQty]
                    self.currentResource = key
                    self.currentQty = spentResourceQty
                    self.setSpentTypes(key: key, type: type, spentResourceQty: spentResourceQty)
                }
            }
            let typeVals = Array(self.spentResourceTypes.values)
            for type in self.requiredResourceTypes.keys {
                let spentAmount = typeVals.flatMap{$0}.filter { $0.key == type }.map{ $0.value }.reduce(0,+)
                self.spentResourceTypesTemp[type] = spentAmount
            }
            for (resource, qty) in self.spentResourceTypes {
                self.spentResources[resource] = Array(qty.values)[0] // Assign spent resources
            }

            self.checkIfRequirementsMet()
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
        }
    }
    fileprivate func setSpentTypes(key: Resource, type: resourceType, spentResourceQty: Int) {
            self.spentResourceTypes[key] = [type:spentResourceQty]
    }
    @IBAction func showChoices(_ sender: Any) {
        let alert = UIAlertController(title: "Use resource for which type?", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.spentResourceTypes[self.currentResource!] = [self.selectedType!:self.currentQty!]
            self.currentCell!.resourceCountLabel.text = "\(self.stepperVal!)"

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
        selectedType = self.typeChoices[row]
    }
}