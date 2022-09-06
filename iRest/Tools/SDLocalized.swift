//
//  SDLocalizedString.swift
//  iRest
//
//  Created by Sword on 2022/9/6.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Foundation

class SDLocalized {
    
    static func string(_ key: String, inBundle: Bundle = Bundle.main, comment: String = "") -> String {
        
        return NSLocalizedString(key, bundle: inBundle, comment: comment)
    }
}
