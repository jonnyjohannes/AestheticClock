//
//  Preferences.swift
//  AestheticClock
//
//  Created by Jonny on 1/16/23.
//

import Foundation
import ScreenSaver
import OSLog

enum Themes : String, CaseIterable {
    case dark = "Dark Mode"
    case light = "Light Mode"
    
    static var typeName: String {
        return String(describing: self)
    }
}

enum Formats : String, CaseIterable {
    case mod12 = "12 Hour"
    case mod24 = "24 Hour"
    
    static var typeName: String {
        return String(describing: self)
    }
}

class Preferences {
    var defaults: UserDefaults

    init() {
        let identifier = Bundle(for: Preferences.self).bundleIdentifier
        defaults = ScreenSaverDefaults.init(forModuleWithName: identifier!)!
    }

    func setPref(key: String, value: String) {
        do {
            let preference = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            defaults.set(preference, forKey: key)
            defaults.synchronize()
        } catch {
            print("Could not update AestheticClock Preference for key: \(key), with value: \(value)")
        }
    }
    
    func getPref(key: String) -> String? {
        if let pref = defaults.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: pref) as? String
        }
        return nil;
    }
}
