//
//  SettingsViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 4/4/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var mySettlement = DataModel.sharedInstance.currentSettlement
    
    var settingsButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        settingsButton.frame = CGRect(x: 340, y: 6, width: 80, height: 30)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        if indexPath.section == 0 {
            cell.view.addSubview(settingsButton)
            settingsButton.setTitle("OK", for: .normal)
            settingsButton.tintColor = UIColor.red
            settingsButton.addTarget(self, action: #selector(resetSettlement(sender:)), for: .touchUpInside)
            cell.settingNameLabel.text = "Reset Settlement"
        }
        return cell
    }

    @objc func resetSettlement(sender: UIButton) {
        
    }
}
