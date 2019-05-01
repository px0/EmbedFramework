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

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override open func loadView() {
        // Do not call super!
        let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
        let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height*0.95
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "embedReady")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
//        let config = WKWebViewConfiguration()
        
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
                    function onLoadHandler() {
                        // Tell framework Embed is ready
                        try {
                            webkit.messageHandlers.embedReady.postMessage();
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
        
        self.view = webView
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message")
        //This function handles the events coming from javascript. We'll configure the javascript side of this later.
        //We can access properties through the message body, like this:
        guard let response = message.body as? String else { return }
        print(response)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //This function is called when the webview finishes navigating to the webpage.
        //We use this to send data to the webview when it's loaded.
        print("load")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
