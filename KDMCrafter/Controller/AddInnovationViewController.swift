//
//  AddInnovationViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/5/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

enum innovationAction: String {
    case add = "Add"
    case addSpecial = "Add Special"
    case archive = "Archive"
}

class AddInnovationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InnovationTableViewCellDelegate, SpendResourcesVCDelegate {
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.present(settingsVC, animated: true, completion: nil)
    }
    @IBOutlet weak var innovateStatusLabel: UILabel!
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myInnovations: [Innovation]?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var currentInnovation: Innovation?
    var numInnovationRows: Int?
    var validator: CraftBuildValidator?
    var keyStore: NSUbiquitousKeyValueStore?
    var missingString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InnovationTableViewCell.nib, forCellReuseIdentifier: InnovationTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement!.resourceStorage
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name })
        myInnovations = mySettlement!.availableInnovations
        validator = CraftBuildValidator(settlement: mySettlement!)
        
        numInnovationRows = myInnovations!.count
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUpMenuButton), name: .didToggleOverride, object: nil)

        setUpMenuButton()
        navigationItem.title = "Add Innovations"
        
        keyStore = dataModel.keyStore
        // KVS Notification Center Setup
        NotificationCenter.default.addObserver(self, selector: #selector(onUbiquitousKeyValueStoreDidChangeExternally(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: DataModel.sharedInstance.keyStore)
    }

    override func viewWillAppear(_ animated: Bool) {
        myInnovations = mySettlement!.availableInnovations
        myStorage = mySettlement!.resourceStorage
        tableView.reloadData()
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
        var innoStatus = false
        let innovation = self.myInnovations![indexPath.row]
        let innovationName = innovation.name
        
        if mySettlement!.overrideEnabled && mySettlement!.innovationsAddedDict[innovation] == false {
            innoStatusString = "Add"
            innoStatus = true
            tableViewTopConstraint.constant = 0
        } else if mySettlement!.innovationsAddedDict[innovation] == false {
            let result = validator?.canWeInnovate(settlement: mySettlement!)
            missingString = ""
            innoStatusString = "Add"
            if result!.0 == true {
                innoStatus = true
                innovateStatusLabel.text = ("No Missing Resources")
                innovateStatusLabel.textColor = UIColor.systemGreen
                tableViewTopConstraint.constant = 0
            } else {
                for type in result!.2 {
                    if result!.2.count == 1 || type == result!.2.last {
                        missingString.append(type.rawValue)
                    } else {
                        missingString.append("\(type.rawValue), ")
                    }
                }
                innovateStatusLabel.text = ("Missing: \(missingString)")
                innovateStatusLabel.textColor = UIColor.systemRed
                tableViewTopConstraint.constant = 50
                innoStatus = false
            }
        } else if innovationName != "Other Innovation" {
            innoStatusString = "Archive"
            innoStatus = false
        } else { // For other Innovation
            innoStatusString = "Add"
            innoStatus = false
        }
        configureTitle(for: cell, with: innovationName, for: 4500)
        configureAddInnovationButton(for: cell, with: innoStatus, with: innoStatusString, with: 5000, for: innovation)
        return cell
    }
    // Helper functions
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, for tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        
    }
    fileprivate func configureAddInnovationButton(for cell: UITableViewCell, with status: Bool, with statusString: String, with tag: Int, for innovation: Innovation) {
        let cell = cell as! InnovationTableViewCell
        let button = cell.addInnovationButton!
        
        button.setTitle(statusString, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == true {
            button.backgroundColor = UIColor(red: 0.3882, green: 0.6078, blue: 0.2549, alpha: 1.0)
            button.isEnabled = true
        } else if status == false && statusString == "Archive" {
            button.backgroundColor = UIColor.systemRed
            button.isEnabled = true
        } else {
            button.backgroundColor = UIColor.systemGray
            button.isEnabled = false
        }
    
    }
    func tappedAddInnovationButton(cell: InnovationTableViewCell) {
        let innovation = myInnovations![cell.tag]
        if mySettlement!.innovationsAddedDict[innovation] == false && mySettlement!.overrideEnabled == true {
            showAlert(for: innovation, action: .addSpecial)
        } else if mySettlement!.innovationsAddedDict[innovation] == false {
            showAlert(for: innovation, action: .add)
        } else {
            showAlert(for: innovation, action: .archive)
        }
        dataModel.writeData()
        tableView.reloadData()
        keyStore!.synchronize()
    }
    @objc func setUpMenuButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        if mySettlement!.overrideEnabled {
            menuBtn.setImage(UIImage(named:"icons8-settings-filled-50"), for: .normal)
        } else {
            menuBtn.setImage(UIImage(named:"icons8-settings-50"), for: .normal)
        }
        menuBtn.addTarget(self, action: #selector(self.settingsButtonAction(_:)), for: UIControl.Event.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
        tableView.reloadData()
    }
    @objc func onUbiquitousKeyValueStoreDidChangeExternally(notification:Notification)
    {
        print("KVS updated!")
    }
    func showAlert(for innovation: Innovation, action: innovationAction) {
        let alert = UIAlertController(title: "\(action.rawValue) \(innovation.name)?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        if action == .archive {
            alert.addAction(UIAlertAction(title: "Archive", style: .default, handler: { (UIAlertAction) in
                self.mySettlement!.innovationsAddedDict[innovation] = false
                self.tableView.reloadData()
                self.dataModel.writeData()
            }))
        } else if action == .add {
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
                self.spendResources(for: innovation)
            }))
        } else if action == .addSpecial {
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
                if innovation.name != "Other Innovation" {
                    self.mySettlement!.innovationsAddedDict[innovation] = true
                }
                self.dataModel.writeData()
                self.tableView.reloadData()
            }))
        }

        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func spendResources(for innovation: Innovation) {
        let requiredTypes: [resourceType] = [.bone, .endeavor, .hide, .organ]
        var spendableResources = [Resource:Int]()
        validator!.resources = mySettlement!.resourceStorage // Update validator here?

        let spendResourcesVC = self.storyboard?.instantiateViewController(withIdentifier: "spendResourcesVC") as! SpendResourcesViewController
        
        for resource in myStorage!.keys {
            if myStorage![resource]! > 0 {
                for type in resource.type {
                    if requiredTypes.contains(type) {
                        spendableResources[resource] = myStorage![resource]! //assign value
                        break
                    }
                }
            }
        }
        spendResourcesVC.spendableResources = spendableResources
        spendResourcesVC.requiredResourceTypes = [.bone:1, .endeavor:1, .hide:1, .organ:1] //don't need resources per se

        self.currentInnovation = innovation
        spendResourcesVC.delegate = self
        
        self.present(spendResourcesVC, animated: true, completion: nil)
    }
    func updateStorage(with spentResources: [Resource : Int]) {
        for (resource, qty) in spentResources {
            mySettlement!.resourceStorage[resource]! -= qty
            //myStorage![resource]! -= qty
        }
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name }) //Update here?
        validator!.resources = mySettlement!.resourceStorage // Update validator here?
        if currentInnovation!.name != "Other Innovation" {         mySettlement!.innovationsAddedDict[currentInnovation!] = true } // Don't set to true if other
        dataModel.writeData()
        tableView.reloadData()
    }
    
}
