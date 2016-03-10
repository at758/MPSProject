//
//  SearchTableViewController.swift
//  FitCat
//
//  Created by Shun-Chang on 3/9/16.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    let foodItems = ["Wheat Bagel","Bran with Raisins","Regular Instant Coffee",
        "Banana","Cranberry Bagel","Oatmeal", "Fruits Salad", "Fried Sea Bass",
        "Chips", "Chicken Taco"]
    
    var filteredFoodItems = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredFoodItems.count
        } else {
            return self.foodItems.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if (self.resultSearchController.active) {
            cell!.textLabel?.text = self.filteredFoodItems[indexPath.row]
            return cell!
        } else {
            cell!.textLabel?.text = self.foodItems[indexPath.row]
            return cell!
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredFoodItems.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.foodItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredFoodItems = array as! [String]
        
        self.tableView.reloadData()
    }
}