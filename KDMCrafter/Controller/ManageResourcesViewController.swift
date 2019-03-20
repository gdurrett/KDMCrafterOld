//
//  ManageResourcesViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class ManageResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let dataModel = DataModel.sharedInstance
    
    var mySettlement: Settlement?
    var myStorage: [Resource:Int]?
    var sortedStorage: [(key: Resource, value: Int)]?
    
    var resourceName: String?
    var resourceValue: Int?
    var currentResource: Resource?
    
    var numResourceRows: Int?
    
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
                
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        sortedStorage = dataModel.currentSettlement!.resourceStorage.sorted(by: { $0.key.name < $1.key.name })

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numResourceRows!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero

        let key = sortedStorage![indexPath.row].0
        let value = sortedStorage![indexPath.row].1
        
        resourceName = key.name
        resourceValue = value
        
        configureTitle(for: cell, with: resourceName!, with: 3500)
        configureValue(for: cell, with: resourceValue!)
        configureTypes(for: cell, with: key.type, with: 3575)
        
        cell.stepperOutlet.value = Double(value)
        cell.stepperOutlet.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.resourceCountLabel.text! = "\(value)"
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " Manage Resources"
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
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let boldString = NSMutableAttributedString.makeWithBold(text: text)
        append(boldString)
        
        return self
    }
    @discardableResult func boldCenter(_ text: String) -> NSMutableAttributedString {
        let boldCenterString = NSMutableAttributedString.makeWithBoldCenter(text: text)
        append(boldCenterString)
        
        return self
    }
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString.makeWithNormal(text: text)
        append(normal)
        
        return self
    }
}
extension NSAttributedString {
    
    public static func makeWithBold(text: String) -> NSMutableAttributedString {
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        return NSMutableAttributedString(string: text, attributes:attrs)
    }
    public static func makeWithNormal(text: String) -> NSMutableAttributedString {
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)]
        return NSMutableAttributedString(string: text, attributes:attrs)
    }
    public static func makeWithBoldCenter(text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes:attrs)

    }
}

