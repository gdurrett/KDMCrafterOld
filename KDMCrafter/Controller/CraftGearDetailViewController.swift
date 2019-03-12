//
//  CraftGearDetailViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 3/7/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class CraftGearDetailViewController: UIViewController {
    
    @IBOutlet weak var gearTypeLeftLabel: UILabel!
    @IBOutlet weak var gearStatsLeftLabel: UILabel!
    @IBOutlet weak var gearStatsLabel: UILabel!
    @IBOutlet weak var gearTypeLabel: UILabel!
    @IBOutlet weak var gearInfoTextView: UITextView!
    var gear: Gear?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = gear!.name
        
        gearInfoTextView.textContainerInset = UIEdgeInsets.zero
        gearInfoTextView.textContainer.lineFragmentPadding = 0
        gearStatsLeftLabel.text = "Stats\n\n"
        gearTypeLeftLabel.text = "\n\nType"
        var stats: (String)
        gearTypeLabel.text = ("\n\n\(gear!.description.type.rawValue)")
        if gear!.description.type == .armor {
            stats = gear!.description.stats.armorAttributes()
        } else if gear!.description.type == .weapon {
            stats = gear!.description.stats.weaponAttributes()
        } else {
            stats = "N/A\n\n"
        }
        gearStatsLabel.text = stats
        gearInfoTextView.attributedText = gear!.description.detailText
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
