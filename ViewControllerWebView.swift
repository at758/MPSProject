//
//  ViewControllerWebView.swift
//  FitCat
//
//  Created by Akshay Tata on 2/24/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

class ViewControllerWebView: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var testView: UIWebView!
    var urlString = ""
    var activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* CGFloat height = [[myWebView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];*/
    
        
      activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
      activityIndicator.frame = testView.frame
        testView.hidden = true
      self.view.addSubview(activityIndicator)
        
      let height = CGFloat( NSNumberFormatter().numberFromString(testView.stringByEvaluatingJavaScriptFromString("document.height")!)!)
        
      let width = CGFloat( NSNumberFormatter().numberFromString(testView.stringByEvaluatingJavaScriptFromString("document.width")!)!)
        
      var frame = testView.frame
        
      frame.size.height = height + 125.0
      frame.size.width = width
      testView.frame = frame
      
        
        
        
      
        
        
       /* CGFloat width = [[myWebView stringByEvaluatingJavaScriptFromString:@"document.width"] floatValue];
            CGRect frame = myWebView.frame;
            frame.size.height = height + 125.0;
            frame.size.width = width;
            myWebView.frame = frame;
            mainScrollView.contentSize = myWebView.bounds.size;*/
        
        
        
        
        
        
       let urlReq = NSURLRequest(URL: NSURL(string: urlString)!)
       testView.loadRequest(urlReq)
        
        
    
    
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        //print("yoyobitch")
        activityIndicator.startAnimating()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        testView.hidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
