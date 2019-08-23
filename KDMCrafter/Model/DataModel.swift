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
    var currentSettlement: Settlement!
    var observation: NSKeyValueObservation?
    var pathURL: URL
    var saveData = Data()
    
    var keyStore = NSUbiquitousKeyValueStore()
    

    private init() {
        pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Settlement.plist")
        let xml = FileManager.default.contents(atPath: pathURL.path)
        if xml != nil {
            let _currentSettlement = try? PropertyListDecoder().decode(Settlement.self, from: xml!)
            currentSettlement = _currentSettlement!
            print(pathURL)
        } else {
            print("Couldn't find \(pathURL)")
            currentSettlement = Settlement(name: "Death's Respite")
        }
    }

    func writeData() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Settlement.plist")
        
        do {
            let data = try encoder.encode(currentSettlement)
            try data.write(to: path)
            dump(path)
        } catch {
            print(error)
        }
        // Test KVS cloud storage
        keyStore.set(currentSettlement.name, forKey: "settlementName")
        keyStore.synchronize()
        print(keyStore.string(forKey: "Paint")!)
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
extension UISearchBar {
    
    var textField: UITextField? {
        return subviews.map { $0.subviews.first(where: { $0 is UITextInputTraits}) as? UITextField }
            .compactMap { $0 }
            .first
    }
}
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple , range: range)
        self.attributedText = attribute
    }
}

