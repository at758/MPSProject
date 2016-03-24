//
//  TrackingViewController.swift
//  FitCat
//
//  Created by LiMaggie on 3/24/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit
import Firebase

class TrackingViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    //catname
    var catNameArr = [String]()
    var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
    var u_name = floginobj.f_id
    var picker1 = UIPickerView()
    
    //feeding
    var feed: [Feed] = []
    
    @IBOutlet weak var catName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //picker
        let reposURL = NSURL(string: "https://fitcat.firebaseio.com/users.json"
        )
        if let JSONData = NSData(contentsOfURL: reposURL!)
        {
            do
            {
                if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
                    if let reposArray = json[u_name] as? [String: AnyObject] {
                        for (cat_name, _) in reposArray {
                            if(cat_name != "name")
                            {
                                catNameArr.append(cat_name)
                            }
                        }
                    }
                    
                }
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        if (catNameArr[0] != "") {
            catName.text = catNameArr[0]}
        picker1.delegate = self
        picker1.dataSource = self
        
        catName.delegate = self
        catName.inputView = picker1
        
        
        updateFeed()
        }
        
    //update feed
        func updateFeed(){
            let name = catName.text
            feed.removeAll()
            var str = "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (name!)
            
            str = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            let reposURL2 = NSURL(string: str + "/feeding.json")
            
            if let JSONData2 = NSData(contentsOfURL: reposURL2!)
            {
                do
                {
                    if let json = try NSJSONSerialization.JSONObjectWithData(JSONData2, options: []) as? NSDictionary {
                        if let reposArray2 = json as? [String: AnyObject] {
                            for (_, val) in reposArray2 {
                                let feedCalories = val["calories"]
                                let feedDate = val["date"]
                                let feedName = val["foodname"]
                                if(feedCalories != nil && feedDate != nil && feedName != nil){
                                let myfeed = Feed(calories: (feedCalories as! String), date: (feedDate as! String), foodname: (feedName as! String))
                                feed.append(myfeed)
                                }
                            }
                        }
                        
                    }
                }catch let error as NSError{
                    print(error.localizedDescription)
                }
            tableView.reloadData()
        }
    //hide keyboard
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
    }

    
    func dismissKeyboard() {
        self.view.endEditing(true)
        updateFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //piker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return catNameArr.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        catName.text = catNameArr[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catNameArr[row]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // number of row
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return feed.count}
    
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("feedcell") as UITableViewCell!
        var myfeed : Feed
        
        myfeed = feed[indexPath.row] as Feed
        
        let feedDate = cell.viewWithTag(301) as! UILabel
        let feedName = cell.viewWithTag(302) as! UILabel
        let feedCalories = cell.viewWithTag(303) as! UILabel
        
        feedDate.text = myfeed.date
        feedName.text = myfeed.foodname
        feedCalories.text = myfeed.calories
        
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}
