//
//  FilterTypeViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 8/29/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class FilterGearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func applyFilterAction(_ sender: Any) {
        if tableView.indexPathForSelectedRow == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            if selectedType != nil {
                _ = self.filteredTypeCompletionHandler?(selectedType!)
            }
            if selectedCraftability != nil {
                _ = self.filteredTypeCompletionHandler?(selectedCraftability!)
                print("Over here we have \(selectedCraftability!)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func cancelFilterAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFilterAction(_ sender: Any) {
        _ = self.filteredTypeCompletionHandler?("All")
        _ = self.filteredCraftabilityCompletionHandler?("All")
        
        let rows = tableView.numberOfRows(inSection: 0)
        for row in 0..<rows {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.setSelected(false, animated: true)
        }
        self.selectedType = nil
        self.selectedCraftability = nil
    }
    
    @IBAction func selectCraftabilityAction(_ sender: Any) {
        switch self.selectCraftabilityOutlet.selectedSegmentIndex {
        case 0:
            self.selectedCraftability = "all"
        case 1:
            self.selectedCraftability = "craftable"
        case 2:
            self.selectedCraftability = "uncraftable"
        default:
            self.selectedCraftability = "all"
        }
    }
    @IBOutlet weak var selectCraftabilityOutlet: UISegmentedControl!
    
    //    let dataModel = DataModel.sharedInstance
//    var mySettlement: Settlement?
    var types = ["Armor", "Items", "Weapons"]
    var filteredTypeCompletionHandler: ((String) -> String)?
    var filteredCraftabilityCompletionHandler: ((String) -> String)?
    
    var selectedType: String?
    var selectedCraftability: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTypeCell.nib, forCellReuseIdentifier: ResourceTypeCell.identifier)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTypeCell", for: indexPath) as! ResourceTypeCell
        configureChoiceLabel(for: cell, with: types[indexPath.row])
        cell.selectionStyle = .none
        
        if selectedType != nil {
            print("Selecting \(selectedType!)?")
            if cell.label.text?.lowercased() == selectedType {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = types[indexPath.row].lowercased()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    func configureChoiceLabel(for cell: UITableViewCell, with string: String) {
        let label = cell.viewWithTag(4125) as! UILabel
        label.text = string
    }
}
