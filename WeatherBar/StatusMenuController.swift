//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Alex Rosenfeld on 12/4/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

let DEFAULT_CITY = "BOSTON"

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    
    //Outlets
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var weatherView: WeatherView!
    
    //vars
    var weatherMenuItem: NSMenuItem!
    var updateMenuItem: NSMenuItem!
    var preferencesWindow: PreferencesWindow!
    
    //Actions
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        updateWeather()
    }

    @IBAction func weatherClicked(_ sender: NSMenuItem) {
        NSLog("weather clicked")
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
        
    }
    
    //Variables
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength);
    let weatherAPI = WeatherAPI()
    
    /*
     * Functions
     */
    
    //override default functions
    override func awakeFromNib() {
        statusItem.menu = statusMenu
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        weatherMenuItem = statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self

        updateWeather()
    }
    
    //other functions
    func updateWeather(){
        let defaults = UserDefaults.standard
        let city = defaults.string(forKey: "city") ?? DEFAULT_CITY
        
        weatherAPI.fetchWeather(query: city) { weather in
            self.weatherView.update(weather: weather)
            
        }
    }
    
    func preferencesDidUpdate() {
        updateWeather()
    }
}
