//
//  ViewController.swift
//  HTML Data Grabber
//
//  Created by David Bartholomew on 9/8/16.
//  Copyright © 2016 David Bartholomew. All rights reserved.
//
//  This software just helps with grabbing a specific number from HTML on my university's website.
//  I made it with a friend, shoutout to Kyle, for his app that he is using to make an easier user-friendly
//  Dinig meal plan calculator and helper.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate {
    
    // Outlets
    @IBOutlet weak var webView: UIWebView!
    
    // Variables
    var url: NSURL!
    var timeBool: Bool!
    var timer: NSTimer!
    
    var regexConverter : String = ""
    
    
    // Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ViewController.getHTML), userInfo: nil, repeats: true)
        
    }
    override func viewWillAppear(animated: Bool) {
        loadHomePage()
    }
    
    // Load web view
    func loadHomePage() {
        url = NSURL(string: "https://den.apu.edu/cas/login?service=https%3A//home.apu.edu/psp/PRODPRT/EMPLOYEE/HRMS/h/%3Ftab%3DDEFAULT")
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    func getHTML(){
        let html = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.innerHTML")
        if let page = html {
            parseHTML(page)
        }
    }
    
    // Web view finished loading  **Thanks to Kyle for this handywork
    func webViewDidFinishLoad(webView: UIWebView) {
        // Hide the progress bar
        timeBool = false
        
        // Hard-coded username and password
        let myUser = "username"
        let myPassword = "password"
        
        // Run JavaScript script to automatically login the user
        let result = webView.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');" +
            "script.type = 'text/javascript';" +
            "script.text = \"function myFunction() { " +
            "var userNameField = document.getElementById('username');" +
            "var passwordField = document.getElementById('password');" +
            "var loginButton = document.getElementsByName('submit')[0];" +
            "userNameField.value='\(myUser)';" +
            "passwordField.value='\(myPassword)';" +
            "loginButton.click();" +
            "}\";" +
            "document.getElementsByTagName('head')[0].appendChild(script);")!
        webView.stringByEvaluatingJavaScriptFromString("myFunction();")!
        
    }
    
    // Load progress bar
    func webViewDidStartLoad(webView: UIWebView) {
        timeBool = false
    }
    
    func parseHTML(html: String){
        
        //Parses for the index Of specific location in the HTML
        print(html.indexOf("font-weight: bold;\">"));
        let index1 = html.indexOf("font-weight: bold;\">")
        let s = html
        let r = index1!.advancedBy(20)..<index1!.advancedBy(27)
        
        // Access the string by the range.
        let substring = s[r]
        
        
        //Converts the number to a double
        let str = substring
        let numArray: [Character] = ["0","1","2","3","4","5","6","7","8","9","."]
        let symbolsArray: [Character] = ["$", ",",]
        var finalNumArray: [Character] = []
        
        print("The initial string: \(str)")
        
        for char in str.characters {
            if numArray.contains(char) {
                finalNumArray.append(char)
            } else if symbolsArray.contains(char) {
                // Do nothing
            } else {
                break
            }
        }
        
        print("The final number as a char array: \(finalNumArray)")
        
        //Checks to see if it is N/A or a number then converts it to a double
        var newString: String = ""
        if str.containsString("N/A") {
            newString = "N/A"
            print("N/A")
        } else {
            for char in finalNumArray {
                newString.append(char)
            }
            var myFinalDouble: Double = 0.0
            myFinalDouble = Double(newString)!
            print(myFinalDouble)
        }
        
    }
}

extension String {
    func indexOf(string: String) -> String.Index? {
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex
    }
}



