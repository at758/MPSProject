//
//  LoginPage.swift
//  FitCat
//
//  Created by Akshay Tata on 2/6/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class FBCred {
    var f_id : String = ""
    var f_name: String = ""
}

var floginobj = FBCred()    //floginobj

class LoginPage: UIViewController {

     let ref = Firebase(url: "https://fitcat.firebaseio.com/")
    @IBAction func NextPage(sender: UIButton) {
        
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            
           
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            floginobj.f_id = authData.uid.substringFromIndex(authData.uid.startIndex.advancedBy(9))
                            floginobj.f_name = authData.providerData["displayName"] as! String
                            self.performSegueWithIdentifier("catList", sender: sender)
                            
                           
                        }
                })
            }
        })
        
        
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
