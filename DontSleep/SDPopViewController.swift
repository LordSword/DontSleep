//
//  SDPopViewController.swift
//  DontSleep
//
//  Created by Sword on 2021/9/24.
//  Copyright © 2021 DengFeng.Su. All rights reserved.
//

import Cocoa

class SDPopViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func quictClicked(_ sender: Any) {
        
        NSApplication.shared.terminate(sender)
    }
}
