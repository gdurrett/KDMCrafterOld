//
//  ResourceTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 1/25/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    @IBOutlet weak var resourceLabel: UILabel!
        
    @IBOutlet weak var resourceCountLabel: UILabel!
    
    @IBOutlet weak var providedTypesLabel: UILabel!
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        //resourceCountLabel.text = "\(Int(sender.value))" // Temporary!
    }
    //var stepperVal = Int()
    var observation: NSKeyValueObservation?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
