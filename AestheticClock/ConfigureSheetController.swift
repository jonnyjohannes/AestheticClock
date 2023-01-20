//
//  ConfigureSheetController.swift
//  AestheticClock
//
//  Created by Jonny on 1/16/23.
//

import Cocoa

class ConfigureSheetController : NSObject {
    
    var preferences = Preferences()
    
    override init() {
        super.init()
        let bundle = Bundle(for: ConfigureSheetController.self)
        bundle.loadNibNamed(NSNib.Name(rawValue: "ConfigureSheet"), owner: self, topLevelObjects: nil)

        themeSelection.addItems(withTitles: Themes.allCases.map({ $0.rawValue }))
        themeSelection.selectItem(withTitle: preferences.getPref(key: Themes.typeName) ?? Themes.dark.rawValue)
        formatSelection.addItems(withTitles: Formats.allCases.map({ $0.rawValue }))
        formatSelection.selectItem(withTitle: preferences.getPref(key: Formats.typeName) ?? Formats.mod24.rawValue)
    }
    
    @IBOutlet weak var themeSelection: NSPopUpButton!
    @IBAction func updateTheme(_ sender: Any) {
        preferences.setPref(key: Themes.typeName, value: themeSelection.selectedItem?.title ?? Themes.dark.rawValue)

    }
    
    @IBOutlet weak var formatSelection: NSPopUpButton!
    @IBAction func updateFormat(_ sender: Any) {
        preferences.setPref(key: Formats.typeName, value: formatSelection.selectedItem?.title ?? Formats.mod24.rawValue)
    }

    @IBOutlet weak var window: NSWindow!
    @IBAction func closeButtonClicked(_ sender: Any) {
        window?.sheetParent?.endSheet(window!)
    }
}
