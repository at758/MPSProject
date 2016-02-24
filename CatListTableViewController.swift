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
    
    
    var catNames = [String]()
    var catImages = ["first", "second","skull","user","skull","first","skull","user","skull","user","user","first"]
    let u_name = floginobj.f_id
    var deleteIndex:Int = 0
    
    var myURL = "https://fitcat.firebaseio.com/users"
    
    var deleteAlert = UIAlertController(title: "Delete Record", message: "Are you sure you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
    
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
   func calculateInitialValue()
   {
    
    //print("Hurray")
    
    let reposURL = NSURL(string: "https://fitcat.firebaseio.com/users.json")
    
    catNames.removeAll()

    if let JSONData = NSData(contentsOfURL: reposURL!)
    {
        do
        {
        if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
            
            if let reposArray = json[u_name] as? [String: AnyObject] {
                // 5
                for (cat_name, val) in reposArray {
                    
                    if(cat_name != "name")
                    {
                        catNames.append(cat_name)
                    }
                    else
                    {
                        TitleItem.title = "Welcome, " + (val as! String)
                    }
                    
                }
            }
            
        }
    
    catNames.sortInPlace()
    }catch let error as NSError{
        print(error.localizedDescription)
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
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)

        navigationItem.leftBarButtonItem = editButtonItem()
        
        
        
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

        // delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
       // print("yay")
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //Deleting from firebase
            //print("In here")
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
        let name = cell.viewWithTag(102) as! UILabel
        //let state = cell.viewWithTag(104) as! UILabel
        //let plan = cell.viewWithTag(103) as! UILabel
        
        image.image = UIImage(named:catImages[indexPath.row])
        name.text = catNames[indexPath.row]
        //state.text = catState[indexPath.row]
        //plan.text = catPlan[indexPath.row]
        
        // Configure the cell...
         return cell
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
       // calculateInitialValue()
        
        //self.tableView.reloadData()
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
