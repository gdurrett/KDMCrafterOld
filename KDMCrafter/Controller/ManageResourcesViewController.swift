//
//  ManageResourcesViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class ManageResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    //@IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView!
 
    @IBAction func settingsButtonAction(_ sender: Any) {
        if let mainVC = self.navigationController?.tabBarController?.parent as? MainViewController {
            mainVC.toggleSideMenu(fromViewController: self)
        }
    }
    
    @IBOutlet weak var settingsButtonOutlet: UIBarButtonItem!
    
    @IBAction func filterResourcesAction(_ sender: Any) {
        filterResources()
    }
    @IBOutlet weak var currentlyFilteredOutlet: UIBarButtonItem!
    
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
    
    var filteredResourceType: String?

    var filterMenuIsVisible = false
    
    var resourceName: String?
    var resourceValue: Int?
    var currentResource: Resource?
    
    var numResourceRows: Int?
    
    var filterActionButton = UIButton()
    var filterButton = UIButton(type: .custom)
    
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
        
        filteredResourceType = "all resource types"
        updateResults()
        
        numResourceRows =  dataModel.currentSettlement!.resourceStorage.count
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUpMenuButton), name: .didToggleOverride, object: nil)
        
//        setupSearch()
                
        setUpMenuButton() // Settings Button leftNav
        setupFilterButton() // Filter Button rightNav
        setUpTabBarIcons() // Along the bottom
        
        navigationItem.title = "All Resources"
        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        updateResults()
        setUpMenuButton()
        setupFilterButton()
        addNavBarImage()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSortedStorage!.count
        } else {
            return sortedStorage!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell

        if #available(iOS 13.0, *) {
            cell.backgroundColor = UIColor.systemBackground
        } else {
            cell.backgroundColor = UIColor.clear
        }
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero

        var key: Resource?
        var value: Int?
        
        if isFiltering() {
            key = filteredSortedStorage![indexPath.row].0
            value = filteredSortedStorage![indexPath.row].1
        } else {
            key = sortedStorage![indexPath.row].0
            value = sortedStorage![indexPath.row].1
        }
        resourceName = key!.name
        resourceValue = value
        
        configureTitle(for: cell, with: resourceName!, with: 3500)
        configureValue(for: cell, with: resourceValue!)
        configureTypes(for: cell, with: key!.type, with: 3575)
        
        cell.stepperOutlet.value = Double(value!)
        cell.stepperOutlet.minimumValue = 0.0
        cell.stepperOutlet.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.resourceCountLabel.text! = "\(value!)"

        cell.stepperOutlet.addTarget(self, action: #selector(stepperChanged(sender:)), for: .valueChanged)
        cell.stepperOutlet.tag = indexPath.row

        return cell
    }
    @objc fileprivate func stepperChanged(sender: UIStepper) {
        var selectedResource: Resource?
        selectedResource = self.sortedStorage![sender.tag].0
        self.myStorage![selectedResource!] = Int(sender.value)
        self.sortedStorage![sender.tag].1 = Int(sender.value)
        self.dataModel.currentSettlement!.resourceStorage[selectedResource!] = Int(sender.value)
        self.updateResults()
        //self.dataModel.writeData()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //(cell as! ResourceTableViewCell).observation = nil
            print("")
        case 1:
            break
        default: break
        }
    }
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
        //searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.showsCancelButton = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        //tableView.tableHeaderView = nil
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    // Search Controller delegate stuff
    //func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    func filterContentForSearchText(_ searchText: String) {

            filteredSortedStorage = self.sortedStorage!.filter( {(resource: Resource, value:Int) -> Bool in
                return resource.name.lowercased().contains(searchText.lowercased())
            })
        tableView.reloadData()
    }
    func updateResults() {
        if self.filteredResourceType == "all resource types" {
            self.sortedStorage = self.dataModel.currentSettlement!.resourceStorage.sorted(by: { $0.key.name < $1.key.name })
            self.navigationItem.title = "All Resources"
        } else {
            let type = convertFilteredTypeToResourceType(typeString: self.filteredResourceType!)
            self.sortedStorage = self.getBasicStorageForType(resourceType: type)
            //self.navigationItem.title = (self.filteredResourceType!.capitalized + " Resources")
            addNavBarImage()
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
    func getBasicStorageForType(resourceType: resourceType) -> [(key: Resource, value: Int)] {
        self.sortedStorage = self.dataModel.currentSettlement!.resourceStorage.sorted(by: { $0.key.name < $1.key.name }) //reset
        return self.sortedStorage!.filter { $0.key.type.contains(resourceType) }
    }
    func convertFilteredTypeToResourceType(typeString: String) -> resourceType {
        switch typeString {
        case "bone":
            return .bone
        case "consumable":
            return .consumable
        case "hide":
            return .hide
        case "iron":
            return .iron
        case "organ":
            return .organ
        case "scrap":
            return .scrap
        case "vermin":
            return .vermin
        default:
            return .any
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
    }

    func setupFilterButton() {
        filterButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        filterButton.addTarget(self, action: #selector(self.filterResourcesAction(_:)), for: UIControl.Event.touchUpInside)
        if self.filteredResourceType == "all resource types" {
            filterButton.setImage(UIImage(named: "icons8-filter-50-empty"), for: .normal)
        } else {
            filterButton.setImage(UIImage(named: "icons8-filter-50-filled"), for: .normal)
        }
        let menuBarItem = UIBarButtonItem(customView: filterButton)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem

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
    func addNavBarImage() {
        var image = UIImage()
        var titleString = String()
        switch self.filteredResourceType {
        case "bone":
            titleString = "Bone Resources"
            image = UIImage(named: "icons8-human-bone-50")!
        case "consumable":
            titleString = "Consumable Resources"
            image = UIImage(named: "icons8-meat-50")!
        case "hide":
            titleString = "Leather Resources"
            image = UIImage(named: "icons8-leather-50")!
        case "iron":
            titleString = "Iron Resources"
            image = UIImage(named: "icons8-iron-ore-60")!
        case "organ":
            titleString = "Organ Resources"
            image = UIImage(named: "icons8-medical-heart-50")!
        case "scrap":
            titleString = "Scrap Resources"
            image = UIImage(named: "icons8-sheet-metal-50")!
        case "vermin":
            titleString = "Vermin Resources"
            image = UIImage(named: "icons8-insect-50")!
        default:
            titleString = ("All Resources")
        }
        let imageView = UIImageView(image: image)
        let filteredTypeIcon = UIBarButtonItem(customView: imageView)
        let currWidth = filteredTypeIcon.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = filteredTypeIcon.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        currentlyFilteredOutlet.customView = filteredTypeIcon.customView
        navigationItem.title = titleString
    }
    func filterResources() {
        let filterResourcesVC = self.storyboard?.instantiateViewController(withIdentifier: "filterResourcesVC") as! FilterResourceViewController
        filterResourcesVC.selectedType = self.filteredResourceType
        self.present(filterResourcesVC, animated: true, completion: nil)
        filterResourcesVC.filteredTypeCompletionHandler = { type in
            self.filteredResourceType = type
//            if type == "All" {
//                self.navigationItem.title = "All Resources"
//            } else {
//                self.navigationItem.title = (type.capitalized + " Resources")
//            }
            self.updateResults()
            return type
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
//filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!)
    }
}
extension Notification.Name {
    static let didToggleOverride = NSNotification.Name(rawValue: "didToggleOverride")
}
