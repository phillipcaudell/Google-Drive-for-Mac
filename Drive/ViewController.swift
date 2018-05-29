//
//  ViewController.swift
//  Drive
//
//  Created by Phillip Caudell on 22/05/2018.
//  Copyright © 2018 Phillip Caudell. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WebUIDelegate, WebPolicyDelegate, WebFrameLoadDelegate {
    
    // Was previously using WKWebView, but resizing window in Sheets caused Sheets to throw error
    // https://github.com/phillipcaudell/Google-Drive-for-Mac/issues/3
    let webView = WebView()
    let activityIndicator = NSProgressIndicator()
    var url: URL?
    
    deinit {
        webView.policyDelegate = nil
        webView.uiDelegate = nil
        webView.frameLoadDelegate = nil
    }
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 1200, height: 740))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        webView.uiDelegate = self
        webView.policyDelegate = self
        webView.frameLoadDelegate = self
        webView.frame = NSRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 20)
        // Setting user agent to prevent compatibility warning. Probably a better way but ehhh
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1 Safari/605.1.15"
        webView.autoresizingMask = [.width, .height]
        
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
        activityIndicator.frame = NSRect(x: view.bounds.size.width / 2 - 30, y: view.bounds.size.height / 2 - 30, width: 60, height: 60)
    }
    
    func loadRequest(request: URLRequest) {
        webView.mainFrame.load(request)
        url = request.url!
    }
    
    func webView(_ webView: WebView!, decidePolicyForMIMEType type: String!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        if type != "text/html" {
            listener.ignore()
            // Let's hijack the system's default browser becasue AS IF I'm writing a download manager
            NSWorkspace.shared.open(request.url!)
        }
    }
    
    func webView(_ webView: WebView!, decidePolicyForNewWindowAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, newFrameName frameName: String!, decisionListener listener: WebPolicyDecisionListener!) {
        
        // Having to use this instead of webView:createWebViewWith because request kept returning nil there
        // https://stackoverflow.com/questions/270458/cocoa-webkit-having-window-open-javascript-links-opening-in-an-instance-of
        let viewController = ViewController()
        let window = SimpleWindow(contentViewController: viewController)
        window.setMinimalStyle()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        viewController.loadRequest(request: request)
 
        listener.ignore()
    }
    
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        self.activityIndicator.stopAnimation(nil)
        self.view.window?.title = self.webView.mainFrameTitle
        
        // Add to recently viewed documents
        guard let url = url else {
            return
        }
            
        let newRecent = ["title": self.webView.mainFrameTitle ?? "", "url": url.absoluteString]
        
        var newRecents = [newRecent]
        
        if var recents = UserDefaults.standard.value(forKey: "kRecentDocuments") as? [[String:String]] {
            
            recents = recents.filter { (recent) -> Bool in
                return recent["url"] != newRecent["url"]
            }
            
            newRecents = newRecents + recents
        }
        
        UserDefaults.standard.setValue(newRecents, forKey: "kRecentDocuments")
        (NSApplication.shared.delegate! as! AppDelegate).loadRecentsMenu()
    }
}
