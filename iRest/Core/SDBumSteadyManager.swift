//
//  SDBumSteadyManager.swift
//  iRest
//
//  Created by Sword on 2022/9/6.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Foundation
import IOKit
import IOKit.pwr_mgt

class SDBumSteadyManager {
    // 状态
    enum Status {
        case on
        case off
    }
    
    private var assertionID: IOPMAssertionID = 0
    private var bumSteadySwitch: Status
    
    init(_ bumSteadySwitch: Status = .off) {
        self.bumSteadySwitch = bumSteadySwitch
        
        updateBumSteadyStatus(bumSteadySwitch)
    }
    
    @discardableResult
    func updateBumSteadyStatus(_ status: Status, reason: String = "Unknown reason") -> Bool {
        guard self.bumSteadySwitch != status else {
            return false
        }
        
        self.bumSteadySwitch = status
        
        switch status {
        case .on:
            return kIOReturnSuccess == IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                                   IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                                   reason as CFString,
                                                                   &assertionID)
        case .off:
            return kIOReturnSuccess == IOPMAssertionRelease(assertionID)
        }
    }
    
    deinit {
        updateBumSteadyStatus(.off, reason: "Application Terminate")
    }
}
