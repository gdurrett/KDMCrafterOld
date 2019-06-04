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
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
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
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        // how much distance have user finger moved since touch start (in X and Y)
        let translation = recognizer.translation(in: self.view)
        
        if(menuVisible){
            // user finger moved to left before ending drag
            if(translation.x < 0){
                // toggle side menu (to fully hide it)
                self.toggleSideMenu(fromViewController: self)
            }
        } else {
            // user finger moved to right and more than 100pt
            if(translation.x > 100.0){
                // toggle side menu (to fully show it)
                self.toggleSideMenu(fromViewController: self)
            } else {
                // user finger moved to right but too less
                // hide back the side menu (with animation)
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.settingsMenuViewLeadingConstraint.constant = 0 - self.settingsMenuContainerView.frame.size.width
                    self.contentViewLeadingConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        // early return so code below won't get executed
        return
        
        if (!menuVisible && translation.x > 0.0 && translation.x <= self.settingsMenuContainerView.frame.size.width) {
            self.settingsMenuViewLeadingConstraint.constant = 0 - self.settingsMenuContainerView.frame.size.width + translation.x
            self.contentViewLeadingConstraint.constant = 0 + translation.x
        }
        
        if (menuVisible && translation.x < 0.0 && translation.x >= 0 - self.settingsMenuContainerView.frame.size.width) {
            self.settingsMenuViewLeadingConstraint.constant = 0 + translation.x
            self.contentViewLeadingConstraint.constant = self.settingsMenuContainerView.frame.size.width + translation.x
        }
    }
}
