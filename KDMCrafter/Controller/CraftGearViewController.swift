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
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterTypesButton: UIButton!
    @IBOutlet weak var filterArrow: UIButton!
    @IBAction func settingsButtonAction(_ sender: Any) {
        if let mainVC = self.navigationController?.tabBarController?.parent as? MainViewController {
            mainVC.toggleSideMenu(fromViewController: self)
        }
    }
    @IBOutlet weak var settingsButtonOutlet: UIBarButtonItem!
    @IBAction func filterGearAction(_ sender: Any) {
        filterGear()
        updateResults()
        tableView.reloadData()
    }
    @IBAction func showFilterAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
            if !self.filterMenuIsVisible {
                self.topLayoutConstraint.constant = 128
                self.bottomLayoutConstraint.constant = -128
                self.filterMenuIsVisible = true
                self.filterView.isHidden = false
            } else {
                self.topLayoutConstraint.constant = 0
                self.bottomLayoutConstraint.constant = 0
                self.filterMenuIsVisible = false
                self.filterView.isHidden = true
            }
            self.tableView.layoutIfNeeded()
        }) { (animationComplete) in
        }
        updateResults()
        tableView.reloadData()
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
    var filteredGearType: String?
    var filteredGear: [Gear]?
    var filteredQuality = "all"
    
    var myAvailableGear: [Gear]?
    var myInnovations: [Innovation]?
    var myLocations: [Location]?
    var numGearRows: Int?
    var currentGear: Gear?
    
    var craftability = Bool()
    var filterMenuIsVisible = false
    
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

        //setupSearch()
        setUpMenuButton()
        setupFilterButton()
        setupFilterArrow()
        
        filterView.isHidden = true
        filterTypesButton.setTitle("All Types", for: .normal)
        
        navigationItem.title = "All Gear"
        filteredGearType = "All"
        
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        mySettlement = dataModel.currentSettlement!
        myAvailableGear = mySettlement!.availableGear
        myStorage = mySettlement!.resourceStorage
        validator.resources = mySettlement!.resourceStorage
        sortedCraftableGear = getCraftableGear()
        sortedUncraftableGear = getUncraftableGear()
        setupFilterButton()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var filtered = [Gear]()
            if isFiltering() {
                filtered = self.filteredSortedGear!
            } else {
                filtered = self.sortedGear!
            }
        return filtered.count
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
            if isFiltering() {
                gear = self.filteredSortedGear![indexPath.row]
            } else {
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
                if isFiltering() {
                    craftDetailVC.gear = self.filteredSortedGear![gearIndex!]
                } else {
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
        if mySettlement!.gearCraftedDict[gear]! > 0 && !checkIfMaxedOut(gear: gear) {
            if #available(iOS 13.0, *) {
                label.textColor = UIColor.label
            } else {
                label.textColor = UIColor.black
                // Fallback on earlier versions
            }
        } else if checkIfMaxedOut(gear: gear) {
            label.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
        } else {
            if #available(iOS 13.0, *) {
                label.textColor = UIColor.secondaryLabel
            } else {
                label.textColor = UIColor.gray
            }
        }
    }
    fileprivate func configureNumCraftableLabel(for cell: UITableViewCell, with gear: Gear, for tag: Int) {
//        let numCraftable = self.validator.checkCraftability(gear: gear) > gear.qtyAvailable ? gear.qtyAvailable:self.validator.checkCraftability(gear: gear) // If numCraftable greater than qty available, use qtyAvailable
        
        let label = cell.viewWithTag(tag) as! UILabel
        var labelString = String()
        
        if validator.checkCraftability(gear:gear) == true && !checkIfMaxedOut(gear: gear) || mySettlement!.overrideEnabled && !checkIfMaxedOut(gear: gear) {
            labelString = "Craftable"
            self.craftability = true
            //label.textColor = UIColor(red: 0.3882, green: 0.6078, blue: 0.2549, alpha: 1.0)
            label.textColor = UIColor.systemGreen
        } else {
            labelString = "Uncraftable"
            self.craftability = false
            //label.textColor = UIColor(red: 0.9373, green: 0.3412, blue: 0, alpha: 1.0)
            label.textColor = UIColor.systemRed
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
            if self.filteredSortedCraftableGear != nil {
                return self.filteredSortedCraftableGear!.sorted(by: { $0.name < $1.name })
            } else {
                return []
            }
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
    func updateResults() {
        if self.filteredGearType == "All" || !filterMenuIsVisible {
            self.sortedGear = myAvailableGear!.sorted(by: { $0.name < $1.name })
            self.navigationItem.title = "All Gear"
            self.setupFilterButton()
        } else {
            let type = convertFilteredTypeToGearType(typeString: self.filteredGearType!)
            self.sortedGear = self.getGearForType(gearType: type, quality: filteredQuality)
            self.navigationItem.title = "Filtered Gear"
            self.setupFilterButton()
            //print("Got back \(type), setting FilteredQuality to \(self.filteredQuality)")
        }
    }
    // Search Controller delegate stuff
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
            filteredSortedGear = self.sortedGear!.filter( {( gear: Gear) -> Bool in
                for affinity in gear.description.affinities {
                    print(String(describing: affinity))
                }
                return gear.name.lowercased().contains(searchText.lowercased())
            })
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
    func getGearForType(gearType: gearType, quality: String) -> [Gear] {
        self.filteredGear = myAvailableGear!.filter { $0.description.type == gearType }
        var furtherFiltered = [Gear]()
        if self.filteredQuality == "craftable" {
            for gear in filteredGear! {
                if sortedCraftableGear!.contains(gear) {
                    furtherFiltered.append(gear)
                }
            }
        } else if self.filteredQuality == "uncraftable" {
            for gear in filteredGear! {
                if sortedUncraftableGear!.contains(gear) {
                    furtherFiltered.append(gear)
                }
            }
        } else {
            furtherFiltered = filteredGear!
        }
        //return filteredGear!.sorted(by: { $0.name < $1.name })
        return furtherFiltered.sorted(by: { $0.name < $1.name })
    }
    func convertFilteredTypeToGearType(typeString: String) -> gearType {
        switch typeString {
        case "all armor":
            self.filteredQuality = "all"
            return .armor
        case "craftable armor":
            self.filteredQuality = "craftable"
            return .armor
        case "uncraftable armor":
            self.filteredQuality = "uncraftable"
            return .armor
        case "all items":
            return .item
        case "craftable items":
            self.filteredQuality = "craftable"
            return .item
        case "uncraftable items":
            self.filteredQuality = "uncraftable"
            return .item
        case "all weapons":
            return .weapon
        case "craftable weapons":
            self.filteredQuality = "craftable"
            return .weapon
        case "uncraftable weapons":
            self.filteredQuality = "uncraftable"
            return .weapon
        default:
            return .item
        }
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
    @objc func setupFilterButton() {
        let filterBtn = UIButton(type: .custom)
        filterBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        if self.filteredGearType == "All" || !filterMenuIsVisible {
            filterBtn.setImage(UIImage(named: "icons8-filter-50-empty"), for: .normal)
        } else {
            filterBtn.setImage(UIImage(named: "icons8-filter-50-filled"), for: .normal)
        }
        filterBtn.addTarget(self, action: #selector(self.showFilterAction(_:)), for: UIControl.Event.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: filterBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    func setupFilterArrow() {
        //let filterArrow = UIButton(type: .custom)
        filterArrow.frame = CGRect(x: 0.0, y: 0.0, width: 10, height: 10)
        filterArrow.addTarget(self, action: #selector(self.filterGearAction(_:)), for: UIControl.Event.touchUpInside)
    }
    func filterGear() {
        let filterGearVC = self.storyboard?.instantiateViewController(withIdentifier: "filterGearVC") as! FilterGearViewController
        filterGearVC.selectedType = self.filteredGearType
        self.present(filterGearVC, animated: true, completion: nil)
        filterGearVC.filteredTypeCompletionHandler = { type in
            self.filteredGearType = type
            if type == "All" {
                self.filterTypesButton.setTitle("All Types", for: .normal)
                self.navigationItem.title = "All Resources"
            } else {
                self.filterTypesButton.setTitle(type.capitalized, for: .normal)
                self.navigationItem.title = "Filtered Gear"
            }
            self.updateResults()
            self.tableView.reloadData()
            return type
        }
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

