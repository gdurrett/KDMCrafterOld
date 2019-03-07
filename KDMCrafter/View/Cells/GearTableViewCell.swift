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
    func tappedArchiveButton(cell: GearTableViewCell)
}

class GearTableViewCell: UITableViewCell {

    @IBOutlet weak var heightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint2: NSLayoutConstraint!
    
    @IBOutlet weak var gearName: UILabel!
    @IBOutlet weak var craftButton: UIButton!
    @IBAction func craftAction(_ sender: Any) {
        cellDelegate?.tappedCraftButton(cell: self)
    }
    @IBOutlet weak var archiveButton: UIButton!
    
    @IBAction func archiveAction(_ sender: Any) {
        cellDelegate?.tappedArchiveButton(cell: self)
    }
    @IBOutlet weak var qtyAvailableLabel: UILabel!
    
    var isExpanded:Bool = false {
        didSet {
            if !isExpanded {
                self.heightConstraint1.constant = 0.0
                self.heightConstraint2.constant = 0.0
            } else {
                self.heightConstraint1.constant = 65
                self.heightConstraint2.constant = 85
            }
        }
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
