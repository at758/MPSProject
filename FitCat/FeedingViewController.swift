//
//  FeedingViewController.swift
//  
//
//  Created by LiMaggie on 3/22/16.
//
//

import UIKit
import Firebase

class FeedingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var food: [Food] = []
    var filteredfood : [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let reportURL = NSURL(string: "https://fitcat.firebaseio.com/food.json")
        if let JSONData = NSData (contentsOfURL: reportURL!){
            do{
                if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary{
                    if let reposArray = json as? [String: AnyObject]{
                        for(food_name, val) in reposArray {
                        let foodCalories = val["Calories"]
                        let foodAmount = val["Amount"]
                        let foodFat = val["Fat"]
                        let foodFiber = val["Fiber"]
                        let foodProtein = val["Protein"]
                        let foodSugar = val["Sugar"]
                            
                       let myfood = Food(name: food_name, calories: (foodCalories as! String), amount: (foodAmount as! String), fat: (foodFat as! String), fiber: (foodFiber as! String), protein: (foodProtein as! String), sugar: (foodSugar as! String))
                        food.append(myfood)

                        }
                    }
                        }
            }catch let error as NSError{
                print(error.localizedDescription)
            }catch {
                // Catch any other errors
            }
        }
        //end
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of row
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController?.searchResultsTableView {
            return filteredfood.count
        } else {
            return food.count}
    }
    
    //height of row
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("foodlist") as UITableViewCell!
        var myfood : Food
        
        if tableView == searchDisplayController?.searchResultsTableView {
            myfood = filteredfood[indexPath.row] as Food
        } else {
           myfood = food[indexPath.row] as Food
        }
        
        
        let foodName = cell.viewWithTag(201) as! UILabel
        let foodCalories = cell.viewWithTag(203) as! UILabel
        let foodAmount = cell.viewWithTag(202) as! UILabel
       
        
        foodName.text = myfood.name
        foodCalories.text = myfood.calories
        foodAmount.text = myfood.amount
        return cell
    }
    
    //Search
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        filteredfood = food.filter(){
            $0.name.rangeOfString(searchString!) != nil
        }
        return true
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
