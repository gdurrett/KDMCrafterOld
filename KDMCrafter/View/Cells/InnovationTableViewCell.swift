//
//  InnovationTableViewCell.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/5/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

protocol InnovationTableViewCellDelegate: class {
    func tappedAddInnovationButton(cell: InnovationTableViewCell)
}
class InnovationTableViewCell: UITableViewCell {
    @IBOutlet weak var innovationTitleLabel: UILabel!
    
    @IBAction func addInnovationButtonAction(_ sender: UIButton) {
        cellDelegate?.tappedAddInnovationButton(cell: self)
    }
    @IBOutlet weak var addInnovationButton: UIButton!
    
    weak var cellDelegate: InnovationTableViewCellDelegate?
    
    
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
