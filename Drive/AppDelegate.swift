//
//  AppDelegate.swift
//  Drive
//
//  Created by Phillip Caudell on 22/05/2018.
//  Copyright © 2018 Phillip Caudell. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: SimpleWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.setMinimalStyle()
        let vc = ViewController()
        window.contentViewController = vc
        window.makeKey()
        
        let url = URL(string: "https://drive.google.com")
        let request = URLRequest(url: url!)
        vc.loadRequest(request: request)
    }

    @IBAction func handleOpen(_ sender: Any) {
        window.makeKeyAndOrderFront(nil)
    }
    
    @IBAction func handleOpenLocation(_ sender: Any) {
        
        let a = NSAlert()
        a.messageText = "Enter Link Below"
        a.addButton(withTitle: "Go")
        a.addButton(withTitle: "Cancel")
        
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        inputTextField.placeholderString = "drive.google.com"
        a.accessoryView = inputTextField
        
        a.beginSheetModal(for: self.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                let enteredString = inputTextField.stringValue
                let url = URL(string: enteredString)
                if let url = url {
                    self.openWindow(url: url)
                }
            }
        })
    }
    
    @IBAction func handleNewDoc(_ sender: Any) {
        let url = URL(string: "https://docs.google.com/document/create?hl=en")
        openWindow(url: url!)
    }
    
    @IBAction func handleNewSlide(_ sender: Any) {
        let url = URL(string: "https://docs.google.com/presentation/create?hl=en")
        openWindow(url: url!)
    }
    
    @IBAction func handleNewSheet(_ sender: Any) {
        let url = URL(string: "https://docs.google.com/spreadsheets/create?hl=en")
        openWindow(url: url!)
    }
    
    func openWindow(url: URL) {
        let request = URLRequest(url: url)
        
        let viewController = ViewController()
        let window = SimpleWindow(contentViewController: viewController)
        window.setMinimalStyle()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        viewController.loadRequest(request: request)
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        let windowCount = NSApplication.shared.windows.count
        if windowCount == 1 && !window.isVisible {
            window.makeKeyAndOrderFront(nil)
        }
    }
}

