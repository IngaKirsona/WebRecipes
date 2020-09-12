//
//  WebViewController.swift
//  WebRecipes
//
//  Created by Inga Kirsona on 12/09/2020.
//  Copyright © 2020 Inga Kirsona. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet var webView: WKWebView!
    var passedValue = ""
    
    
    override func loadView() {
        self.title = "WebView"
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let url = URL(string: passedValue)
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
    }
    

    
}
