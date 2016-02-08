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
    var catImages = ["first", "second"]
    let u_name = "akshay_t"
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
   func calculateInitialValue()
   {
    let loc = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
    
    print(loc.description)
    var ctr = 0
   
    
    loc.observeEventType(.Value, withBlock: { snapshot in
        
        if(snapshot.exists())
        {
            
            self.catNames[ctr] =  snapshot.key
            ctr = ctr + 1
        }
        else
        {
            print("Snapshot is null")
        }
        
    })
    
    }
    
    
    @IBAction func addCat(sender: UIButton) {
        performSegueWithIdentifier("addCatDetails", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // calculateInitialValue()
    
        self.tableView.reloadData()

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
        
        
        print("Second here")
        return catNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
         print("Third Here")
        
        cell.textLabel?.text = catNames[indexPath.row]
        cell.imageView?.image = UIImage(named: catImages[indexPath.row]);
        
       
        
        // Configure the cell...
         return cell
        
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
