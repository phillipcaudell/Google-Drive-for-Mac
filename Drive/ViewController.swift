//
//  ViewController.swift
//  Drive
//
//  Created by Phillip Caudell on 21/05/2018.
//  Copyright © 2018 Phillip Caudell. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.

        let url = URL.init(string: "https://drive.google.com")
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.backgroundColor = NSColor.white
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let viewController = ViewController(nibName: <#T##NSNib.Name?#>, bundle: <#T##Bundle?#>)
        let window = NSWindow(contentViewController: viewController)
        window.makeKey()
        
        print("HELLO NEW WINDOW!?")
        webView.load(navigationAction.request)
        return nil
    }

}

