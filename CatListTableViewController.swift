//
//  CatListTableViewController.swift
//  FitCat
//
//  Created by Akshay Tata on 2/6/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

class CatListTableViewController: UITableViewController {

    var catNames = [String]()
    var catImages = ["first", "second","skull","user","skull","first","skull","user"]
    let u_name = "akshay_t"
    
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
                for (cat_name, _) in reposArray {
                    
                    catNames.append(cat_name)
                    
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
        
        calculateInitialValue()
    
        self.tableView.reloadData()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
       //  print("Third Here")
        
        cell.textLabel?.text = catNames[indexPath.row]
        cell.imageView?.image = UIImage(named: catImages[indexPath.row]);
        
       
        
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
    }
    */

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
