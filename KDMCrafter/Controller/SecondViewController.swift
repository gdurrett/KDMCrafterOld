//
//  SecondViewController.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for resource in DataModel.sharedInstance.currentSettlement!.resourceStorage {
            print(resource.key, resource.value)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        for resource in DataModel.sharedInstance.currentSettlement!.resourceStorage {
            print(resource.key, resource.value)
        }    }

}

