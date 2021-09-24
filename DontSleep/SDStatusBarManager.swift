//
//  ViewController.swift
//  DontSleep
//
//  Created by DengFeng.Su on 2019/5/30.
//  Copyright © 2019 DengFeng.Su. All rights reserved.
//

import Cocoa
import IOKit
import IOKit.pwr_mgt

class SDStatusBarManager: NSObject {
    
    static let shared = SDStatusBarManager()
    
    private let popover = NSPopover()
    private let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
    var assertionID: IOPMAssertionID = 0
    var didOpen: Bool = false {
        didSet {
            statusItem.button?.image = NSImage(named: didOpen ? "dont_sleep":"sleep")
        }
    }
    
    override init() {
        super.init()
        
        statusItem.button?.target = self
        statusItem.button?.action = #selector(changeScreenSleepState(button:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        popover.contentViewController = SDPopViewController()
        addGlobalMonitor()
    }
    
    func configure() {
        
        statusItem.button?.image = NSImage(named: "sleep")
    }
    
    func clear() {
        enableScreenSleep()
    }
}

extension SDStatusBarManager {

    @objc private func changeScreenSleepState(button: NSStatusBarButton) {
        
        let event = NSApp.currentEvent!
        if .rightMouseUp == event.type {
            
            if popover.isShown {
                popover.close()
            } else {
                popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
            }
            
        } else {
            
            if didOpen {
                didOpen = !enableScreenSleep()
            } else {
                didOpen = disableScreenSleep("user operate")
            }
        }
    }
    
    @discardableResult
    func disableScreenSleep(_ reason: String = "Unknown reason") -> Bool {
        guard !didOpen else {
            return false
        }
        
        return kIOReturnSuccess == IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                               IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                               reason as CFString,
                                                               &assertionID)
    }

    @discardableResult
    func enableScreenSleep() -> Bool {
        guard didOpen else {
            return false
        }
        
        return kIOReturnSuccess == IOPMAssertionRelease(assertionID)
    }
    
    private func addGlobalMonitor() {
        
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] (event) in
            
            guard let weakSelf = self else { return }
            
            if weakSelf.popover.isShown {
                weakSelf.popover.close()
            }
        }
    }
}

