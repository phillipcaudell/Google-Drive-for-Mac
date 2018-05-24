//
//  ViewController.swift
//  Drive
//
//  Created by Phillip Caudell on 22/05/2018.
//  Copyright © 2018 Phillip Caudell. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKUIDelegate, WKNavigationDelegate {
    
    let webView = WKWebView()
    let activityIndicator = NSProgressIndicator()
    let activityOverlay = NSView()
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 1200, height: 740))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1 Safari/605.1.15"
        
        activityIndicator.isIndeterminate = true
        activityIndicator.style = .spinning
        activityIndicator.isDisplayedWhenStopped = false
        activityIndicator.controlTint = .graphiteControlTint
        webView.addSubview(activityIndicator)
        activityIndicator.startAnimation(nil)
        
        // WKWebView didFinish doesn't always fire when we want it too, so just to be safe
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.activityIndicator.stopAnimation(nil)
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        webView.frame = NSRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 20)
        activityIndicator.frame = NSRect(x: view.bounds.size.width / 2 - 30, y: view.bounds.size.height / 2 - 30, width: 60, height: 60)
    }
    
    func loadRequest(request: URLRequest) {
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let viewController = ViewController()
        let window = SimpleWindow(contentViewController: viewController)
        window.setMinimalStyle()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        viewController.loadRequest(request: navigationAction.request)
        return nil
    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimation(nil)
        if let title = webView.title {
            view.window?.title = title
        }
    }
}
