//
//  SDTimer.swift
//  iRest
//
//  Created by Sword on 2022/9/6.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Foundation

class SDTimer {
    var timer: DispatchSourceTimer?
    
    func start(repeating: Double = 1, onQueue: DispatchQueue = DispatchQueue.main, handle: (() -> ())?) {
        if nil != timer {
            stop()
        }
        
        let timer = DispatchSource.makeTimerSource(queue: onQueue)
        timer.schedule(deadline: .now(), repeating: repeating)
        timer.setEventHandler(handler: handle)
        
        timer.resume()
        
        self.timer = timer
    }
    
    func stop() {
        guard let timer = timer else {
            return
        }
        timer.cancel()
    }
}
