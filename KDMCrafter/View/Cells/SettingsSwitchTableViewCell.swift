//
//  SettingsSwitchTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 4/4/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol SettingsSwitchTableViewCellDelegate: class {
    func tappedOverrideButton(cell: SettingsSwitchTableViewCell)
}

class SettingsSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsNameLabel: UILabel!
    @IBAction func settingsOverrideSwitch(_ sender: Any) {
        cellDelegate?.tappedOverrideButton(cell: self)
    }
    @IBOutlet weak var settingsOverrideSwitchOutlet: UISwitch!

    weak var cellDelegate: SettingsSwitchTableViewCellDelegate?
    
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
