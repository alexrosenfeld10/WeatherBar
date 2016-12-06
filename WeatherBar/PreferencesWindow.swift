//
//  PreferencesWindow.swift
//  WeatherBar
//
//  Created by Alex Rosenfeld on 12/5/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var cityTextField: NSTextField!
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName: String!{
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        let defaults = UserDefaults.standard
        let city = defaults.string(forKey: "city") ?? DEFAULT_CITY
        cityTextField.stringValue = city
    }
    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(cityTextField.stringValue, forKey: "city")
        delegate?.preferencesDidUpdate()
    }
}
