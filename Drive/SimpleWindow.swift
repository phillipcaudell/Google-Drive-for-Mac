//
//  SimpleWindow.swift
//  Drive
//
//  Created by Phillip Caudell on 22/05/2018.
//  Copyright © 2018 Phillip Caudell. All rights reserved.
//

import AppKit

class SimpleWindow: NSWindow {
    func setMinimalStyle() {
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        backgroundColor = NSColor.white
    }
}
