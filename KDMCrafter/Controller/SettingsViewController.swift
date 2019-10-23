//
//  SettingsViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 4/4/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsButtonTableViewCellDelegate, SettingsSwitchTableViewCellDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    var dataModel = DataModel.sharedInstance
    
    var overrideSwitchState: Bool?
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsSwitchTableViewCell.nib, forCellReuseIdentifier: SettingsSwitchTableViewCell.identifier)
        tableView.register(SettingsButtonTableViewCell.nib, forCellReuseIdentifier: SettingsButtonTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        overrideSwitchState = dataModel.currentSettlement.overrideEnabled ? true:false
    }

//    override func viewWillAppear(_ animated: Bool) {
//        overrideSwitchState = dataModel.currentSettlement.overrideEnabled ? true:false
//    }
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
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsButtonTableViewCell", for: indexPath) as! SettingsButtonTableViewCell
            cell.cellDelegate = self
            cell.settingsNameLabelOutlet.text = "Reset Settlement"
            cell.settingsResetButtonOutlet.setTitle("OK", for: .normal)
            cell.settingsResetButtonOutlet.tintColor = UIColor.white
            cell.settingsResetButtonOutlet.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
            cell.settingsResetButtonOutlet.layer.masksToBounds = true
            cell.settingsResetButtonOutlet.layer.cornerRadius = 5
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchTableViewCell", for: indexPath) as! SettingsSwitchTableViewCell
            cell.settingsNameLabel.text = "Enable Override"
            cell.cellDelegate = self
            if self.overrideSwitchState == true {
                cell.settingsOverrideSwitchOutlet.setOn(true, animated: true)
            } else {
                cell.settingsOverrideSwitchOutlet.setOn(false, animated: true)
            }
            return cell
        }
        return UITableViewCell()
    }

    func tappedResetButton(cell: SettingsButtonTableViewCell) {
        showResetAlert()
    }
    func tappedOverrideButton(cell: SettingsSwitchTableViewCell) {
        let overrideSwitch = cell.settingsOverrideSwitchOutlet
        if overrideSwitch!.isOn {
            dataModel.currentSettlement.overrideEnabled = true
            notificationCenter.post(Notification(name: .didToggleOverride, object: nil))
            self.overrideSwitchState = true
        } else {
            dataModel.currentSettlement.overrideEnabled = false
            notificationCenter.post(Notification(name: .didToggleOverride, object: nil))
            self.overrideSwitchState = false
        }
    }
    func showResetAlert() {
        let alert = UIAlertController(title: "Reset settlement \(dataModel.currentSettlement.name)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler:  { (UIAlertAction) in
            self.dataModel.currentSettlement.initializeDictionaries()
            self.dataModel.writeData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
