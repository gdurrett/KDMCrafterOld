//
//  FilterResourceViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 8/26/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class FilterResourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelFilterAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func applyFilterAction(_ sender: Any) {
        if tableView.indexPathForSelectedRow == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            if selectedType != nil {
                let filteredType = self.filteredTypeCompletionHandler?(selectedType!)
            }
            //let filteredTypeLabel = self.filteredTypeLabelCompletionHandler?(selectedType)
            self.dismiss(animated: true, completion: nil)
        }

    }
    @IBAction func clearFilterAction(_ sender: Any) {
        let filteredType = self.filteredTypeCompletionHandler?("All")
        let rows = tableView.numberOfRows(inSection: 0)
        for row in 0..<rows {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.setSelected(false, animated: true)
        }
        self.selectedType = nil
    }
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    
    var basicTypes = ["Bone", "Consumable", "Hide", "Iron", "Organ", "Scrap", "Vermin"]
    var specialTypes = [String]()
    var tableTypes = [String]()
    var selectedType: String?
    var filteredTypeCompletionHandler: ((String) -> String)?
    //var filteredTypeLabelCompletionHandler: ((String) -> String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTypeCell.nib, forCellReuseIdentifier: ResourceTypeCell.identifier)
        
        //self.tableView.allowsMultipleSelection = true
        //self.tableView.allowsMultipleSelectionDuringEditing = true
        
        mySettlement = dataModel.currentSettlement
        
        //resourceTypes = Array(NSOrderedSet(array: mySettlement!.allResources.compactMap { $0.type })) as! [resourceType]    }
        for resource in mySettlement!.allResources {
            for type in resource.type {
                if basicTypes.contains(type.rawValue) {
                basicTypes.append(resourceType(rawValue: String(type.rawValue))!.rawValue)
                }
//                if resource.name.lowercased() == type.rawValue.lowercased() {
//                    print(resource.name)
//                }
            }
        }
        basicTypes = basicTypes.removingDuplicates()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basicTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTypeCell", for: indexPath) as! ResourceTypeCell
        configureTypeLabel(for: cell, with: (resourceType)(rawValue: basicTypes[indexPath.row])!)
        cell.selectionStyle = .none
        
        if selectedType != nil {
            if cell.label.text?.lowercased() == selectedType {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = basicTypes[indexPath.row].lowercased()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    fileprivate func configureTypeLabel(for cell: UITableViewCell, with type: (resourceType)) {
        let label = cell.viewWithTag(4125) as! UILabel
        label.text = "\(type.rawValue)"
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
