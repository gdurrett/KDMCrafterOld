//
//  DataModel.swift
//  KDMCrafter
//
//  Created by Greg Durrett on 12/14/18.
//  Copyright © 2018 AppHazard Productions. All rights reserved.
//

import Foundation
import UIKit // For extensions to NSMutableAttributedString

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
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let boldString = NSMutableAttributedString.makeWithBold(text: text)
        append(boldString)
        
        return self
    }
    @discardableResult func boldCenter(_ text: String) -> NSMutableAttributedString {
        let boldCenterString = NSMutableAttributedString.makeWithBoldCenter(text: text)
        append(boldCenterString)
        
        return self
    }
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString.makeWithNormal(text: text)
        append(normal)
        
        return self
    }
}
extension NSAttributedString {
    
    public static func makeWithBold(text: String) -> NSMutableAttributedString {
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        return NSMutableAttributedString(string: text, attributes:attrs)
    }
    public static func makeWithNormal(text: String) -> NSMutableAttributedString {
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)]
        return NSMutableAttributedString(string: text, attributes:attrs)
    }
    public static func makeWithBoldCenter(text: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes:attrs)
        
    }
}
class WrappedString: Codable {
    let attributedString : NSMutableAttributedString
    
    init(nsAttributedString : NSMutableAttributedString) {
        self.attributedString = nsAttributedString
    }
    
    public required init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        let base64String = try singleContainer.decode(String.self)
        guard let data = Data(base64Encoded: base64String) else { throw DecodingError.dataCorruptedError(in: singleContainer, debugDescription: "String is not a base64 encoded string") }
        guard let attributedString = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSMutableAttributedString.self], from: data) as? NSMutableAttributedString else { throw DecodingError.dataCorruptedError(in: singleContainer, debugDescription: "Data is not NSMutableAttributedString") }
        self.attributedString = attributedString
    }
    
    func encode(to encoder: Encoder) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: false)
        var singleContainer = encoder.singleValueContainer()
        try singleContainer.encode(data.base64EncodedString())
    }
}
