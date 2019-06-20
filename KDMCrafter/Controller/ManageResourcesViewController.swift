//
//  ManageResourcesViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class ManageResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func segmentedControlAction(_ sender: Any) {
        updateSearchResults(for: self.searchController)
        tableView.reloadData()
    }
    @IBAction func settingsButtonAction(_ sender: Any) {
        if let mainVC = self.navigationController?.tabBarController?.parent as? MainViewController {
            mainVC.toggleSideMenu(fromViewController: self)
        }
    }
    
    @IBOutlet weak var settingsButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var filteredSortedStorage: [(key: Resource, value: Int)]?
    var sortedBoneStorage: [(key: Resource, value: Int)]?
    var filteredSortedBoneStorage: [(key: Resource, value: Int)]?
    var sortedConsStorage: [(key: Resource, value: Int)]?
    var filteredSortedConsStorage: [(key: Resource, value: Int)]?
    var sortedHideStorage: [(key: Resource, value: Int)]?
    var filteredSortedHideStorage: [(key: Resource, value: Int)]?
    var sortedOrganStorage: [(key: Resource, value: Int)]?
    var filteredSortedOrganStorage: [(key: Resource, value: Int)]?

    //var settingsVC: SettingsViewController!
    
    var resourceName: String?
    var resourceValue: Int?
    var currentResource: Resource?
    
    var numResourceRows: Int?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        mySettlement = dataModel.currentSettlement!
        myStorage = dataModel.currentSettlement!.resourceStorage
        
        updateStorage()
        
        numResourceRows =  dataModel.currentSettlement!.resourceStorage.count
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUpMenuButton), name: .didToggleOverride, object: nil)
        
        setupSearch()
        setUpMenuButton()
        setUpTabBarIcons()
        
        navigationItem.title = "Manage Resources"
        
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateStorage()
        setUpMenuButton()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segmentedControlOutlet.selectedSegmentIndex) {
        case 0:
            if isFiltering() {
                return filteredSortedStorage!.count
            } else {
                return numResourceRows!
            }
        case 1:
            if isFiltering() {
                return filteredSortedBoneStorage!.count
            } else {
                return sortedBoneStorage!.count
            }
        case 2:
            if isFiltering() {
                return filteredSortedConsStorage!.count
            } else {
                return sortedConsStorage!.count
            }
        case 3:
            if isFiltering() {
                return filteredSortedHideStorage!.count
            } else {
                return sortedHideStorage!.count
            }
        case 4:
            if isFiltering() {
                return filteredSortedOrganStorage!.count
            } else {
                return sortedOrganStorage!.count
            }
        default:
            return numResourceRows!
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero

        var key: Resource?
        var value: Int?
        
        switch(segmentedControlOutlet.selectedSegmentIndex) {
        case 0:
            if isFiltering() {
                key = filteredSortedStorage![indexPath.row].0
                value = filteredSortedStorage![indexPath.row].1
            } else {
                key = sortedStorage![indexPath.row].0
                value = sortedStorage![indexPath.row].1
            }
        case 1:
            if isFiltering() {
                key = filteredSortedBoneStorage![indexPath.row].0
                value = filteredSortedBoneStorage![indexPath.row].1
            } else {
                key = sortedBoneStorage![indexPath.row].0
                value = sortedBoneStorage![indexPath.row].1
            }
        case 2:
            if isFiltering() {
                key = filteredSortedConsStorage![indexPath.row].0
                value = filteredSortedConsStorage![indexPath.row].1
            } else {
                key = sortedConsStorage![indexPath.row].0
                value = sortedConsStorage![indexPath.row].1
            }
        case 3:
            if isFiltering() {
                key = filteredSortedHideStorage![indexPath.row].0
                value = filteredSortedHideStorage![indexPath.row].1
            } else {
                key = sortedHideStorage![indexPath.row].0
                value = sortedHideStorage![indexPath.row].1
            }
        case 4:
            if isFiltering() {
                key = filteredSortedOrganStorage![indexPath.row].0
                value = filteredSortedOrganStorage![indexPath.row].1
            } else {
                key = sortedOrganStorage![indexPath.row].0
                value = sortedOrganStorage![indexPath.row].1
            }
        default:
            key = sortedStorage![indexPath.row].0
            value = sortedStorage![indexPath.row].1
        }

        resourceName = key!.name
        resourceValue = value
        
        configureTitle(for: cell, with: resourceName!, with: 3500)
        configureValue(for: cell, with: resourceValue!)
        configureTypes(for: cell, with: key!.type, with: 3575)
        
        cell.stepperOutlet.value = Double(value!)
        cell.stepperOutlet.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.resourceCountLabel.text! = "\(value!)"
        cell.observation = cell.stepperOutlet.observe(\.value, options: [.new]) { (stepper, change) in
            cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            var selectedResource: Resource?
            switch(self.segmentedControlOutlet.selectedSegmentIndex) {
            case 0:
                if self.isFiltering() {
                    selectedResource = self.filteredSortedStorage![indexPath.row].0
                    self.filteredSortedStorage![indexPath.row].1 = Int(change.newValue!)
                } else {
                    selectedResource = self.sortedStorage![indexPath.row].0
                    self.sortedStorage![indexPath.row].1 = Int(change.newValue!)
                }
            case 1:
                if self.isFiltering() {
                    selectedResource = self.filteredSortedBoneStorage![indexPath.row].0
                    self.filteredSortedBoneStorage![indexPath.row].1 = Int(change.newValue!)
                } else {
                    selectedResource = self.sortedBoneStorage![indexPath.row].0
                    self.sortedBoneStorage![indexPath.row].1 = Int(change.newValue!)
                }
            case 2:
                if self.isFiltering() {
                    selectedResource = self.filteredSortedConsStorage![indexPath.row].0
                    self.filteredSortedConsStorage![indexPath.row].1 = Int(change.newValue!)
                } else {
                    selectedResource = self.sortedConsStorage![indexPath.row].0
                    self.sortedConsStorage![indexPath.row].1 = Int(change.newValue!)
                }
            case 3:
                if self.isFiltering() {
                    selectedResource = self.filteredSortedHideStorage![indexPath.row].0
                    self.filteredSortedHideStorage![indexPath.row].1 = Int(change.newValue!)
                } else {
                    selectedResource = self.sortedHideStorage![indexPath.row].0
                    self.sortedHideStorage![indexPath.row].1 = Int(change.newValue!)
                }
            case 4:
                if self.isFiltering() {
                    selectedResource = self.filteredSortedOrganStorage![indexPath.row].0
                    self.filteredSortedOrganStorage![indexPath.row].1 = Int(change.newValue!)
                } else {
                    selectedResource = self.sortedOrganStorage![indexPath.row].0
                    self.sortedOrganStorage![indexPath.row].1 = Int(change.newValue!)
                }
            default:
                selectedResource = self.sortedStorage![indexPath.row].0
            }
            //self.sortedStorage![indexPath.row].1 = Int(change.newValue!)
            //self.myStorage![self.sortedStorage![indexPath.row].0] = Int(change.newValue!)
            self.myStorage![selectedResource!] = Int(change.newValue!)
            self.dataModel.currentSettlement!.resourceStorage[selectedResource!] = Int(change.newValue!)
            self.dataModel.writeData()
            self.updateStorage()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            (cell as! ResourceTableViewCell).observation = nil
        case 1:
            break
        default: break
        }
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return " Manage Resources"
//    }
    fileprivate func configureTitle(for cell: UITableViewCell, with name: String, with tag: Int) {
        let label = cell.viewWithTag(tag) as! UILabel
        label.text = name
        label.sizeToFit()
    }
    fileprivate func configureValue(for cell: UITableViewCell, with value: Int) {
        let label = cell.viewWithTag(3550) as! UILabel
        label.text = String(value)
        label.sizeToFit()
    }
    fileprivate func configureTypes(for cell: UITableViewCell, with types: [resourceType], with tag: Int) {
        var typesString = String()
        let label = cell.viewWithTag(3575) as! UILabel
        for type in types {
            if type == types.last! {
                typesString.append("\(type.rawValue)")
            } else {
                typesString.append("\(type.rawValue), ")
            }
        }
        label.text! = typesString
    }
    
    fileprivate func setupSearch() {
        //Set up searchController stuff
        //searchController.searchBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44.0)
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.placeholder = "Search resource names"
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
            filteredSortedStorage = self.sortedStorage!.filter( {(resource: Resource, value:Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        case 1:
            //let boneStorage = self.sortedStorage!.filter { $0.key.type.contains(.bone) }
            let boneStorage = getBasicStorageForType(resourceType: .bone)
            filteredSortedBoneStorage = boneStorage.filter( {(resource: Resource, value: Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        case 2:
            //let consStorage = self.sortedStorage!.filter { $0.key.type.contains(.consumable) }
            let consStorage = getBasicStorageForType(resourceType: .consumable)
            filteredSortedConsStorage = consStorage.filter( {(resource: Resource, value: Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        case 3:
            //let hideStorage = self.sortedStorage!.filter { $0.key.type.contains(.hide) }
            let hideStorage = getBasicStorageForType(resourceType: .hide)
            filteredSortedHideStorage = hideStorage.filter( {(resource: Resource, value: Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        case 4:
            //let organStorage = self.sortedStorage!.filter { $0.key.type.contains(.organ) }
            let organStorage = getBasicStorageForType(resourceType: .organ)
            filteredSortedOrganStorage = organStorage.filter( {(resource: Resource, value: Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        default:
            filteredSortedStorage = self.sortedStorage!.filter( {(resource: Resource, value:Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        }

        tableView.reloadData()
    }
    func updateStorage() {
        self.sortedStorage = self.dataModel.currentSettlement!.resourceStorage.sorted(by: { $0.key.name < $1.key.name })
        self.sortedBoneStorage = self.getBasicStorageForType(resourceType: .bone)
        self.sortedConsStorage = self.getBasicStorageForType(resourceType: .consumable)
        self.sortedHideStorage = self.getBasicStorageForType(resourceType: .hide)
        self.sortedOrganStorage = self.getBasicStorageForType(resourceType: .organ)
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    func getBasicStorageForType(resourceType: resourceType) -> [(key: Resource, value: Int)] {
        return self.sortedStorage!.filter { $0.key.type.contains(resourceType) }
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
    }
    
    func setUpTabBarIcons() {
        if let tabBarVC = self.navigationController?.parent as? UITabBarController {
            let manageTabItem = tabBarVC.tabBar.items![0]
            manageTabItem.image = UIImage(named: "icons8-drawstring-bag-24")
            let craftTabItem = tabBarVC.tabBar.items![1]
            craftTabItem.image = UIImage(named: "icons8-metal-26")
            let buildTabItem = tabBarVC.tabBar.items![2]
            buildTabItem.image = UIImage(named: "icons8-home-24")
            let innovateTabItem = tabBarVC.tabBar.items![3]
            innovateTabItem.image = UIImage(named: "icons8-idea-30")
        }
    }
}

extension ManageResourcesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
extension ManageResourcesViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
extension Notification.Name {
    static let didToggleOverride = NSNotification.Name(rawValue: "didToggleOverride")
}
