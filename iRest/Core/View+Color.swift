//
//  NSButton+Color.swift
//  iRest
//
//  Created by Sword on 2022/9/8.
//  Copyright © 2022 DengFeng.Su. All rights reserved.
//

import Foundation
import AppKit

extension NSView {
    
    @discardableResult
    func setBackgroundColor(_ color: NSColor) -> Self {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
        
        return self
    }
    
    @discardableResult
    func setCornerRadius(_ radius: CGFloat) -> Self {
        self.wantsLayer = true
        self.layer?.cornerRadius = radius
        
        return self
    }
}

extension NSButton {

    
    @discardableResult
    func setTitle(title: String, _ color: NSColor? = nil) -> Self {
        
        let attrStr = NSMutableAttributedString(string: title)
        
        if let color = color {
            attrStr.setAttributes([.foregroundColor: color], range: NSMakeRange(0, title.count))
        }
        
        self.attributedTitle = attrStr
        
        return self
    }
}
