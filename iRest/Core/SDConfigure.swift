//
//  SDConfigure.swift
//  iRest
//
//  Created by Sword on 2022/9/6.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Foundation

class SDConfigure {
    
    struct Key {
        static let showTimeOnStatusBar = "showTimeOnStatusBar"
        static let firstLaunch = "firstLaunch"
    }
    
    static func configDefaultValue() {
        UserDefaults.standard.register(defaults: [Key.showTimeOnStatusBar: true, Key.firstLaunch: true])
    }
    
    static var showTimeOnStatusBar: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.showTimeOnStatusBar)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.showTimeOnStatusBar)
        }
    }
    
    static var firstLaunch: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.firstLaunch)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.firstLaunch)
        }
    }
}
