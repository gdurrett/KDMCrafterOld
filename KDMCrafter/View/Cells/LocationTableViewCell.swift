//
//  LocationTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 2/5/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol LocationTableViewCellDelegate: class {
    func tappedBuildButton(cell: LocationTableViewCell)
}

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var buildButton: UIButton!
    @IBAction func buildButtonTapped(_ sender: UIButton) {
        cellDelegate?.tappedBuildButton(cell: self)
    }
    
    weak var cellDelegate: LocationTableViewCellDelegate?
    
    
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
