//
//  resourceTypeCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 8/26/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class ResourceTypeCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
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
        accessoryType = selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        // Configure the view for the selected state
    }
    
}
