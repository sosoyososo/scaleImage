//
//  AppDelegate.swift
//  ImageScale
//
//  Created by karsa on 2017/8/29.
//  Copyright © 2017年 karsa. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showNewWindow(_ sender : Any?) {        
        if let window = NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainWindow") as? NSWindowController {
            window.showWindow(nil)            
        }
    }
}

