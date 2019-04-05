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
    var settingsSwitch = UISwitch(frame: CGRect(x: 340, y: 6, width: 60, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        settingsButton.frame = CGRect(x: 340, y: 6, width: 60, height: 30)
        
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 5
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return " Settings"
        } else {
            return ""
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        if indexPath.section == 0 {
            cell.view.addSubview(settingsButton)
            cell.settingNameLabel.text = "Reset Settlement"

            settingsButton.setTitle("OK", for: .normal)
            settingsButton.tintColor = UIColor.white
            settingsButton.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
            settingsButton.layer.masksToBounds = true
            settingsButton.layer.cornerRadius = 5
            settingsButton.addTarget(self, action: #selector(resetSettlement(sender:)), for: .touchUpInside)
            
        } else if indexPath.section == 1 {
            cell.view.addSubview(settingsSwitch)
            cell.settingNameLabel.text = "Enable Override"
            
            settingsSwitch.addTarget(self, action: #selector(enableOverride(sender:)), for: .touchUpInside)
        }
        return cell
    }

    @objc func resetSettlement(sender: UIButton) {
        showResetAlert()
    }
    @objc func enableOverride(sender: UISwitch) {
        if sender.isOn {
            mySettlement!.overrideEnabled = true
        } else {
            mySettlement!.overrideEnabled = false
        }
    }
    func showResetAlert() {
        let alert = UIAlertController(title: "Reset settlement \(mySettlement!.name)?", message: "", preferredStyle: .alert)
        alert.isModalInPopover = true
        alert.addAction((UIAlertAction(title: "Cancel", style: .default, handler: nil)))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler:  { (UIAlertAction) in
            self.mySettlement!.initializeDictionaries()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
