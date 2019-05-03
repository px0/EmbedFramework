//
//  EmbedViewController.swift
//  EmbedFramework
//
//  Created by Nicholas Haley on 2019-05-01.
//  Copyright © 2019 Ada Support. All rights reserved.
//

import UIKit
import WebKit

open class EmbedViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    let userContentController = WKUserContentController()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override open func loadView() {
        // Do not call super!
        let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
        let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height*0.95
        
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        userContentController.add(self, name: "embedReady")
        
        config.userContentController = userContentController
        
        let webView = WKWebView(frame: CGRect.init(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight), configuration: config)

        let html = """
            <html>
              <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                </head>
                <body style="height: 100vh; margin: 0;">
                    <div id="parent-element" style="height: 100vh; width: 100vw;"></div>
                </body>
                <script>
                    window.adaSettings = {
                        parentElement: "parent-element"
                    }
                </script>
                <script
                    async
                    id="__ada"
                    src="https://static.ada.support/embed.js"
                    data-handle="ada-example"
                    onload="onLoadHandler()"
                ></script>
                <script>
                    window.webkit.messageHandlers.embedReady.postMessage("Hello, world!");
                    function onLoadHandler() {
                        // Tell framework Embed is ready
                        try {
                            window.webkit.messageHandlers.embedReady.postMessage("Hello, world!");
                        } catch(err) {
                            console.error('Can not reach native code');
                        }
                    }

                    function triggerEmbed(data) {
                        const decodedData = window.atob(data)
                        const parsedData = JSON.parse(decodedData)
                        return parsedData;
                    }
                </script>
            </html>

        """
        
        webView.loadHTMLString(html, baseURL: nil)
        
        print("blah")
        self.view = webView
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("SOMETHING PLEASE HAPPEN")
        if message.name == "test", let messageBody = message.body as? String {
            print(messageBody)
        }
    }
    
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //This function is called when the webview finishes navigating to the webpage.
        //We use this to send data to the webview when it's loaded.
        print("load")
    }
    
}
