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
class SpendResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

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
            cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            self.save.isHidden = true
            self.sortedSpentResources![indexPath.row].1 = Int(change.newValue!)
            let spentResource = self.sortedSpendableResources![indexPath.row].1 - self.sortedSpentResources![indexPath.row].1
            if spentResource >= 0 {
                for type in self.sortedSpentResources![indexPath.row].0.type {
                    self.spentResourceTypes[key] = [type:spentResource]
                }
            }
            let typeVals = Array(self.spentResourceTypes.values)
            for type in self.requiredResourceTypes.keys {
                let spentAmount = typeVals.flatMap{$0}.filter { $0.key == type }.map{ $0.value }.reduce(0,+)
                //print("Spent \(spentAmount) \(type.rawValue)")
                self.spentResourceTypesTemp[type] = spentAmount
            }
            for (resource, qty) in self.spentResourceTypes {
                //print("We spent \(Array(qty.values)[0]) \(resource.name)")
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
}
