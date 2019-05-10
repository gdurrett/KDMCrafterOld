//
//  MainViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 5/10/19.
//  Copyright © 2019 AppHazard Productions. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var settingsMenuContainerView: UIView!
    @IBOutlet weak var settingsMenuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var menuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsMenuViewLeadingConstraint.constant = 0 - self.settingsMenuContainerView.frame.size.width
        // Do any additional setup after loading the view.
    }
    
    @objc func toggleSideMenu(fromViewController: UIViewController) {
        if (menuVisible) {
            UIView.animate(withDuration: 0.5, animations: {
                // hide settings menu to left
                self.settingsMenuViewLeadingConstraint.constant = 0 - self.settingsMenuContainerView.frame.size.width
                // move content view (tab bar controller) to original position
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                // move the settings menu to the right to show it
                self.settingsMenuViewLeadingConstraint.constant = 0
                // move the content view (tab bar controller) to the right
                self.contentViewLeadingConstraint.constant = self.settingsMenuContainerView.frame.size.width
                self.view.layoutIfNeeded()
                })
        }
        
        menuVisible = !menuVisible
    }

}
