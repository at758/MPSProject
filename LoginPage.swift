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

class LoginPage: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

     let ref = Firebase(url: "https://fitcat.firebaseio.com/")
     let facebookLogin = FBSDKLoginManager()
   
    
    @IBAction func NextPage(sender: UIButton) {
        

       
        
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
                           let dest = self.storyboard?.instantiateViewControllerWithIdentifier("MyTabController")
                            self.presentViewController(dest!, animated: true, completion: nil)
                           
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookLogin.logOut()
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
