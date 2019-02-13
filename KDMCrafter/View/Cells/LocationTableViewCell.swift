//
//  LocationTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/5/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

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
