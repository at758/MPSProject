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

var notificationflag = 0    //This is a flag to check if a notification was received or not

class LoginPage: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

     let ref = Firebase(url: "https://fitcat.firebaseio.com/")
     let facebookLogin = FBSDKLoginManager()
   
    @IBOutlet weak var ActIndicator: UIActivityIndicatorView!
    
    @IBAction func NextPage(sender: UIButton) {
        
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            
            
            
           
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                self.ActIndicator.startAnimating()
                
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            
                            
                            
                            floginobj.f_id = authData.uid.substringFromIndex(authData.uid.startIndex.advancedBy(9))
                            floginobj.f_name = authData.providerData["displayName"] as! String
                            
                            //Check if the notificationflag = 1
                            let dest = self.storyboard?.instantiateViewControllerWithIdentifier("MyTabController")
                            //Initialize an activity indicator object
                            
                            
                            
                            if(notificationflag == 1)
                            {
                                
                                
                                self.presentViewController(dest!, animated: true, completion: nil)
                                
                                
                               let getdest = dest
                               (getdest as! UITabBarController).selectedIndex = 1
                            }
                            else
                            {
                           
                            
                            self.presentViewController(dest!, animated: true, completion: nil)
                            self.ActIndicator.stopAnimating()
                            }
                           
                        }
                })
            }
        })
        
        
        
        //shouldPerformSegueWithIdentifier(catList, sender: sender){
            
       
       
        
    }
    
    
    @IBAction func GoogleSignUp(sender: UIButton) {
        
        // Setup delegates
      
        // Attempt to sign in silently, this will succeed if
        // the user has recently been authenticated
       // GIDSignIn.sharedInstance().signInSilently()
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        
        
       
        
    }
    
    // Implement the required GIDSignInDelegate methods
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                // Auth with Firebase
                ref.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { (error, authData) in
                    // User is logged in!
                    
                    floginobj.f_id = authData.uid.substringFromIndex(authData.uid.startIndex.advancedBy(7))
                    floginobj.f_name = authData.providerData["displayName"] as! String
                    let dest = self.storyboard?.instantiateViewControllerWithIdentifier("MyTabController")
                    self.presentViewController(dest!, animated: true, completion: nil)
                    
                    
                })
            } else {
                // Don't assert this error it is commonly returned as nil
                print("\(error.localizedDescription)")
            }
    }
    
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        ref.unauth()
    }
  
    // Implement the required GIDSignInDelegate methods
    // Unauth when disconnected from Google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            ref.unauth();
    }
    
    func localNotificationReceived(){
        
        let tc = self.parentViewController?.parentViewController
        if tc as? UITabBarController != nil {
            // var tababarController = self.window!.rootViewController as UITabBarController
            //tababarController.selectedIndex = 1
            
            (tc as! UITabBarController).selectedIndex = 1
            print("is a tab bar controller")
        }
        
        notificationflag = 1
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationflag = 0
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        //facebookLogin.logOut()
        
        //Listen to the notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginPage.localNotificationReceived), name: "localnot", object: nil)
        
        
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
