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
    let timer: SDTimer = SDTimer()

    let minLength: CGFloat = 22
    let maxLength: CGFloat = 75
    
    lazy var extLength: CGFloat = {
        if #available(macOS 10.16, *) {
            return 0
        } else {
            return 20
        }
    }()
    var remaining: Int = 0 {
        didSet {
            updateStatusItemTimeLabel()
        }
    }
    var observer: Any?
    

    private lazy var manager: SDBumSteadyManager = {
        var res = SDBumSteadyManager()
        return res
    }()
        
    private lazy var statusItem: NSStatusItem =  {
        
        var res = NSStatusBar.system.statusItem(withLength: minLength + extLength)
        if let button = res.button, let cell = button.cell as? NSButtonCell {
            button.imagePosition = .imageLeft
            button.bezelStyle = .texturedRounded
            button.isBordered = true
            button.imageHugsTitle = true
            button.wantsLayer = true
            button.layer?.backgroundColor = NSColor.clear.cgColor
//            button.isTransparent = true
            button.contentTintColor = NSColor.white
            
            cell.backgroundStyle = .normal
            cell.backgroundColor = NSColor.clear
        }
        res.menu = menu
        return res
    }()
    
    private lazy var menu: NSMenu = {
        
        var res = NSMenu()
        res.autoenablesItems = false
        
        let item1 = NSMenuItem(title: SDLocalized.string("rest ten minutes"), action: #selector(switchScreenSleepState(sender:)), keyEquivalent: "")
        item1.tag = 10*60
        let item2 = NSMenuItem(title: SDLocalized.string("one hour break"), action: #selector(switchScreenSleepState(sender:)), keyEquivalent: "")
        item2.tag = 60*60
        
        res.addItem(switchItem)
        res.addItem(item1)
        res.addItem(item2)
        res.addItem(.separator())
        res.addItem(showTimeSwitchItem)
        res.addItem(withTitle: SDLocalized.string("novice guide"), action: #selector(showNoviceGuide), keyEquivalent: "")
        res.addItem(.separator())
        res.addItem(withTitle: SDLocalized.string("quit"), action: #selector(quit), keyEquivalent: "")
        
        for item in res.items {
            item.target = self
            item.isEnabled = true
        }
        
        return res
    }()
    
    private lazy var switchItem: NSMenuItem = {
        let item = NSMenuItem(title: SDLocalized.string("rest a while"), action: #selector(switchScreenSleepState(sender:)), keyEquivalent: "")
        item.tag = 0
        return item
    }()
    
    private lazy var showTimeSwitchItem: NSMenuItem = {
        let item = NSMenuItem(title: SDLocalized.string("show time on status bar"), action: #selector(changeShowTimeState), keyEquivalent: "")
        item.state = SDConfigure.showTimeOnStatusBar ? .on:.off
        return item
    }()
    
    var assertionID: IOPMAssertionID = 0
    var didOpen: Bool = false {
        didSet {
            statusItem.button?.image = NSImage(named: didOpen ? "sun":"moon")
            switchItem.title = SDLocalized.string(didOpen ? "unmake rest":"rest a while")
            updateStatusItemTimeLabel()
        }
    }
    
    override init() {
        super.init()
//        addGlobalMonitor()
        addNotification()
    }
    
    func configure() {
        statusItem.button?.image = NSImage(named: "moon")
    }
    
    func clear() {
        manager.updateBumSteadyStatus(.off, reason: "Unmake Rest")
    }
    
    deinit {
        clear()
    }
}

extension SDStatusBarManager {
    
    @objc private func changeShowTimeState() {
        SDConfigure.showTimeOnStatusBar = !SDConfigure.showTimeOnStatusBar
        showTimeSwitchItem.state = SDConfigure.showTimeOnStatusBar ? .on:.off
        updateStatusItemTimeLabel()
    }
    
    @objc private func showNoviceGuide() {
        if SDNoviceGuideViewController.isShow {
            return
        }
        SDNoviceGuideViewController.show()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }

    @objc private func switchScreenSleepState(sender: NSMenuItem) {
        
        if 0 == sender.tag, didOpen {
            disableScreenSleep()
        } else {
            enableScreenSleep()
    
            if sender.tag > 0 {
                // 因为timer.start立马会启动，所以增加1秒
                self.remaining = sender.tag + 1
                
                timer.start(repeating: 1) { [weak self] in
                    guard let self = self else { return }
                    
                    self.remaining -= 1
                    if self.remaining <= 0 {
                        self.disableScreenSleep()
                    }
                }
            } else {
                self.remaining = 0
            }
        }
    }
    
    private func updateStatusItemTimeLabel() {
        
        if SDConfigure.showTimeOnStatusBar, didOpen, self.remaining > 0 {
            statusItem.button?.title = SDTimeConverter.toMinuteAndSecond(second: self.remaining)
            statusItem.length = maxLength + extLength
        } else {
            statusItem.button?.title = ""
            statusItem.length = minLength + extLength
        }
    }
    
    private func enableScreenSleep() {
        if manager.updateBumSteadyStatus(.on, reason: "Make Rest") {
            didOpen = true
        }
        timer.stop()
    }
    
    private func disableScreenSleep() {
        if manager.updateBumSteadyStatus(.off, reason: "Unmake Rest") {
            didOpen = false
        }
        timer.stop()
    }
    
    private func addNotification() {
        observer = NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.disableScreenSleep()
        }
    }
    
    private func removeNotification() {
        guard let observer = observer else {
            return
        }
        NSWorkspace.shared.notificationCenter.removeObserver(observer)
    }
    
//    private func addGlobalMonitor() {
//
//        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] (event) in
//
//            guard let weakSelf = self else { return }
//
//            if weakSelf.popover.isShown {
//                weakSelf.popover.close()
//            }
//        }
//    }
}

