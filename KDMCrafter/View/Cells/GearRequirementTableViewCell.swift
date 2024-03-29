//
//  GearRequirementTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/13/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class GearRequirementTableViewCell: UITableViewCell {

    @IBOutlet weak var requiredTypeLabel: UILabel!
    @IBOutlet weak var requiredQtyLabel: UILabel!
    @IBOutlet weak var qtyAvailableLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    
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
