//
//  SettingsButtonTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 10/8/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol SettingsButtonTableViewCellDelegate: class {
    func tappedResetButton(cell: SettingsButtonTableViewCell)
}

class SettingsButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsNameLabelOutlet: UILabel!
    @IBOutlet weak var settingsResetButtonOutlet: UIButton!
    @IBAction func settingsResetButtonAction(_ sender: Any) {
        cellDelegate?.tappedResetButton(cell: self)
    }
    
    weak var cellDelegate: SettingsButtonTableViewCellDelegate?
    
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
