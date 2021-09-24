//
//  AppDelegate.swift
//  DontSleep
//
//  Created by DengFeng.Su on 2019/5/30.
//  Copyright © 2019 DengFeng.Su. All rights reserved.
//

import Cocoa

//@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApp.activate(ignoringOtherApps: true)

        SDStatusBarManager.shared.configure()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        SDStatusBarManager.shared.clear()
    }
}
