//
//  AddInnovationViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/5/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class AddInnovationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InnovationTableViewCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myInnovations: [Innovation]?
    var numInnovationRows: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InnovationTableViewCell.nib, forCellReuseIdentifier: InnovationTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        mySettlement = dataModel.currentSettlement!
        myInnovations = mySettlement!.availableInnovations
        
        numInnovationRows = myInnovations!.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numInnovationRows!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InnovationTableViewCell", for: indexPath) as! InnovationTableViewCell
        cell.cellDelegate = self
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.layoutMargins = UIEdgeInsets.zero
        
        var innoStatusString = String()
        let innovation = self.myInnovations![indexPath.row]
        let innovationName = innovation.name
        
        if mySettlement!.innovationsAddedDict[innovation] == false {
            innoStatusString = "Add"
        } else {
            innoStatusString = "Archive"
        }
        
        configureTitle(for: cell, with: innovationName, for: 4500)
        configureAddInnovationButton(for: cell, with: innoStatusString, with: 5000, for: innovation)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " Add Innovations"
    }
    // Helper functions
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, for tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        
    }
    fileprivate func configureAddInnovationButton(for cell: UITableViewCell, with status: String, with tag: Int, for innovation: Innovation) {
        let cell = cell as! InnovationTableViewCell
        let button = cell.addInnovationButton!
        
        button.setTitle(status, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == "Add" {
            button.backgroundColor = UIColor(red: 0, green: 0.8588, blue: 0.1412, alpha: 1.0)
        } else {
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        }
    
    }
    func tappedAddInnovationButton(cell: InnovationTableViewCell) {
        let innovation = myInnovations![cell.tag]
        if mySettlement!.innovationsAddedDict[innovation] == false {
            mySettlement!.innovationsAddedDict[innovation] = true
        } else {
            mySettlement!.innovationsAddedDict[innovation] = false
        }
        dataModel.writeData()
        tableView.reloadData()
    }
    
}
