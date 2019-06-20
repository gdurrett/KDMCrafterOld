//
//  CraftGearViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/27/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class CraftGearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func segmentedControlAction(_ sender: Any) {
        sortedCraftableGear = getCraftableGear()
        sortedUncraftableGear = getUncraftableGear()
        updateSearchResults(for: self.searchController)
        tableView.reloadData()
    }
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        if let mainVC = self.navigationController?.tabBarController?.parent as? MainViewController {
            mainVC.toggleSideMenu(fromViewController: self)
        }
    }
    let dataModel = DataModel.sharedInstance
    let gearDetailSegueIdentifier = "ShowCraftGearDetailView"
    
    var validator = CraftBuildValidator(settlement: DataModel.sharedInstance.currentSettlement!)
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var filteredSortedStorage: [(key: Resource, value: Int)]?
    
    var sortedGear: [Gear]?
    var filteredSortedGear: [Gear]?
    var sortedCraftableGear: [Gear]?
    var filteredSortedCraftableGear: [Gear]?
    var sortedUncraftableGear: [Gear]?
    var filteredSortedUncraftableGear: [Gear]?
    
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
    var numGearRows: Int?
    var currentGear: Gear?
    
    var craftability = Bool()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.register(GearTableViewCell.nib, forCellReuseIdentifier: GearTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        mySettlement = dataModel.currentSettlement!
        myStorage = mySettlement!.resourceStorage
        numGearRows = dataModel.currentSettlement!.availableGear.count
        myAvailableGear = mySettlement!.availableGear
        
        sortedGear = myAvailableGear!.sorted(by: { $0.name < $1.name })
        sortedCraftableGear = getCraftableGear()
        sortedUncraftableGear = getUncraftableGear()
        sortedStorage = myStorage!.sorted(by: { $0.key.name < $1.key.name })

        NotificationCenter.default.addObserver(self, selector: #selector(setUpMenuButton), name: .didToggleOverride, object: nil)

        setupSearch()
        setUpMenuButton()
        
        navigationItem.title = "Craft Gear"
        
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        mySettlement = dataModel.currentSettlement!
        myAvailableGear = mySettlement!.availableGear
        myStorage = mySettlement!.resourceStorage
        validator.resources = mySettlement!.resourceStorage
        sortedCraftableGear = getCraftableGear()
        sortedUncraftableGear = getUncraftableGear()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segmentedControlOutlet.selectedSegmentIndex) {
        case 0:
            if isFiltering() {
                return self.filteredSortedGear!.count
            } else {
                return (self.sortedGear?.count)!
            }
        case 1:
            if isFiltering() {
                return self.filteredSortedCraftableGear!.count
            } else {
                return self.sortedCraftableGear!.count
            }
        case 2:
            if isFiltering() {
                return self.filteredSortedUncraftableGear!.count
            } else {
                return self.sortedUncraftableGear!.count
            }
        default:
            return (self.sortedGear?.count)!
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GearTableViewCell", for: indexPath) as! GearTableViewCell
        cell.tag = indexPath.row
        cell.layoutMargins = UIEdgeInsets.zero
        cell.accessoryType = .disclosureIndicator

        var gear: Gear
        
        switch(segmentedControlOutlet.selectedSegmentIndex) {
        case 0:
            if isFiltering() {
                gear = self.filteredSortedGear![indexPath.row]
            } else {
                gear = self.sortedGear![indexPath.row]
            }
        case 1:
            if isFiltering() {
                gear = filteredSortedCraftableGear![indexPath.row]
            } else {
                gear = self.sortedCraftableGear![indexPath.row]
            }
        case 2:
            if isFiltering() {
                gear = self.filteredSortedUncraftableGear![indexPath.row]
            } else {
                gear = self.sortedUncraftableGear![indexPath.row]
            }
        default:
            gear = self.sortedGear![indexPath.row]
        }
        
        configureTitle(for: cell, with: gear.name, with: 3750)
        configureNumCraftableLabel(for: cell, with: gear, for: 3975)
        configureQtyAvailableLabel(for: cell, with: gear, with: 4000)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let craftDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CraftGearDetailViewController") as? CraftGearDetailViewController {
            let gearIndex = tableView.indexPathForSelectedRow?.row

            switch(segmentedControlOutlet.selectedSegmentIndex) {
            case 0:
                if isFiltering() {
                    craftDetailVC.gear = self.filteredSortedGear![gearIndex!]
                } else {
                    craftDetailVC.gear = self.sortedGear![gearIndex!]
                }
            case 1:
                if isFiltering() {
                    craftDetailVC.gear = self.filteredSortedCraftableGear![gearIndex!]
                } else {
                    craftDetailVC.gear = self.sortedCraftableGear![gearIndex!]
                }
            case 2:
                if isFiltering() {
                    craftDetailVC.gear = self.filteredSortedUncraftableGear![gearIndex!]
                } else {
                    craftDetailVC.gear = self.sortedUncraftableGear![gearIndex!]
                }
            default:
                craftDetailVC.gear = self.sortedGear![gearIndex!]
            }
            craftDetailVC.craftability = self.validator.checkCraftability(gear: craftDetailVC.gear)
            self.navigationController?.pushViewController(craftDetailVC, animated: true)
        }
    }

    // Helper methods
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        label.sizeToFit()
    }
    fileprivate func configureCraftLabel(for cell: UITableViewCell, with status: String, with tag: Int) {
        let cell = cell as! GearTableViewCell
        let button = cell.craftButton!
        
        button.setTitle(status, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == "Craft" {
            button.backgroundColor = UIColor(red: 0.3882, green: 0.6078, blue: 0.2549, alpha: 1.0)
        } else if status == "Uncraftable" {
            button.setTitle("Craft", for: .normal)
            button.backgroundColor = UIColor.gray
        } else if status == "Destroy" {
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            //button.isHidden = true
        }
    }
    fileprivate func configureArchiveLabel(for cell: UITableViewCell, with status: String, with tag: Int) {
        let cell = cell as! GearTableViewCell
        let button = cell.archiveButton!
        
        button.setTitle("Archive", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        if status == "Archivable" {
            button.backgroundColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            button.backgroundColor = UIColor.gray
        }
    }
    fileprivate func configureQtyAvailableLabel(for cell: UITableViewCell, with gear: Gear, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        let labelString = "\(mySettlement!.gearCraftedDict[gear]!) crafted of \(gear.qtyAvailable) available"
        label.text! = labelString
        label.textColor = UIColor.gray
    }
    fileprivate func configureNumCraftableLabel(for cell: UITableViewCell, with gear: Gear, for tag: Int) {
//        let numCraftable = self.validator.checkCraftability(gear: gear) > gear.qtyAvailable ? gear.qtyAvailable:self.validator.checkCraftability(gear: gear) // If numCraftable greater than qty available, use qtyAvailable
        
        let label = cell.viewWithTag(tag) as! UILabel
        var labelString = String()
        
        if validator.checkCraftability(gear:gear) == true && !checkIfMaxedOut(gear: gear) || mySettlement!.overrideEnabled && !checkIfMaxedOut(gear: gear) {
            labelString = "Craftable"
            self.craftability = true
            label.textColor = UIColor(red: 0.3882, green: 0.6078, blue: 0.2549, alpha: 1.0)
        } else {
            labelString = "Uncraftable"
            self.craftability = false
            label.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        }
        label.text = labelString
    }
    fileprivate func configureGearInfoLabel(for cell: UITableViewCell, with info: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UITextView
        label.text = info
        
    }
    fileprivate func configureMissingResourceLabel(for cell: UITableViewCell, with missing: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UITextView
        label.text = missing.replacingOccurrences(of: "[\\[\\]\"]", with: "", options: .regularExpression, range: nil)
        if (label.text!.contains("Missing") || label.text!.contains("Max")) && label.text != "Lantern Hoard" {
            label.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            label.textColor = UIColor.black
        }
        if label.text!.contains("Special") {
            label.text = missing.replacingOccurrences(of: "Special: ", with: "")
            label.textColor = UIColor.gray
        }
        label.backgroundColor = UIColor.clear
    }
    fileprivate func getCraftableGear() -> [Gear] {
        self.sortedCraftableGear = []
        for gear in mySettlement!.availableGear {
            if validator.checkCraftability(gear: gear) == true && !checkIfMaxedOut(gear: gear) {
                self.sortedCraftableGear!.append(gear)
            }
        }
        if isFiltering() {
            updateSearchResults(for: self.searchController)
            return self.filteredSortedCraftableGear!.sorted(by: { $0.name < $1.name })
        } else if mySettlement!.overrideEnabled == true {
            self.sortedCraftableGear = []
            for gear in mySettlement!.availableGear {
                if !checkIfMaxedOut(gear: gear) {
                    self.sortedCraftableGear?.append(gear)
                }
            }
            return self.sortedCraftableGear!.sorted(by: { $0.name < $1.name })
        } else {
            return self.sortedCraftableGear!.sorted(by: { $0.name < $1.name })
        }
    }
    fileprivate func getUncraftableGear() -> [Gear] {
        self.sortedUncraftableGear = []
        for gear in mySettlement!.availableGear {
            if validator.checkCraftability(gear: gear) == false || checkIfMaxedOut(gear: gear) {
                self.sortedUncraftableGear!.append(gear)
            }
        }
        if mySettlement!.overrideEnabled == true {
            return []
        } else {
            return self.sortedUncraftableGear!.sorted(by: { $0.name < $1.name })
        }
    }

    func checkIfMaxedOut (gear: Gear) -> Bool {
        if mySettlement!.gearCraftedDict[gear]! >= gear.qtyAvailable {
            return true
        } else {
            return false
        }
    }
    fileprivate func setupSearch() {
        //Set up searchController stuff
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.placeholder = "Search gear names"
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.textField?.backgroundColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.9686, alpha: 1.0)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.showsCancelButton = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        //tableView.tableHeaderView = nil
        searchController.hidesNavigationBarDuringPresentation = false
    }
    // Search Controller delegate stuff
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        switch(segmentedControlOutlet.selectedSegmentIndex) {
        case 0:
            filteredSortedGear = self.sortedGear!.filter( {( gear: Gear) -> Bool in
                return gear.name.lowercased().contains(searchText.lowercased())
            })
        case 1:
            if mySettlement!.overrideEnabled == true {
                filteredSortedCraftableGear = self.myAvailableGear!.filter( {( gear: Gear) -> Bool in
                    return gear.name.lowercased().contains(searchText.lowercased())
                })
            } else {
                filteredSortedCraftableGear = self.sortedCraftableGear!.filter( {( gear: Gear) -> Bool in
                    return gear.name.lowercased().contains(searchText.lowercased())
                })
            }
        case 2:
            filteredSortedUncraftableGear = self.sortedUncraftableGear!.filter( {( gear: Gear) -> Bool in
                return gear.name.lowercased().contains(searchText.lowercased())
            })
        default:
            sortedGear = self.sortedGear!.filter( {( gear: Gear) -> Bool in
                return gear.name.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
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
        self.segmentedControlAction(self)
    }

}

extension CraftGearViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
extension CraftGearViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

