//
//  SDTimeConverter.swift
//  iRest
//
//  Created by Sword on 2022/9/6.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Foundation

class SDTimeConverter {
    
    class func toMinuteAndSecond(second: Int) -> String {
        let minute = String(format: "%02d", second/60)
        let second = String(format: "%02d", second%60)
        
        return "\(minute):\(second)"
    }
}
