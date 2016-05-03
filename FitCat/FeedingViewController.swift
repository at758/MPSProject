/*
 FeedingViewController.swift
 
 Created by Li Maggie on 3/22/16.
 Refactored by Shunchang Bai
 */

import UIKit
import Firebase

class FeedingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  
  var food: [Food] = []
  var filteredfood : [Food] = []
  var resultSearchController = UISearchController()
  
  // MARK: - Table View
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.resultSearchController.active {
      return filteredfood.count
    } else {
      return food.count
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("foodlist") as UITableViewCell!
    var myfood : Food
    if self.resultSearchController.active {
      myfood = filteredfood[indexPath.row] as Food
    } else {
      myfood = food[indexPath.row] as Food
    }
    let foodName = cell.viewWithTag(201) as! UILabel
    let foodperKg = cell.viewWithTag(202) as! UILabel
    let foodcap = cell.viewWithTag(203) as! UILabel
    foodName.text = myfood.name
    foodcap.text = myfood.kcalPerCap
    foodperKg.text = myfood.kcalPerKg
    return cell
  }
}

extension FeedingViewController: UISearchBarDelegate, UISearchResultsUpdating {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    let reportURL = NSURL(string: "https://fitcat.firebaseio.com/CatFood.json")
    if let JSONData = NSData (contentsOfURL: reportURL!) {
      do {
        if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
          if let reposArray = json as? [String: AnyObject] {
            for (food_name, val) in reposArray {
                if let foodCarb  = val["Carb"] as? String{
                    if let foodfat = val["Fat"] as? String{
                        if let foodfiber = val["Fiber"] as? String{
                            if let foodkcalPerCap = val["KcalperCup"] as? String{
                                if let foodkcalPerKg = val["KcalperKg"] as?String{
                                    if let foodProtein = val["Protein"] as? String{
                                        if let foodMoisture = val["Moisture"] as? String{
                                            let myfood = Food(name: food_name, carb: foodCarb, fat:foodfat, fiber:foodfiber, protein: foodProtein, moisture: foodMoisture, kcalPerCap: foodkcalPerCap,
                                                              kcalPerKg:foodkcalPerKg)
                                            food.append(myfood)
 
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      } catch {
        print("There are errors besides NSError")
      }
    }
    self.resultSearchController = ({
      let controller = UISearchController(searchResultsController: nil)
      controller.searchResultsUpdater = self
      controller.dimsBackgroundDuringPresentation = false
      controller.searchBar.sizeToFit()
      controller.searchBar.barStyle = UIBarStyle.Black
      controller.searchBar.barTintColor = UIColor.whiteColor()
      controller.searchBar.backgroundColor = UIColor.clearColor()
      self.tableView.tableHeaderView = controller.searchBar
      return controller
    })()
    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let feed = segue.destinationViewController as! FeedingDetailViewController
    let indexPath = tableView.indexPathForSelectedRow
    if let index = indexPath {
      feed.food = food[index.row]
    }
  }
  
  @IBAction func close(segue: UIStoryboardSegue) {
    tableView.reloadData()
  }

  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResultsForSearchController(searchController: UISearchController){
    filteredfood.removeAll(keepCapacity: false)
    filteredfood = food.filter() {
      $0.name.rangeOfString(searchController.searchBar.text!) != nil
    }
    self.tableView.reloadData()
  }
}