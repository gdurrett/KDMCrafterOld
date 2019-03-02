//
//  GearTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/27/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol GearTableViewCellDelegate: class {
    func tappedCraftButton(cell: GearTableViewCell)
}

class GearTableViewCell: UITableViewCell {

    @IBOutlet weak var gearName: UILabel!
    @IBOutlet weak var craftButton: UIButton!
    @IBAction func craftAction(_ sender: Any) {
        
    }
    
    weak var cellDelegate: GearTableViewCellDelegate?
    
    
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
