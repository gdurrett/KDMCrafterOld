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
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    var filteredSortedStorage: [(key: Resource, value: Int)]?
    
    var resourceName: String?
    var resourceValue: Int?
    var currentResource: Resource?
    
    var numResourceRows: Int?
    
    let searchController = UISearchController(searchResultsController: nil)
//    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTap(sender:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResourceTableViewCell.nib, forCellReuseIdentifier: ResourceTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        
        mySettlement = dataModel.currentSettlement!
        myStorage = dataModel.currentSettlement!.resourceStorage
        
        sortedStorage = dataModel.currentSettlement!.resourceStorage.sorted(by: { $0.key.name < $1.key.name })
        numResourceRows =  dataModel.currentSettlement!.resourceStorage.count
        
        setupSearch()
//        setupTapGestureRecognizer()
        
        navigationItem.title = "Manage Resources"
        
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        sortedStorage = dataModel.currentSettlement!.resourceStorage.sorted(by: { $0.key.name < $1.key.name })

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSortedStorage!.count
        } else {
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
        cell.stepperOutlet.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.resourceCountLabel.text! = "\(value!)"
        cell.observation = cell.stepperOutlet.observe(\.value, options: [.new]) { (stepper, change) in
            cell.resourceCountLabel.text = "\(Int(change.newValue!))"
            //self.myStorage![key] = Int(change.newValue!)
            self.sortedStorage![indexPath.row].1 = Int(change.newValue!)
            self.myStorage![self.sortedStorage![indexPath.row].0] = Int(change.newValue!)
            self.dataModel.currentSettlement!.resourceStorage[self.sortedStorage![indexPath.row].0] = Int(change.newValue!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            (cell as! ResourceTableViewCell).observation = nil
        case 1:
            break
        //(cell as! LocationTableViewCell).observation = nil
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
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44.0)
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.placeholder = "Search resource names"
        searchController.searchBar.tintColor = UIColor.white
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
        filteredSortedStorage = self.sortedStorage!.filter( {( resource: Resource, value:Int) -> Bool in
            return resource.name.lowercased().contains(searchText.lowercased())
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
//    func setupTapGestureRecognizer() {
//        self.tapGestureRecognizer.numberOfTapsRequired = 1
//        self.tapGestureRecognizer.isEnabled = true
//        self.tapGestureRecognizer.cancelsTouchesInView = false
//        self.tapGestureRecognizer.delegate = self
//        self.view.addGestureRecognizer(tapGestureRecognizer)
//       // self.tableView.addGestureRecognizer(tapGestureRecognizer)
//    }
//    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        if touch.view?.isDescendant(of: self.tableView) == true {
//            return false
//        }
//        return true
//    }
//    @objc func singleTap(sender: UITapGestureRecognizer) {
//
//        print("Tapped?!")
//        self.searchController.searchBar.endEditing(true)
//    }
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
