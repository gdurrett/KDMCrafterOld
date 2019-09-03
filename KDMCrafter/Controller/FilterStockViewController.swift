//
//  FilterStockViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 8/29/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class FilterStockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func applyFilterAction(_ sender: Any) {
    }
    @IBAction func cancelFilterAction(_ sender: Any) {
    }
    
    @IBAction func clearFilterAction(_ sender: Any) {
    }
    
//    let dataModel = DataModel.sharedInstance
//    var mySettlement: Settlement?
    let choices = ["In Stock", "Out Of Stock"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTypeCell.nib, forCellReuseIdentifier: ResourceTypeCell.identifier)
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTypeCell", for: indexPath) as! ResourceTypeCell
        
        cell.selectionStyle = .none
        configureChoiceLabel(for: cell, with: choices[indexPath.row])
        
        return cell
    }
    
    func configureChoiceLabel(for cell: UITableViewCell, with string: String) {
        let label = cell.viewWithTag(4125) as! UILabel
        label.text = string
    }
}
