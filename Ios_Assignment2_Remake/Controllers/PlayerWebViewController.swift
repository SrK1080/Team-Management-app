//
//  PlayerWebViewController.swift
//  Assignment1IOS-ShubhamKarekar
//
//  Created by Shubham Karekar on 06/03/2023.
//

import UIKit
import WebKit
import UIKit
import WebKit
class PlayerWebViewController: UIViewController, WKNavigationDelegate {
    
    var pManageObject:PlayerEntity!
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        title="Web Info"
        let url=URL(string: pManageObject.web!)!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures=true
        
        
        // Do any additional setup after loading the view.
    }
    
    func loadaddress(){
        webview.navigationDelegate=self
        view=webview
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
