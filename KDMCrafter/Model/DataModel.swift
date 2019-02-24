//
//  DataModel.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation

class DataModel {
    
    static var sharedInstance = DataModel()
    var currentSettlement: Settlement?
    var observation: NSKeyValueObservation?

    
    private init() {
        
        // FileManager stuff
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("Settlements.plist")?.path
        let fileManager = FileManager.default
        
        // If we have a save file, us it, otherwise create a new storage
        if fileManager.fileExists(atPath: filePath!) {
            // Load code
        } else {
            // Set currentSettlement to loaded file (later!)
            // Create new settlement
            currentSettlement = Settlement(name: "Death's Respite")

        }
    }
}

