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
//    var pathURL: URL
    var saveData = Data()
    
    var keyStore = NSUbiquitousKeyValueStore()
    let defaults = UserDefaults.standard
    var decodedSettlement: Settlement?
    
    private init() {
        
        if FileManager.default.ubiquityIdentityToken != nil {
            Zephyr.addKeysToBeMonitored(keys: ["settlement"])
            Zephyr.debugEnabled = false
            Zephyr.sync(keys: ["settlement"]) // See if we can get existing defaults from cloud for new device
            let data = defaults.value(forKey: "settlement") as! Data
                            do {
                let settlementData = try PropertyListDecoder().decode(Settlement.self, from: data)
                currentSettlement = settlementData
            } catch {
                print("Couldn't create settlementData: \(error)")
            }
        } else {
            if defaults.value(forKey: "settlement") == nil {
                currentSettlement = Settlement(name: "Death's Respite")
            } else {
                let data = defaults.value(forKey: "settlement") as! Data
                do {
                    let settlementData = try PropertyListDecoder().decode(Settlement.self, from: data)
                    currentSettlement = settlementData
                } catch {
                    print("Couldn't create settlementData: \(error)")
                }
            }
        }
        // KVS Notification Center Setup
        NotificationCenter.default.addObserver(self, selector: #selector(onUbiquitousKeyValueStoreDidChangeExternally(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: keyStore)
    }

    func writeData() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Settlement.plist")
        
        do {
            let data = try encoder.encode(currentSettlement)
            defaults.set(data, forKey: "settlement")
        } catch {
            print(error)
        }
    }
    @objc func onUbiquitousKeyValueStoreDidChangeExternally(notification:Notification)
    {
        print("KVS updated!")
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

