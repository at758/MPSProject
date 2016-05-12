//
//  CatListTableViewController.swift
//  FitCat
//
//  Created by Akshay Tata on 2/6/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit
import Firebase


class CatListTableViewController: UITableViewController{
    
    
    @IBOutlet weak var TitleItem: UINavigationItem!
    //This variable checks for the number of key value pairs within a user entry that are not cat information
    var attributeFlag:Bool = false
    var catNames = [String]()
    var catImages = [NSData]()
    let u_name = floginobj.f_id
    
    //This array stores all the reduction values
    var reductionLabelText = [String]()
     //This array stores all the target date values
    var targetDateLabelText = [String]()
    var tandcmessageString = "By agreeing to the terms of use for the FitCat application, you declare that neither Cornell University, The Cornell Feline Health Center, nor any of their officers, agents, employees, contractors,subcontractors, directors, or students are responsible for any illness or injury (including death) that may occur in any animal or person as a result of the use of this application, nor for any financial indebtedness that may arise as a result of its use."
    var introdiscString = "Thank you for choosing FitCat as a tool to help your kitty achieve a healthy weight and body condition. While we are confident that you will find this application very useful and informative, it is important to recognize that its use should not, in any way, take the place of regular visits to your veterinarian, who is best equipped to provide guidance in your cat’s individual health care plan."
    var deleteIndex:Int = 0
    var myURL = "https://fitcat.firebaseio.com/users"
    var deleteAlert = UIAlertController(title: "Delete Record", message: "Are you sure you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print("I am here now")
        self.refreshControl?.addTarget(self, action: #selector(CatListTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
       
        
    }
    
   func calculateInitialValue()
   {
    
    let fbRef = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
    let reposURL = NSURL(string: "https://fitcat.firebaseio.com/users.json")
    
    catNames.removeAll()
    catImages.removeAll()

    if let JSONData = NSData(contentsOfURL: reposURL!)
    {
        do
        {
        if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
            if let reposArray = json[u_name] as? [String: AnyObject] {
                for (cat_name, val) in reposArray {
                    
                    if(cat_name != "name" && cat_name != "tandccheck")
                    {
                    let nsstring = val["cat_image"] as? NSString
                    let finString = nsstring as! String
                    let datans = NSData(base64EncodedString: finString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        
                   let catBCS = val["catWeightLoss"]
                   //Checking for reduction
                   if((catBCS!) != nil)
                   {
                       if((catBCS as! String) != "")
                        {
                            reductionLabelText.append(catBCS as! String)
                            targetDateLabelText.append(val["catTargetEndDate"] as! NSString as String)
                        }
                    }
                    else
                   {
                            reductionLabelText.append("FitPlan not yet started")
                            targetDateLabelText.append("Target date not calculated")
                        }
                        catImages.append(datans!)
                        catNames.append(cat_name)
                    }
                    else
                    {
                        if(cat_name == "name")
                        {
                        TitleItem.title = "Welcome, " + (val as! String)
                        }
                        
                        else if(cat_name == "tandccheck")
                        {
                            attributeFlag = true
                        }
                        else{
                            attributeFlag = false
                        }
                        
                    }
                }
            }
            }
    //catNames.sortInPlace()
        }catch let error as NSError{
        print(error.localizedDescription)
    }
        
    //Check if attributeFlag, if not, then Terms and Conditions are not added
        if (attributeFlag != true)
        {
            //This variable contains the UIAlert view for the terms and conditions alert view
            let tandcAlert = UIAlertController(title: "Terms and Conditions", message: tandcmessageString, preferredStyle: UIAlertControllerStyle.Alert)
            let introAlert = UIAlertController(title: "Introductory Disclaimer", message: introdiscString, preferredStyle: UIAlertControllerStyle.Alert)
            
            tandcAlert.addAction(UIAlertAction(title: "Agree", style: .Default, handler: {(action: UIAlertAction!) in
                self.presentViewController(introAlert, animated: true, completion: nil)
                
            }))
            
            tandcAlert.addAction(UIAlertAction(title: "Disagree", style: .Default, handler: {(action: UIAlertAction!) in
                
                self.presentViewController(tandcAlert, animated: true, completion: nil)

                
            }))
            
            
            introAlert.addAction(UIAlertAction(title: "Agree", style: .Default, handler: {(action: UIAlertAction!) in
                
                let todaysDate:NSDate = NSDate()
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
                fbRef.updateChildValues(["tandccheck" : DateInFormat + ":Y"]);
                
            }))
            
            introAlert.addAction(UIAlertAction(title: "Disagree", style: .Default, handler: {(action: UIAlertAction!) in
                
                self.presentViewController(introAlert, animated: true, completion: nil)
                
                
            }))

            self.presentViewController(tandcAlert, animated: true, completion: nil)

            
        }
       
    }
    
    
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
     
        calculateInitialValue()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    
    @IBAction func addCat(sender: UIButton) {
        performSegueWithIdentifier("addCatDetails", sender: sender)
    }
    
    func localNotificationReceived(){
        
       let tc = self.parentViewController?.parentViewController
        if tc as? UITabBarController != nil {
           // var tababarController = self.window!.rootViewController as UITabBarController
            //tababarController.selectedIndex = 1
            
            (tc as! UITabBarController).selectedIndex = 1
            print("is a tab bar controller")
        }

        
        
       /* let fc = FeedingViewController()
        self.presentViewController(fc, animated: true, completion: nil)
       */
        
    }
    
    deinit{
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Create the link for data for a new user
        //Add id
        let fbRef = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
        //Add login name
        fbRef.updateChildValues(["name" : floginobj.f_name]);
        
        calculateInitialValue()
    
        self.tableView.reloadData()
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(CatListTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        navigationItem.leftBarButtonItem = editButtonItem()
        
        //Listen to the notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CatListTableViewController.localNotificationReceived), name: "localnot", object: nil)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {(action: UIAlertAction!) in
            
            let fredRef = Firebase(url: "https://fitcat.firebaseio.com/users/" + self.u_name + "/" + self.catNames[self.deleteIndex]);
            fredRef.removeValueWithCompletionBlock({ (error, fredRef) -> Void in
                
                if(error != nil)
                {
                    print("Delete error")
                   
                }
                else
                {
                    self.catNames.removeAtIndex(self.deleteIndex)
                    self.tableView.reloadData()
                }
            })
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //Deleting from firebase
            deleteIndex = indexPath.row
            presentViewController(deleteAlert, animated: true, completion: nil)
        }
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
       // print("Second here")
        return catNames.count
    }

    //height of row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        //print(catNames.count)
        
//        cell.textLabel?.text = catNames[indexPath.row]
//        cell.imageView?.image = UIImage(named: catImages[indexPath.row]);
        
        let image = cell.viewWithTag(101) as!  UIImageView
        image.layer.cornerRadius = image.frame.size.width / 2
        image.layer.masksToBounds = true
        let name = cell.viewWithTag(102) as! UILabel
        
        //Label that stores reduction value
        let reduction = cell.viewWithTag(104) as! UILabel
        //Label that stores the target achievement date
        let targetAchieved = cell.viewWithTag(103) as! UILabel
        
        
        //let state = cell.viewWithTag(104) as! UILabel
        //let plan = cell.viewWithTag(103) as! UILabel
        
        
        image.image = UIImage(data:catImages[indexPath.row])
        name.text = catNames[indexPath.row]
        reduction.text = reductionLabelText[indexPath.row] + " lbs reduced"
        if(reductionLabelText[indexPath.row].hasPrefix("FitPlan"))
        {
            reduction.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            targetAchieved.text = targetDateLabelText[indexPath.row]
        }
        else
        {
            reduction.textColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            targetAchieved.text = "Target should be achieved by " + targetDateLabelText[indexPath.row]

        }
         return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Unwind")
        
        if(segue.identifier == "info")
        {
       let vc = segue.destinationViewController as! InfoViewController
        let indexPath = tableView.indexPathForSelectedRow
        if let index = indexPath {
            vc.image = catImages[index.row]
            vc.name = catNames[index.row]
        }
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("here")
        
        //Change the tab bar item to home
        (self.parentViewController?.parentViewController as! UITabBarController).tabBar.selectedItem?.title = "home"
        
        calculateInitialValue()
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
       
        
        return true
    }*/


    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
